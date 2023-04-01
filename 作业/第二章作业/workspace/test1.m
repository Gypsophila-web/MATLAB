clear
%�����趨
f1 = 400000;%�ź�Ƶ�ʿ�����100 kHz��250 kHz��400 kHz
fs = 500000;%����Ƶ��
dt = 1/fs; % �����������������������Ϊ�����źŵ����ڣ����� = 1/Ƶ��
T1 = 1/f1; %  һ���ź����ڵ�ʱ��

%�ɵò���
t = linspace(0,10*T1,10*200); % ԭ�ź�ÿ�������ڵĵ���Ϊ2000����,ȡ10������
f_ori = sin(2 * pi * f1 * t) ;
%picture(1);
subplot(2,2,1);plot(t, f_ori);title('ԭʼ�ź�');xlabel('t/s');

%����
ts  = 0:dt:10*T1; % �����ź�ʱ�䷶Χ�ڲ���
f1_sample =  sin(2 * pi * f1 * ts) ;
%picture(2);
subplot(2,2,2);
plot(t, f_ori);
hold on ;
stem(ts, f1_sample,'.');
title('�����ź�(500kHz������)');xlabel('t/s');

%fft�任
f_true=fs/length(ts)*(0:length(ts)-1);
k=fft(f1_sample);

subplot(2,2,3);stem(f_true,abs(k),'.');
title('�����źŸ���Ҷ�任');xlabel('kHz');

%�ָ�
y = [];
for i = 1 : length(t)
    x = t(i);
    h = sinc((x - ts).*fs);
    g = dot(f1_sample, h);%�������
    y = [y,g];
end
subplot(2,2,4);plot(t, y);title('�ָ��ź�');xlabel('t/s');