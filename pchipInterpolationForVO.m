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
    [eulAzimuth(i,:),eulPitch(i,:),eulBank(i,:)]=Quat2Eul(xQuat(i,:),yQuat(i,:),zQuat(i,:),wQuat(i,:));
end



% the timeInterval for interpolation
newTimeInterval = 1:1/16:timestamp(N);
timestampT = transpose(timestamp);
xPositionT = transpose(xPosition);
yPositionT = transpose(yPosition);
zPositionT = transpose(zPosition);
eulAzimuthT = transpose(eulAzimuth);
eulPitch = transpose(eulPitch);
eulBank = transpose(eulBank);
p_xPosition = pchip(timestampT, xPositionT,newTimeInterval);
p_yPosition = pchip(timestampT, yPositionT, newTimeInterval);
p_zPosition = pchip(timestampT, zPositionT, newTimeInterval);
p_eulAzimuth= pchip(timestampT, eulAzimuthT, newTimeInterval);
p_eulPitch = pchip(timestampT, eulPitch, newTimeInterval);
p_eulBank = pchip(timestampT, eulBank, newTimeInterval);

if 0

figure

plot(newTimeInterval, p_xPosition, 'ro', newTimeInterval, p_xPosition, 'r', timestamp, xPosition, '-.', timestamp, xPosition,'b*')
t=title('Visual odometry X position with the timestamp');
le=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le, 'FontSize', 16);
set(t, 'FontSize', 20);
xl=xlabel('timestamp');
yl=ylabel('visual odometry X position')
set(xl, 'FontSize', 18);
set(yl, 'FontSize', 18);

figure

plot(newTimeInterval, p_yPosition, 'ro', newTimeInterval, p_yPosition, 'r', timestamp, yPosition, '-.', timestamp, yPosition,'b*')
t1=title('Visual odometry Y position with the timestamp');
le1=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le1, 'FontSize', 16);
set(t1, 'FontSize', 20);
xl1=xlabel('timestamp');
yl1=ylabel('visual odometry Y position')
set(xl1, 'FontSize', 18);
set(yl1, 'FontSize', 18);

figure

plot(newTimeInterval, p_zPosition, 'ro', newTimeInterval, p_zPosition, 'r', timestamp, zPosition, '-.', timestamp, zPosition,'b*')
t2=title('Visual odometry Z position with the timestamp');
le2=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le2, 'FontSize', 16);
set(t2, 'FontSize', 20);
xl2=xlabel('timestamp');
yl2=ylabel('visual odometry Z position')
set(xl2, 'FontSize', 18);
set(yl2, 'FontSize', 18);

figure

plot(newTimeInterval, p_eulAzimuth, 'ro', newTimeInterval, p_eulAzimuth, 'r', timestamp, eulAzimuth, '-.', timestamp, eulAzimuth,'b*')
t3=title('Visual odometry Azimuth Eular angle with the timestamp');
le3=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le3, 'FontSize', 16);
set(t3, 'FontSize', 20);
xl3=xlabel('timestamp');
yl3=ylabel('Azimuth Eular angle')
set(xl3, 'FontSize', 18);
set(yl3, 'FontSize', 18);


figure

plot(newTimeInterval, p_eulPitch, 'ro', newTimeInterval, p_eulPitch, 'r', timestamp, eulPitch, '-.', timestamp, eulPitch,'b*')
t4=title('Visual odometry Pitch Eular angle with the timestamp');
le4=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le4, 'FontSize', 16);
set(t4, 'FontSize', 20);
xl4=xlabel('timestamp');
yl4=ylabel('Pitch Eular angle')
set(xl4, 'FontSize', 18);
set(yl4, 'FontSize', 18);

figure

plot(newTimeInterval, p_eulBank, 'ro', newTimeInterval, p_eulBank, 'r', timestamp, eulBank, '-.', timestamp, eulBank,'b*')
t5=title('Visual odometry Bank Eular angle with the timestamp');
le5=legend('pchip interpolation data(16Hz)','pchip curve','real data curve','real data(20~27Hz)');
set(le5, 'FontSize', 16);
set(t5, 'FontSize', 20);
xl5=xlabel('timestamp');
yl5=ylabel('Bank Eular angle')
set(xl5, 'FontSize', 18);
set(yl5, 'FontSize', 18);



figure

plot(p_xPosition, p_yPosition,'ro', xPosition,yPosition, 'b*')
t6=title('visual odometry 2D position');
le6=legend('pchip interpolation data(16Hz)','real data(20~27Hz)');
set(le6, 'FontSize', 16);
set(t6, 'FontSize', 20);
xl6=xlabel('x axis');
yl6=ylabel('y axis')
set(xl6, 'FontSize', 18);
set(yl6, 'FontSize', 18);


fileID2 = fopen('InterpolatedVOAndTime.txt', 'w');

newTimeIntervalSize=size(newTimeInterval);
N2=newTimeIntervalSize(2);

for j=1:N2
    fprintf(fileID2, '%s %s %s %s %s\n',num2str(newTimeInterval(:,j)),num2str(p_xPosition(:,j)), num2str(p_yPosition(:,j)), num2str(p_zPosition(:,j)),num2str(p_eulAzimuth(:,j)));
end



fclose(fileID);
fclose(fileID2);
end
