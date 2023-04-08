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
fx_filtering=f/n*(0:round(n/2)-1);
fy_filtering=fft(y_org);
subplot(222);plot(fx_filtering,abs(fy_filtering(1:round(n/2))));
title('原始声音信号傅里叶变换');xlabel('Hz');

%巴特沃斯滤波器设计
wp=2000/(f/2);%通带截止频率（数字滤波器作归一化变换）
ws=3000/(f/2);%阻带截止频率（数字滤波器作归一化变换）
Rp=2;%通带最大衰减2dB
As=30;%阻带最小衰减30dB
[N,wc]=buttord(wp,ws,Rp,As);%求滤波器的阶数N与3dB截止频率wc
[b,a]=butter(N,wc);%得到差分方程系数
y=filter(b,a,y_org);%滤波
subplot(223);
plot(time,y);
title('差分方程法滤波后声音信号时域波形');xlabel('时间/s');

%滤波后信号fft变换
fx_filtering=f/n*(0:round(n/2)-1);
fy_filtering=fft(y);
subplot(224);plot(fx_filtering,abs(fy_filtering(1:round(n/2))));
title('差分方程法滤波后声音信号傅里叶变换');xlabel('Hz');

%绘制归一化滤波器参数
%figure(2);
%freqz(b,a);

%写入和试听音频
audiowrite('direct.wav',y,F);
