% config
numberOfFirstPoints = 100;
% numberOfPointsInLine = 100;
smallestNumberOfPoints = 30;
largestNumberOfPoints = 90;
step = 30;

numberOfPointsInLine = zeros(1, (largestNumberOfPoints - smallestNumberOfPoints)/step);

index = 0;
for i = smallestNumberOfPoints:step:largestNumberOfPoints
    index = index + 1;
    numberOfPointsInLine(index) = i;
end
%%%%

%%%%%%%%%%%%%%%%%%%%%%%file parsing%%%%%%%%%%%%%%%%%%%%%
f = fopen('tg8_ir.txt');
data = textscan(f,'%f');
fclose(f);
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
y = data{1};
lengthOfdata = length(data{1});

y_FirstPoints = zeros(1, numberOfFirstPoints);
for i = 1:numberOfFirstPoints
    y_FirstPoints(i) = y(i);
end
meanOffsetVal = mean(y_FirstPoints,'all');

y_TransformedUsingOffset = zeros(1, lengthOfdata - numberOfFirstPoints);
for i = (numberOfFirstPoints+1):lengthOfdata
    y_TransformedUsingOffset(i - numberOfFirstPoints) = y(i) - meanOffsetVal; 
end

transformedLength = length(y_TransformedUsingOffset);
x = linspace(0,transformedLength,transformedLength);

% y = kx + b
% k = (y2-y1)/(x2-x1)
% alfa = arctg(k)
alfaInRad = zeros(length(numberOfPointsInLine), transformedLength);
alfaInDeg = zeros(length(numberOfPointsInLine), transformedLength);

for i = 1:length(numberOfPointsInLine)
    for j = (numberOfPointsInLine(i)+1):length(x)
        if j <= length(x)
            currentPoint = j - numberOfPointsInLine(i);
            y2 = y_TransformedUsingOffset(currentPoint);
            y1 = y_TransformedUsingOffset(j);
            x2 = currentPoint;
            x1 = j;        

            TAN_alfa = (y2-y1)/(x2-x1);

            alfaInRad(i,j) = atan(TAN_alfa);
            alfaInDeg(i,j) = rad2deg(alfaInRad(i,j));
        end
    end
end

alfaInDeg_16smooth = smoothdata(alfaInDeg,'movmedian',16);
alfaInDeg_32smooth = smoothdata(alfaInDeg,'movmedian',32);
alfaInDeg_48smooth = smoothdata(alfaInDeg,'movmedian',48);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ca = 0.0001;
cb = 0.001;
cc = 3;
x_target = linspace(0,length(x),length(x));
y_target = ca*(x_target.^2)+cb*x_target+cc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%transformed raw foo with deg foo
% figure
% plot(x,alfaInDeg, x, y);
% grid on
% figure
% plot(x_target, y_target,'-*');
% grid on
figure
plot(x,alfaInDeg(1,:),'-o', x,alfaInDeg(2,:),'-o', x, y_TransformedUsingOffset);
hold on 
plot(x_target, y_target,'-*');
grid on

%different type of smooth experiment
figure
plot(x,alfaInDeg, x,alfaInDeg_16smooth, x,alfaInDeg_32smooth, x,alfaInDeg_48smooth);
grid on

