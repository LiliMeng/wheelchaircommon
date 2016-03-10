clear all
clc
fileID = fopen('VOAndTime.txt');
C = textscan(fileID, '%s %s %s %s %s %s %s %s %s');


N=size(C{1},1);

m1=str2mat(C{1});
m2=str2mat(C{2});
m3=str2mat(C{3});
m4=str2mat(C{4});
m5=str2mat(C{5});
m6=str2mat(C{6});
m7=str2mat(C{7});
m8=str2mat(C{8});
m9=str2mat(C{9});


for i = 1:N
    timestamp1(i,:)=str2double(m1(i,:))-str2double(m1(1,:));
    timeInterval(i,:)=str2double(m2(i,:))*10^(-9);
    timestamp(i,:)=timestamp1(i,:)+timeInterval(i,:);
    xPosition(i,:)=str2double(C{3}{i});
    yPosition(i,:)=str2double(C{4}{i});
    zPosition(i,:)=str2double(C{5}{i});
    xQuat(i,:)=str2double(C{6}{i});
    yQuat(i,:)=str2double(C{7}{i});
    zQuat(i,:)=str2double(C{8}{i});
    wQuat(i,:)=str2double(C{9}{i});
    
    %convert Quaternion to Eulear Angles
    quat(i,:)=[xQuat(i,:),yQuat(i,:),zQuat(i,:),wQuat(i,:)]
    %eulZYX(i,:)=quat2eul(quat(i,:))
end


% the timeInterval for interpolation
newTimeInterval = 1:1/16:timestamp(N);
timestampT = transpose(timestamp);
xPositionT = transpose(xPosition);
yPositionT = transpose(yPosition);
zPositionT = transpose(zPosition);
p_xPosition = pchip(timestampT, xPositionT,newTimeInterval);
p_yPosition = pchip(timestampT, yPositionT, newTimeInterval);
p_zPosition = pchip(timestampT, zPositionT, newTimeInterval);

figure

plot(newTimeInterval, p_xPosition, 'ro', newTimeInterval, p_xPosition, 'r', timestamp, xPosition, '-.', timestamp, xPosition,'b*')
t=title('Visual odometry X position with the timestamp');
le=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le, 'FontSize', 16);
set(t, 'FontSize', 20);
xl=xlabel('timestamp');
yl=ylabel('visual odometry X position')
set(xl, 'FontSize', 18);
set(yl, 'FontSize', 18);

figure

plot(newTimeInterval, p_yPosition, 'ro', newTimeInterval, p_yPosition, 'r', timestamp, yPosition, '-.', timestamp, yPosition,'b*')
t1=title('Visual odometry Y position with the timestamp');
le1=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le1, 'FontSize', 16);
set(t1, 'FontSize', 20);
xl1=xlabel('timestamp');
yl1=ylabel('visual odometry Y position')
set(xl1, 'FontSize', 18);
set(yl1, 'FontSize', 18);

figure

plot(newTimeInterval, p_zPosition, 'ro', newTimeInterval, p_zPosition, 'r', timestamp, zPosition, '-.', timestamp, zPosition,'b*')
t2=title('Visual odometry Z position with the timestamp');
le1=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(18~20Hz)');
set(le1, 'FontSize', 16);
set(t2, 'FontSize', 20);
xl2=xlabel('timestamp');
yl2=ylabel('visual odometry Z position')
set(xl2, 'FontSize', 18);
set(yl2, 'FontSize', 18);

fileID2 = fopen('InterpolatedVOAndTime.txt', 'w');

newTimeIntervalSize=size(newTimeInterval);
N2=newTimeIntervalSize(2);

for j=1:N2
    fprintf(fileID2, '%s %s %s\n',num2str(newTimeInterval(:,j)),num2str(p_xPosition(:,j)), num2str(p_yPosition(:,j)));
end

fclose(fileID);
fclose(fileID2);
