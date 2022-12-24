%%
% ��Test�ĵ���Ŀ�ģ�ѡȡÿ���켣�������4��AP����,��Ӧ�ð붨�滮��SDP��
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
% load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\ML\A.mat')

A = 5

intial_rssi=abs(-37.5721)
distance= 10.^((abs(rssi_noise)-intial_rssi)/(10 * A))               %���й켣�㵽��j��AP�Ĺ��ƾ���
% save('onlinedata','rssi_noise','distance')                           % 143*68

%%
% SDP�㷨Ӧ��֮ǰ��ѡȡ4������ĵ�
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
% �붨�滮(SDP)���
for i=1:length(distance(:,1))    %nΪ200,nΪ��n����λ��   
    
    cvx_begin sdp quiet
    variable y(2,1)
    variable  x(2,2)
    variable t(4,1)
    
    minimize norm(t)
    subject to
    trace(x)-2*([AP_x_dim(i,1),AP_y_dim(i,1)])*y+AP_x_dim(i,1).^2+AP_y_dim(i,1).^2 <=  10.^((abs(rssi_noise_dim(i,1))-intial_rssi)/(10 * A))*t(1,1)
    trace(x)-2*([AP_x_dim(i,2),AP_y_dim(i,2)])*y+AP_x_dim(i,2).^2+AP_y_dim(i,2).^2<=  10.^((abs(rssi_noise_dim(i,2))-intial_rssi)/(10 * A))*t(2,1)
    trace(x)-2*([AP_x_dim(i,3),AP_y_dim(i,3)])*y+AP_x_dim(i,3).^2+AP_y_dim(i,3).^2 <=  10.^((abs(rssi_noise_dim(i,3))-intial_rssi)/(10 * A))*t(3,1)
    trace(x)-2*([AP_x_dim(i,4),AP_y_dim(i,4)])*y+AP_x_dim(i,4).^2+AP_y_dim(i,4).^2 <=  10.^((abs(rssi_noise_dim(i,4))-intial_rssi)/(10 * A))*t(4,1)
    
%     trace(x)-2*([AP_x_dim(i,1),AP_y_dim(i,1)])*y+norm([AP_x_dim(i,1);AP_y_dim(i,1)])<=  10.^((abs(rssi_noise_dim(i,1))-intial_rssi)/(10 * A))*t(1,1)
%     trace(x)-2*([AP_x_dim(i,2),AP_y_dim(i,2)])*y+norm([AP_x_dim(i,2);AP_y_dim(i,2)])<=  10.^((abs(rssi_noise_dim(i,2))-intial_rssi)/(10 * A))*t(1,1)
%     trace(x)-2*([AP_x_dim(i,3),AP_y_dim(i,3)])*y+norm([AP_x_dim(i,3);AP_y_dim(i,3)])<=  10.^((abs(rssi_noise_dim(i,3))-intial_rssi)/(10 * A))*t(1,1)
%     trace(x)-2*([AP_x_dim(i,4),AP_y_dim(i,4)])*y+norm([AP_x_dim(i,4);AP_y_dim(i,4)])<=  10.^((abs(rssi_noise_dim(i,4))-intial_rssi)/(10 * A))*t(1,1)
    
    
    [trace(x)-2*([AP_x_dim(i,1),AP_y_dim(i,1)])*y+AP_x_dim(i,1).^2+AP_y_dim(i,1).^2,sqrt(10.^((abs(rssi_noise_dim(i,1))-intial_rssi)/(10 * A)));
        sqrt(10.^((abs(rssi_noise_dim(i,1))-intial_rssi)/(10 * A))), t(1,1)]>=0
    [trace(x)-2*([AP_x_dim(i,2),AP_y_dim(i,2)])*y+AP_x_dim(i,2).^2+AP_y_dim(i,2).^2,sqrt(10.^((abs(rssi_noise_dim(i,2))-intial_rssi)/(10 * A)));
        sqrt(10.^((abs(rssi_noise_dim(i,2))-intial_rssi)/(10 * A))), t(2,1)]>=0
    [trace(x)-2*([AP_x_dim(i,3),AP_y_dim(i,3)])*y+AP_x_dim(i,3).^2+AP_y_dim(i,3).^2,sqrt(10.^((abs(rssi_noise_dim(i,3))-intial_rssi)/(10 * A)));
        sqrt(10.^((abs(rssi_noise_dim(i,3))-intial_rssi)/(10 * A))), t(3,1)]>=0
    [trace(x)-2*([AP_x_dim(i,4),AP_y_dim(i,4)])*y+AP_x_dim(i,4).^2+AP_y_dim(i,4).^2,sqrt(10.^((abs(rssi_noise_dim(i,4))-intial_rssi)/(10 * A)));
        sqrt(10.^((abs(rssi_noise_dim(i,4))-intial_rssi)/(10 * A))), t(4,1)]>=0
    
    [x,y;y',1]>=0
    
    cvx_end;
        
 distance_SDP_A(:,i)= y 
 
end 

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

error_SDP_A=sqrt(sum((distance_SDP_A(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_SDP_A(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_SDP_A_high_x = max(max(diff(1,:)))   % x��������
error_SDP_A_low_x = min(min(diff(1,:)))   % x����С���
error_SDP_A_high_y = max(max(diff(2,:)))   % y��������
error_SDP_A_low_y = min(min(diff(2,:)))   % y����С���

mean_error_SDP_A=mean(error_SDP_A)            %��λ���

rmse_error_SDP_A=(sqrt(mean((distance_SDP_A(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_SDP_A(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_SDP_A_high_x=sqrt(mean((distance_SDP_A(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_SDP_A_high_y=sqrt(mean((distance_SDP_A(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_SDP_A= (mean(abs((distance_SDP_A(1,:)-trace_1(:,1)'))+mean(abs((distance_SDP_A(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_SDP_A= (mean(abs((distance_SDP_A(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_SDP_A(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л������Ļ���������ز���
save('A','A') 
save('onlinedata','rssi_noise','distance')                           % 143*68
save('distance_dim','distance_dim')
save('AP_x_y_dim','AP_x_dim','AP_y_dim')
save('rssi_noise_dim','rssi_noise_dim')
save('distance_SDP_A','distance_SDP_A')
save('error','error_SDP_A','error_SDP_A_high_x','error_SDP_A_low_x','error_SDP_A_high_y','error_SDP_A_low_y','mean_error_SDP_A','rmse_error_SDP_A','rmse_error_SDP_A_high_x','rmse_error_SDP_A_high_y','mae_error_SDP_A','mape_error_SDP_A')    

%%
totall_error = [mean_error_SDP_A,error_SDP_A_high_x,error_SDP_A_low_x,error_SDP_A_high_y,error_SDP_A_low_y,rmse_error_SDP_A,rmse_error_SDP_A_high_x,rmse_error_SDP_A_high_y,mae_error_SDP_A,mape_error_SDP_A]
save('totall_error','totall_error')

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\SDP_A\totall_error.mat')
