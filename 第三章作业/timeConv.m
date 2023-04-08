clear;

%声音信号的采样
T = 3;  %读取音频时间
f=8000;  %人说话的语音频率范围为0-3400hz,f为采样频率
%声音信号的采样
F=48000; %audioread函数默认采样频率为48000hz
filename = '聂文涛.aac';
samples = [1,T*F]; %仅读取前 3 秒的内容
[y_org,F] = audioread(filename,samples);
y_org=y_org(:,1);%由于x是双声道，所以取它的左声道
y_org = resample(y_org,f,F) ; %以频率为f重新采样
n=length(y_org);%获取x的采样点数
dt=1/f;%求采样间隔
time=(0:n-1)*dt;%采样时间点
subplot(221);plot(time,y_org);title('原始声音信号时域波形')
xlabel('时间/s');

%原始信号fft变换
fx=f/n*(0:round(n/2)-1);
fy=fft(y_org);
subplot(222);plot(fx,abs(fy(1:round(n/2))));
title('原始声音信号傅里叶变换');xlabel('Hz');

%fir（默认汉宁窗）滤波器设计
h=fir1(3000,0.5,"low");
y = conv(y_org,h);%卷积运算
y(n+1:length(y)) = [];%将卷积后信号的长度变换为原信号长度
subplot(223);
plot(time,y);
title('卷积法滤波后声音信号时域波形')
xlabel('时间/s');

%滤波后信号fft变换
fx_conv=f/n*(0:round(n/2)-1);
fy=fft(y);
subplot(224);plot(fx_conv,abs(fy(1:round(n/2))));
title('卷积法滤波后声音信号傅里叶变换');xlabel('Hz');

%试听和写入信号
 audiowrite('fir_conv.wav',y,f);
 