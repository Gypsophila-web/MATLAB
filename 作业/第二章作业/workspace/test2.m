clear
f=3400;  %��˵��������Ƶ�ʷ�ΧΪ0-3400hz
T = 3;  %��ȡ��Ƶʱ��
%�����źŵĲ���
F=48000;%audioread����Ĭ�ϲ���Ƶ��Ϊ48000hz
filename = '������.aac';
samples = [1,T*F]; %����ȡǰ 3 �������
[y_org,F] = audioread(filename,samples);
y_org=y_org(:,1);%����x��˫����������ȡ����������
y_org = resample(y_org,f,F) ; %��Ƶ��Ϊ3400hz���²���
n=length(y_org);%��ȡx�Ĳ�������
dt=1/f;%��������
time=(0:n-1)*dt;%����ʱ���
subplot(321);plot(time,y_org);
title('ԭʼ�����ź�ʱ����');xlabel('ʱ��/s');axis([0 3 -0.3 0.3]);

%ԭʼ�ź�fft�任
fx_org=f/n*(0:round(n/2)-1);
fy_org=fft(y_org);
subplot(322);plot(fx_org,abs(fy_org(1:round(n/2))));
title('ԭʼ�����źŸ���Ҷ�任');xlabel('Hz');

%��ԭʼ�źŽ��в���
fs=f*0.1; %�µĲ�����,fs=f*2Ϊ�ٽ������fs=f*4Ϊ��������fs=f*0.1ΪǷ����
y_sam = resample(y_org,fs,f) ;
n1=length(y_sam);%��ȡy�Ĳ�������
time_sam=(0:n1-1)/fs;%�µĲ���ʱ���
subplot(323);
plot(time_sam,y_sam);
title('Ƿ�����ź�ʱ����')
xlabel('ʱ��/s');axis([0 3 -0.3 0.3]);

%��������ź�fft�任
fx_sam=fs/n1*(0:round(n1/4)-1);
fy_sam=fft(y_sam);
subplot(324);plot(fx_sam,abs(fy_sam(1:round(n1/4))));
title('Ƿ�����źŸ���Ҷ�任');xlabel('Hz');

%�ؽ��ź�
n2 = 0:T*fs;
t_re=0:1/fs:T;
xr=zeros(fs*T+1,1);
for i=0:fs*T
    if floor(i*3400/fs+1) <= length(y_org)
    xr(i+1)=y_org(floor(i*3400/fs+1));
    else
        xr(i+1) = 0;
    end
end
T_N = ones(length(n2),1)*t_re-n2'*ones(1,length(t_re))/fs;
y_re = xr'*sinc(2*pi*fs*T_N);    %�ڲ幫ʽ����
subplot(325);plot(t_re,y_re);title('��ԭ�ź�');axis([0 3 -0.3 0.3]);
%sound(y_re,fs) �����ؽ������Ƶ

%��ԭ�ź�fft�任
fx_re=fs/length(t_re)*(0:round(n1/4)-1);
fy_re=fft(y_re);
subplot(326);plot(fx_re,abs(fy_re(1:round(n1/4))));
title('��ԭ�źŸ���Ҷ�任');xlabel('Hz');