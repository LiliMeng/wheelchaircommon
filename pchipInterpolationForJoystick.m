clear all
clc
fileID = fopen('JoyAndTime.txt');
C = textscan(fileID, '%s %s %s %s');


N=size(C{1},1);

m1=str2mat(C{1});
m2=str2mat(C{2});
m3=str2mat(C{3});
m4=str2mat(C{4});
for i = 1:N
    timestamp1(i,:)=str2double(m1(i,:))-str2double(m1(1,:));
    timeInterval(i,:)=str2double(m2(i,:))*10^(-9);
    timestamp(i,:)=timestamp1(i,:)+timeInterval(i,:);
    forward_backward(i,:)=str2double(C{3}{i});
    left_right(i,:)=str2double(C{4}{i});
end



figure
% the timeInterval for interpolation
newTimeInterval = 0:1/16:timestamp(N);
timestampT = transpose(timestamp);
forward_backwardT = transpose(forward_backward);
p = pchip(timestampT, forward_backwardT,newTimeInterval);

plot(newTimeInterval, p, 'ro', newTimeInterval, p, 'r', timestamp, forward_backward,'-.',timestamp, forward_backward,'b*')
t=title('Joystick forward backward deflection with the timestamp');
le=legend('pchip data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le, 'FontSize', 16);
set(t, 'FontSize', 20);
xl=xlabel('timestamp');
yl=ylabel('joystick forward_backward deflection')
set(xl, 'FontSize', 18);
set(yl, 'FontSize', 18);


fclose(fileID);
