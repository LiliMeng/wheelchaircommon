clear all
clc
fileID1= fopen('JoyAndTime.txt');
C = textscan(fileID1, '%s %s %s %s');


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



% the timeInterval for interpolation
newTimeInterval = 0:1/16:timestamp(N);
timestampT = transpose(timestamp);
forward_backwardT = transpose(forward_backward);
left_rightT = transpose(left_right);
p_forward_backward = pchip(timestampT, forward_backwardT,newTimeInterval);
p_left_right = pchip(timestampT, left_rightT,newTimeInterval);

figure 

plot(newTimeInterval, p_forward_backward, 'ro', newTimeInterval, p_forward_backward, 'r', timestamp, forward_backward,'-.',timestamp, forward_backward,'b*')
t=title('Joystick forward backward deflection with the timestamp');
le=legend('pchip data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le, 'FontSize', 16);
set(t, 'FontSize', 20);
xl=xlabel('timestamp');
yl=ylabel('joystick forward backward deflection')
set(xl, 'FontSize', 18);
set(yl, 'FontSize', 18);


figure

plot(newTimeInterval, p_left_right, 'ro', newTimeInterval, p_left_right, 'r', timestamp, left_right,'-.',timestamp, left_right,'b*')
t1=title('Joystick left right deflection with the timestamp');
le1=legend('pchip data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le1, 'FontSize', 16);
set(t1, 'FontSize', 20);
xl1=xlabel('timestamp');
yl1=ylabel('joystick left right deflection')
set(xl1, 'FontSize', 18);
set(yl1, 'FontSize', 18);



fileID2 = fopen('InterpolatedJoystickAndTime.txt', 'w');

newTimeIntervalSize=size(newTimeInterval);
N2=newTimeIntervalSize(2);

for j=1:N2
    fprintf(fileID2, '%s %s %s\n',num2str(newTimeInterval(:,j)),num2str(p_forward_backward(:,j)), num2str(p_left_right(:,j)));
end

fclose(fileID1);
fclose(fileID2);
