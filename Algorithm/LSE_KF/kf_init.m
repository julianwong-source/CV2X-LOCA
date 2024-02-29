function kf_params = kf_init(Px, Py, Vx, Vy)
%% �����У�״̬xΪ������x�� ����y�� �ٶ�x�� �ٶ�y�����۲�ֵzΪ������x�� ����y��

    kf_params.B = 0; %�ⲿ����Ϊ0
    kf_params.u = 0; %�ⲿ����Ϊ0
    kf_params.K = NaN; %���������������ʼ��
    kf_params.z = NaN; %���������ʼ����ÿ��ʹ��kf_update֮ǰ��Ҫ����۲�ֵz
    kf_params.P = zeros(4, 4); %��ʼP��Ϊ0

    %% ��ʼ״̬�������ⲿ�ṩ��ʼ����״̬������ʹ�ù۲�ֵ���г�ʼ����Vx��Vy��ʼΪ0
    kf_params.x = [Px; Py; Vx; Vy];

    %% ״̬ת�ƾ���A
    kf_params.A = eye(4) + diag(ones(1, 2), 2); % ������ϵͳ��Ԥ������йأ����������ϵͳ����һ�̵�λ�ü����ٶȵ��ڵ�ǰʱ�̵�λ�ã����ٶȱ������ֲ���

    %% Ԥ������Э�������Q������Ԥ������ϵ���һ����˹������Э�������ΪQ
    %��Сȡ���ڶ�Ԥ����̵����γ̶ȡ����磬������Ϊ�˶�Ŀ����y���ϵ��ٶȿ��ܲ����٣���ô���԰�����ԽǾ�������һ��ֵ������ʱϣ�������Ĺ켣��ƽ�������԰��������С
    kf_params.Q = diag(ones(4, 1) * 0.001); 

    %% �۲����H��z = H * x
    kf_params.H = eye(2, 4); % �����״̬�ǣ�����x�� ����y�� �ٶ�x�� �ٶ�y�����۲�ֵ�ǣ�����x�� ����y��������H = eye(2, 4)

    %% �۲�����Э�������R������۲�����ϴ���һ����˹������Э�������ΪR
    kf_params.R = diag(ones(2, 1) * 2); %��Сȡ���ڶԹ۲���̵����γ̶ȡ����磬����۲����е�����xֵ������׼ȷ����ô����R�ĵ�һ��ֵӦ�ñȽ�С
end