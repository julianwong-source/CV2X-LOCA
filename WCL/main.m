%%
% ��Test�ĵ���Ŀ�ģ�ѡȡÿ���켣�������3��AP����,��Ӧ�ü�Ȩ���Ķ�λ��WCL��
% ע�⣺Nȡ���3����
%  AP_x_dim,  AP_y_dim,  AP_Z_dim ���ݸ�ʽ��143*3

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
% LSE�㷨Ӧ��֮ǰ��ѡȡ3������ĵ�
distance_sort=sort(distance,2)  %��������
for k=1:length(distance(:,1))
    index(k,:)=find(distance(k,:)<=distance_sort(k,4)) %�������С�������ĸ��������������3
end
distance_dim=distance_sort(:,1:4)    %3������ĵ�Ĺ��ƾ��룬���������3
% save('distance_dim','distance_dim')

%% 
% 3������ĵ��AP����λ��
AP_x=AP(:,1)  %AP��x��
AP_y=AP(:,2)  %AP��y��
for n=1:length(distance(:,1))    %nΪ143,nΪ��n����λ��
    for m=1:length(index(1,:))    %mΪ3���ܹ���3��
       mm=index(n,m)   %ȡ����n�е�m�е�����
       AP_x_dim(n,m)=AP_x(mm)   %���ڵ�n����λ�㣬ȡ��AP��x��
       AP_y_dim(n,m)=AP_y(mm)   %���ڵ�n����λ�㣬ȡ��AP��y��
    end
end
% save('AP_x_y_dim','AP_x_dim','AP_y_dim')

%%
% �������λ�õ�����
for n=1:length(distance(:,1))    %nΪ143,nΪ��n����λ��
    for m=1:length(index(1,:))    %mΪ3���ܹ���3��
        mm=index(n,m)   %ȡ����n�е�m�е�����
        rssi_noise_dim(n,m)= rssi_noise(mm)
    end
end
AP_z_dim=zeros(length(AP_y_dim),size(AP_x_dim,2))  %AP��z�ᣨȫΪ0��,�������ҪZ�ᣬ��ɾ����һ��
% save('rssi_noise_dim','rssi_noise_dim')

%%
% ��Ȩ�����㷨
len=size(AP_x_dim,2)    
for i=1:length(distance_dim(:,1))  
    x1=0.1;
    y1=0.1;
    dq=0.02;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ����
    for j=1:len
        x1=x1+AP_x_dim(i,j)/distance_dim(i,j);
        y1=y1+AP_y_dim(i,j)/distance_dim(i,j);
        dq=dq+1/distance_dim(i,j);
    end
    distance_WCL(:,i)= [x1/dq;y1/dq];
end

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

error_WCL=sqrt(sum((distance_WCL(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_WCL(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_WCL_high_x = max(max(diff(1,:)))   % x��������
error_WCL_low_x = min(min(diff(1,:)))   % x����С���
error_WCL_high_y = max(max(diff(2,:)))   % y��������
error_WCL_low_y = min(min(diff(2,:)))   % y����С���

mean_error_WCL=mean(error_WCL)            %��λ���

rmse_error_WCL=(sqrt(mean((distance_WCL(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_WCL(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_WCL_high_x=sqrt(mean((distance_WCL(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_WCL_high_y=sqrt(mean((distance_WCL(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_WCL= (mean(abs((distance_WCL(1,:)-trace_1(:,1)'))+mean(abs((distance_WCL(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_WCL= (mean(abs((distance_WCL(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_WCL(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л�����Ļ���������ز���
save('A','A') 
save('onlinedata','rssi_noise','distance')                           % 143*68
save('distance_dim','distance_dim')
save('AP_x_y_dim','AP_x_dim','AP_y_dim')
save('rssi_noise_dim','rssi_noise_dim')
save('distance_WCL','distance_WCL')
save('error','error_WCL','error_WCL_high_x','error_WCL_low_x','error_WCL_high_y','error_WCL_low_y','mean_error_WCL','rmse_error_WCL','rmse_error_WCL_high_x','rmse_error_WCL_high_y','mae_error_WCL','mape_error_WCL')    

%%
totall_error = [mean_error_WCL,error_WCL_high_x,error_WCL_low_x,error_WCL_high_y,error_WCL_low_y,rmse_error_WCL,rmse_error_WCL_high_x,rmse_error_WCL_high_y,mae_error_WCL,mape_error_WCL]
save('totall_error','totall_error')

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\WCL\totall_error.mat')