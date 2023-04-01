clear
%参数设定
f1 = 400000;%信号频率可设置100 kHz、250 kHz、400 kHz
fs = 500000;%采样频率
dt = 1/fs; % 采样间隔，采样间隔可以理解为采样信号的周期，周期 = 1/频率
T1 = 1/f1; %  一个信号周期的时间

%可得参数
t = linspace(0,10*T1,10*200); % 原信号每个周期内的点数为2000个点,取10个周期
f_ori = sin(2 * pi * f1 * t) ;
%picture(1);
subplot(2,2,1);plot(t, f_ori);title('原始信号');xlabel('t/s');

%采样
ts  = 0:dt:10*T1; % 整个信号时间范围内采样
f1_sample =  sin(2 * pi * f1 * ts) ;
%picture(2);
subplot(2,2,2);
plot(t, f_ori);
hold on ;
stem(ts, f1_sample,'.');
title('采样信号(500kHz采样率)');xlabel('t/s');

%fft变换
f_true=fs/length(ts)*(0:length(ts)-1);
k=fft(f1_sample);

subplot(2,2,3);stem(f_true,abs(k),'.');
title('采样信号傅里叶变换');xlabel('kHz');

%恢复
y = [];
for i = 1 : length(t)
    x = t(i);
    h = sinc((x - ts).*fs);
    g = dot(f1_sample, h);%向量相乘
    y = [y,g];
end
subplot(2,2,4);plot(t, y);title('恢复信号');xlabel('t/s');