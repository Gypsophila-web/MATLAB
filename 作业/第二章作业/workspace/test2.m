clear
f=3400;  %人说话的语音频率范围为0-3400hz
T = 3;  %读取音频时间
%声音信号的采样
F=48000;%audioread函数默认采样频率为48000hz
filename = '聂文涛.aac';
samples = [1,T*F]; %仅读取前 3 秒的内容
[y_org,F] = audioread(filename,samples);
y_org=y_org(:,1);%由于x是双声道，所以取它的左声道
y_org = resample(y_org,f,F) ; %以频率为3400hz重新采样
n=length(y_org);%获取x的采样点数
dt=1/f;%求采样间隔
time=(0:n-1)*dt;%采样时间点
subplot(321);plot(time,y_org);
title('原始声音信号时域波形');xlabel('时间/s');axis([0 3 -0.3 0.3]);

%原始信号fft变换
fx_org=f/n*(0:round(n/2)-1);
fy_org=fft(y_org);
subplot(322);plot(fx_org,abs(fy_org(1:round(n/2))));
title('原始声音信号傅里叶变换');xlabel('Hz');

%对原始信号进行采样
fs=f*0.1; %新的采样率,fs=f*2为临界采样，fs=f*4为过采样，fs=f*0.1为欠采样
y_sam = resample(y_org,fs,f) ;
n1=length(y_sam);%获取y的采样点数
time_sam=(0:n1-1)/fs;%新的采样时间点
subplot(323);
plot(time_sam,y_sam);
title('欠采样信号时域波形')
xlabel('时间/s');axis([0 3 -0.3 0.3]);

%采样后的信号fft变换
fx_sam=fs/n1*(0:round(n1/4)-1);
fy_sam=fft(y_sam);
subplot(324);plot(fx_sam,abs(fy_sam(1:round(n1/4))));
title('欠采样信号傅里叶变换');xlabel('Hz');

%重建信号
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
y_re = xr'*sinc(2*pi*fs*T_N);    %内插公式计算
subplot(325);plot(t_re,y_re);title('还原信号');axis([0 3 -0.3 0.3]);
%sound(y_re,fs) 播放重建后的音频

%还原信号fft变换
fx_re=fs/length(t_re)*(0:round(n1/4)-1);
fy_re=fft(y_re);
subplot(326);plot(fx_re,abs(fy_re(1:round(n1/4))));
title('还原信号傅里叶变换');xlabel('Hz');
