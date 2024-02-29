%%
% ��Test�ĵ���Ŀ�ģ�ѡȡÿ���켣�������4��AP����,��Ӧ�ü�Ȩ��С���˷���WLSM��
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

%%
% LSE�㷨Ӧ��֮ǰ��ѡȡ4������ĵ�
distance_sort=sort(distance,2)  %��������
for k=1:length(distance(:,1))
    index(k,:)=find(distance(k,:)<=distance_sort(k,4)) %�������С�������ĸ��������������4
end
distance_dim=distance_sort(:,1:4)    %4������ĵ�Ĺ��ƾ��룬���������3
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
AP_z_dim=zeros(length(AP_y_dim),size(AP_x_dim,2))  %AP��z�ᣨȫΪ0��,�������ҪZ�ᣬ��ɾ����һ��
% save('rssi_noise_dim','rssi_noise_dim')

%%
% ��Ȩ��С���˷�
for p=1:length(distance_dim(:,1))  %d�����d���켣��
    X=AP_x_dim(p,:)
    Y=AP_y_dim(p,:)
    Z=AP_z_dim(p,:)
    d_LSE=distance_dim(p,:)'  %����������������������
    distance_WLSE(:,p)=Algo_WLSE(X,Y,Z,d_LSE)
end
%save('distance_WLSE','distance_WLSE')

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

error_WLSE=sqrt(sum((distance_WLSE(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_WLSE(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_WLSE_high_x = max(max(diff(1,:)))   % x��������
error_WLSE_low_x = min(min(diff(1,:)))   % x����С���
error_WLSE_high_y = max(max(diff(2,:)))   % y��������
error_WLSE_low_y = min(min(diff(2,:)))   % y����С���

mean_error_WLSE=mean(error_WLSE)            %��λ���

rmse_error_WLSE=(sqrt(mean((distance_WLSE(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_WLSE(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_WLSE_high_x=sqrt(mean((distance_WLSE(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_WLSE_high_y=sqrt(mean((distance_WLSE(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_WLSE= (mean(abs((distance_WLSE(1,:)-trace_1(:,1)'))+mean(abs((distance_WLSE(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_WLSE= (mean(abs((distance_WLSE(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_WLSE(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л�����Ļ���������ز���
save('A','A') 
save('onlinedata','rssi_noise','distance')                           % 143*68
save('distance_dim','distance_dim')
save('AP_x_y_dim','AP_x_dim','AP_y_dim')
save('rssi_noise_dim','rssi_noise_dim')
save('distance_WLSE','distance_WLSE')
save('error','error_WLSE','error_WLSE_high_x','error_WLSE_low_x','error_WLSE_high_y','error_WLSE_low_y','mean_error_WLSE','rmse_error_WLSE','rmse_error_WLSE_high_x','rmse_error_WLSE_high_y','mae_error_WLSE','mape_error_WLSE')    

%%
totall_error = [mean_error_WLSE,error_WLSE_high_x,error_WLSE_low_x,error_WLSE_high_y,error_WLSE_low_y,rmse_error_WLSE,rmse_error_WLSE_high_x,rmse_error_WLSE_high_y,mae_error_WLSE,mape_error_WLSE]
save('totall_error','totall_error')

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\WLSE\totall_error.mat')