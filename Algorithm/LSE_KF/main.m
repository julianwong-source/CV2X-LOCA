%% 
% ����������·�����п������˲�
clc
clear

load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\LSE\distance_LSE.mat')

distance_LSE=distance_LSE'   %ת����
kf_params_record = zeros(size(distance_LSE, 1), 4);   % 200*4
for i = 1 : length(distance_LSE)
    if i == 1
        kf_params = kf_init(distance_LSE(i, 1), distance_LSE(i, 2), 0, 0); % ��ʼ��
    else
        kf_params.z = distance_LSE(i, 1:2)'; %���õ�ǰʱ�̵Ĺ۲�λ��
        kf_params = kf_update(kf_params); % �������˲�
    end
    kf_params_record(i, :) = kf_params.x';
end

distance_LSE_KF = kf_params_record(:, 1:2);  

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

distance_LSE_KF = distance_LSE_KF'
error_LSE_KF=sqrt(sum((distance_LSE_KF(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_LSE_KF(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_LSE_KF_high_x = max(max(diff(1,:)))   % x��������
error_LSE_KF_low_x = min(min(diff(1,:)))   % x����С���
error_LSE_KF_high_y = max(max(diff(2,:)))   % y��������
error_LSE_KF_low_y = min(min(diff(2,:)))   % y����С���

mean_error_LSE_KF=mean(error_LSE_KF)            %��λ���

rmse_error_LSE_KF=(sqrt(mean((distance_LSE_KF(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_LSE_KF(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_LSE_KF_high_x=sqrt(mean((distance_LSE_KF(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_LSE_KF_high_y=sqrt(mean((distance_LSE_KF(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_LSE_KF= (mean(abs((distance_LSE_KF(1,:)-trace_1(:,1)'))+mean(abs((distance_LSE_KF(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_LSE_KF= (mean(abs((distance_LSE_KF(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_LSE_KF(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л�����Ļ���������ز���
% save('A','A') 
% save('onlinedata','rssi_noise','distance')                           % 143*68
% save('distance_dim','distance_dim')
% save('AP_x_y_dim','AP_x_dim','AP_y_dim')
% save('rssi_noise_dim','rssi_noise_dim')
save('distance_LSE_KF','distance_LSE_KF')
save('error','error_LSE_KF','error_LSE_KF_high_x','error_LSE_KF_low_x','error_LSE_KF_high_y','error_LSE_KF_low_y','mean_error_LSE_KF','rmse_error_LSE_KF','rmse_error_LSE_KF_high_x','rmse_error_LSE_KF_high_y','mae_error_LSE_KF','mape_error_LSE_KF')    

%%
totall_error = [mean_error_LSE_KF,error_LSE_KF_high_x,error_LSE_KF_low_x,error_LSE_KF_high_y,error_LSE_KF_low_y,rmse_error_LSE_KF,rmse_error_LSE_KF_high_x,rmse_error_LSE_KF_high_y,mae_error_LSE_KF,mape_error_LSE_KF]
save('totall_error','totall_error')

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\LSE_KF\totall_error.mat')