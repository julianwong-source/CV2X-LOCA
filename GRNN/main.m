%%
% ��Test�ĵ���Ŀ�ģ�ѡȡÿ���켣�������4��AP����,��Ӧ��GRNN+UKF
% ע�⣺Nȡ���4����
%  AP_x_dim,  AP_y_dim,  AP_Z_dim ���ݸ�ʽ��143*4

clc;
clear;

load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\rssi_noise.mat')
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\AP.mat')

%%
% ������Ӱ˥��ģ�ͣ�����RSSIֵ���ƾ���
% A=1+abs(normrnd(0,1.5)) %˥������matlab    ��������Ϊ��2.6971
% Ϊ��ʧһ���ԣ�ͳһΪLSE��A
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\ML\A.mat')


intial_rssi=abs(-37.5721)
distance= 10.^((abs(rssi_noise)-intial_rssi)/(10 * A))               %���й켣�㵽��j��AP�Ĺ��ƾ���
% save('onlinedata','rssi_noise','distance')                           % 143*68

% (�������������ֵ����GRNNҪѧϰ����ֵ)

%%
% LSE�㷨Ӧ��֮ǰ��ѡȡ4������ĵ�
distance_sort=sort(distance,2)  %��������
for k=1:length(distance(:,1))
    index(k,:)=find(distance(k,:)<=distance_sort(k,3)) %�������С�������ĸ��������������4
end
distance_dim=distance_sort(:,1:3)    %4������ĵ�Ĺ��ƾ��룬���������3
% save('distance_dim','distance_dim')

%% 
% 4������ĵ��AP����λ��
AP_x=AP(:,1)  %AP��x��
AP_y=AP(:,2)  %AP��y��
for n=1:length(distance(:,1))    %nΪ143,nΪ��n����λ��
    for m=1:length(index(1,:))    %mΪ4���ܹ���4��
       mm=index(n,m)   %ȡ����n�е�m�е�����
       AP_x_dim(n,m)=AP_x(mm)   %���ڵ�n����λ�㣬ȡ��AP��x��
       AP_y_dim(n,m)=AP_y(mm)   %���ڵ�n����λ�㣬ȡ��AP��y��
    end
end
% save('AP_x_y_dim','AP_x_dim','AP_y_dim')

%%
% �ĸ����λ�õ�����
for n=1:length(distance(:,1))    %nΪ143,nΪ��n����λ��
    for m=1:length(index(1,:))    %mΪ4���ܹ���4��
        mm=index(n,m)   %ȡ����n�е�m�е�����
        rssi_noise_dim(n,m)= rssi_noise(mm)
    end
end
% save('rssi_noise_dim','rssi_noise_dim')

%%
% GRNN
desired_spread_grnn=0.7     %�⻬����
net_grnn=newgrnn(rssi_noise,distance,desired_spread_grnn);   %ѵ�����磬�õ�net_grnn

predict_distance_GRNN=sim(net_grnn,rssi_noise_dim)          %Ԥ������:A1�豸

%%
% ���㶨λ��
for p=1:length(predict_distance_GRNN(:,1))  %d�����d���켣��
    X=AP_x_dim(p,:)
    Y=AP_y_dim(p,:)
    xa = X(:,1)
    xb = X(:,2)
    xc = X(:,3)
    ya = Y(:,1)
    yb = Y(:,2)
    yc = Y(:,3)
    d_tri=predict_distance_GRNN(p,:)'  %����������������������
    da = d_tri(1,:)
    db = d_tri(2,:)
    dc = d_tri(3,:)
    [locx,locy]=triposition(xa,ya,da,xb,yb,db,xc,yc,dc) 
    distance_GRNN(:,p)=[locx,locy]
end

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

% distance_GRNN = distance_GRNN'

error_GRNN=sqrt(sum((distance_GRNN(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_GRNN(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_GRNN_high_x = max(max(diff(1,:)))   % x��������
error_GRNN_low_x = min(min(diff(1,:)))   % x����С���
error_GRNN_high_y = max(max(diff(2,:)))   % y��������
error_GRNN_low_y = min(min(diff(2,:)))   % y����С���

mean_error_GRNN=mean(error_GRNN)            %��λ���

rmse_error_GRNN=(sqrt(mean((distance_GRNN(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_GRNN(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_GRNN_high_x=sqrt(mean((distance_GRNN(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_GRNN_high_y=sqrt(mean((distance_GRNN(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_GRNN= (mean(abs((distance_GRNN(1,:)-trace_1(:,1)'))+mean(abs((distance_GRNN(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_GRNN= (mean(abs((distance_GRNN(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_GRNN(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л�����Ļ���������ز���
save('A','A') 
save('onlinedata','rssi_noise','distance')                           % 143*68
save('distance_dim','distance_dim')
save('AP_x_y_dim','AP_x_dim','AP_y_dim')
save('rssi_noise_dim','rssi_noise_dim')
save('distance_GRNN','distance_GRNN')
save('error','error_GRNN','error_GRNN_high_x','error_GRNN_low_x','error_GRNN_high_y','error_GRNN_low_y','mean_error_GRNN','rmse_error_GRNN','rmse_error_GRNN_high_x','rmse_error_GRNN_high_y','mae_error_GRNN','mape_error_GRNN')    

%%
totall_error = [mean_error_GRNN,error_GRNN_high_x,error_GRNN_low_x,error_GRNN_high_y,error_GRNN_low_y,rmse_error_GRNN,rmse_error_GRNN_high_x,rmse_error_GRNN_high_y,mae_error_GRNN,mape_error_GRNN]
save('totall_error','totall_error')

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\GRNN\totall_error.mat')

