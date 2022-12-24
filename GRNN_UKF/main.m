clc;
clear;

T=1;            % ��������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\GRNN\distance_GRNN.mat')
N= length(distance_GRNN);        % ��������
X=zeros(4,N);   % ��ʼ����ʵ�켣����   4*60

% load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')
distance_GRNN_T = distance_GRNN'
% X(:,1)=[trace_1(1,1),trace_1(2,1)-trace_1(1,1),trace_1(1,2),trace_1(2,2)-trace_1(1,2)];    % Ŀ���ʼλ�á��ٶ�     4*60 ��һ���ǳ�ʼλ��
X(:,1)=[distance_GRNN_T(1,1),distance_GRNN_T(2,1)-distance_GRNN_T(1,1),distance_GRNN_T(1,2),distance_GRNN_T(2,2)-distance_GRNN_T(1,2)];    % Ŀ���ʼλ�á��ٶ�     4*60 ��һ���ǳ�ʼλ��

Z=zeros(2,N);   % ��ʼ�� �۲�������  2*60
Z(:,1) = [distance_GRNN(1,1),distance_GRNN(2,1)];

delta_w=1e-2; 
Q=delta_w*diag([2,2.5,2,2.5]) ;   % ��������Э�������   4*4 �Խ���0.5,1,0.5,1

R=100*eye(2);   % �۲�����Э����  2*2 �Խ���100 100
W = sqrtm(Q)*randn(4,N);   % v��ֵΪ0��Э����ΪR�ĸ�˹������ %sqrt(A)����ÿ��Ԫ�طֱ𿪷�,��������й�;sqrtm(A)����Ϊ����,���������й�
V = sqrt(R)*randn(2,N);    % W��ֵΪ0��Э����ΪQ�ĸ�˹������

F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];  % ״̬ת�ƾ���  4*4
H = [1,0,0,0;0,0,1,0]; 

%%

for t=2:N
    X(:,t)=F*X(:,t-1)+W(:,t-1);      % Ŀ�����ʵ�켣    4*60
end

for t=1:N
    VV(:,t)=distance_GRNN(:,t)-H*X(:,t)   
    Z(:,t)=H*X(:,t)+VV(:,t);         % ���Թ켣
end

R_1 = var(VV)

%%
% UKF�˲�����
L=4;                             % LΪ״̬ά��
alpha=1;                         % a���Ʋ�����ķֲ�״̬
kalpha=0;                        % kΪ��ѡ���� û�н��ޣ�����Ҫ��֤��n+lamda��*PΪ����������
belta=2;                         % b�Ǹ���Ȩϵ��
ramda=alpha*alpha*(L+kalpha)-L;  % lambdaΪ���ű��в��������ڽ����ܵ�Ԥ�����

% sigma���Ȩֵ
for j=1:2*L+1
    Wm(j)=1/(2*(L+ramda));
    Wc(j)=1/(2*(L+ramda));
end
Wm(1)=ramda/(L+ramda);
Wc(1)=ramda/(L+ramda)+1-alpha^2+belta;


%%
% UKF�˲�
Xukf=zeros(4,N);      % 4*60
Xukf(:,1)=X(:,1);     %�޼�Kalman�˲�״̬��ʼ��
P0=10*eye(4);         %Э�������ʼ��    �Խ���Ϊ10

for t=2:N
    xestimate= Xukf(:,t-1);
    P=P0;
    
%%%%%%% ��һ��:���һ������㣬Sigma�㼯 %%%%%%%%%%%%%%    
    cho=(chol(P*(L+ramda)))';  % cho=chol(X)���ڶԾ���X����Cholesky�ֽ⣬����һ����������cho��ʹcho'cho=X����XΪ�ǶԳ������������һ��������Ϣ��
    xgamaP1 = zeros(4,L);
    xgamaP2 = zeros(4,L);
    for k=1:L
        xgamaP1(:,k)=xestimate+cho(:,k);
        xgamaP2(:,k)=xestimate-cho(:,k);
    end
    Xsigma=[xestimate xgamaP1 xgamaP2];    % ��� 2L+1 ��Sigma��

%�ڶ���:��Sigme�㼯����һ��Ԥ��   
    Xsigmapre=F*Xsigma;

%�����������õڶ�����������ֵ��Э����
    Xpred=zeros(4,1);
    for k=1:2*L+1
        Xpred=Xpred+Wm(k)*Xsigmapre(:,k);
    end
    Ppred=zeros(4,4);    %Э������Ԥ��
    for k=1:2*L+1
        Ppred=Ppred+Wc(k)*(Xsigmapre(:,k)-Xpred(:,1))*(Xsigmapre(:,k)-Xpred(:,1))'; %%%%%%%%%%%%%%%%%
    end
    Ppred=Ppred+Q;
 
%���Ĳ�:����Ԥ��ֵ���ٴ�ʹ��UT�任���õ��µ�sigma�㼯
    chor=(chol((L+ramda)*Ppred))';
    XaugsigmaP1 = zeros(4,L);
    XaugsigmaP2 = zeros(4,L);
    for k=1:L
        XaugsigmaP1(:,k)=Xpred+chor(:,k);
        XaugsigmaP2(:,k)=Xpred-chor(:,k);
    end
    Xaugsigma=[Xpred XaugsigmaP1 XaugsigmaP2]; 
    
 %���岽:�۲�Ԥ��   
    Zsigmapre = zeros(2,2*L+1);
    for k=1:2*L+1
        Zsigmapre(:,k)=H*Xaugsigma(:,k);%%%�۲�Ԥ��%%%
    end
      
 %������:����۲�Ԥ���ֵ��Э����   
    Zpred=zeros(2,1);  %�۲�Ԥ��ľ�ֵ
    for k=1:2*L+1
        Zpred=Zpred+Wm(k)*Zsigmapre(:,k);
    end
    Pzz=zeros(2,1);
    for k=1:2*L+1
        Pzz=Pzz+Wc(k)*(Zsigmapre(:,k)-Zpred(:,1))*(Zsigmapre(:,k)-Zpred(:,1))';
    end
    Pzz=Pzz+R;
    
    
    Pxz=0;
    for k=1:2*L+1
        Pxz=Pxz+Wc(k)*(Xaugsigma(:,k)-Xpred(:,1))*(Zsigmapre(:,k)-Zpred(:,1))';
    end
    
 %���߲�:����Kalman����   
    K=Pxz*inv(Pzz);  % Kalman
    
%�ڰ˲�:״̬�ͷ������    
    xestimate=Xpred+K*(Z(:,t)-Zpred(:,1));  % ״̬����
    P=Ppred-K*Pzz*K';%�������
    P0=P;
    
    Xukf(:,t)=xestimate;
end

distance_GRNN_UKF = [Xukf(1,:);Xukf(3,:)]

%%
% �������
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\Environment_setting\trace_1.mat')

error_GRNN_UKF=sqrt(sum((distance_GRNN_UKF(1:2,:)-trace_1').^2))./2   %���

diff = abs(distance_GRNN_UKF(1:2,:)-trace_1')  % Ԥ��ֵ����ʵֵ�Ĳ��
error_GRNN_UKF_high_x = max(max(diff(1,:)))   % x��������
error_GRNN_UKF_low_x = min(min(diff(1,:)))   % x����С���
error_GRNN_UKF_high_y = max(max(diff(2,:)))   % y��������
error_GRNN_UKF_low_y = min(min(diff(2,:)))   % y����С���

mean_error_GRNN_UKF=mean(error_GRNN_UKF)            %��λ���

rmse_error_GRNN_UKF=(sqrt(mean((distance_GRNN_UKF(1,:)-trace_1(:,1)').^2))+sqrt(mean((distance_GRNN_UKF(2,:)-trace_1(:,2)').^2)))/2  % RMSE
rmse_error_GRNN_UKF_high_x=sqrt(mean((distance_GRNN_UKF(1,:)-trace_1(:,1)').^2))   % x���RMSE
rmse_error_GRNN_UKF_high_y=sqrt(mean((distance_GRNN_UKF(2,:)-trace_1(:,2)').^2))   % y���RMSE

mae_error_GRNN_UKF= (mean(abs((distance_GRNN_UKF(1,:)-trace_1(:,1)'))+mean(abs((distance_GRNN_UKF(2,:)-trace_1(:,2)'))))/2)     % MAE
mape_error_GRNN_UKF= (mean(abs((distance_GRNN_UKF(1,:)-trace_1(:,1)')./trace_1(:,1)'))+mean(abs((distance_GRNN_UKF(2,:)-trace_1(:,2)')./trace_1(:,2)')))/2   %MAPE

%%
% ����������л�����Ļ���������ز���
% save('A','A') 
% save('onlinedata','rssi_noise','distance')                           % 143*68
% save('distance_dim','distance_dim')
% save('AP_x_y_dim','AP_x_dim','AP_y_dim')
% save('rssi_noise_dim','rssi_noise_dim')
save('distance_GRNN_UKF','distance_GRNN_UKF')
save('error','error_GRNN_UKF','error_GRNN_UKF_high_x','error_GRNN_UKF_low_x','error_GRNN_UKF_high_y','error_GRNN_UKF_low_y','mean_error_GRNN_UKF','rmse_error_GRNN_UKF','rmse_error_GRNN_UKF_high_x','rmse_error_GRNN_UKF_high_y','mae_error_GRNN_UKF','mape_error_GRNN_UKF')    

totall_error = [mean_error_GRNN_UKF,error_GRNN_UKF_high_x,error_GRNN_UKF_low_x,error_GRNN_UKF_high_y,error_GRNN_UKF_low_y,rmse_error_GRNN_UKF,rmse_error_GRNN_UKF_high_x,rmse_error_GRNN_UKF_high_y,mae_error_GRNN_UKF,mape_error_GRNN_UKF]
save('totall_error','totall_error')

%%

clc;
clear;
load('D:\MATLAB\R2016b\bin\7. TITS\Test1_��λ����\����7-˥��1-����1\GRNN_UKF\totall_error.mat')

