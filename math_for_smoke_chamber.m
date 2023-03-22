% config
numberOfFirstPoints = 100;
numberOfPoints = 100;
%%%%

f = fopen('tg8_ir.txt');
data = textscan(f,'%f');
fclose(f);

y = data{1};
lengthOfdata = length(data{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_FirstPoints = zeros(1, numberOfFirstPoints);
for i = 1:numberOfFirstPoints
    y_FirstPoints(i) = y(i);
end
meanOffsetVal = mean(y_FirstPoints,'all');

y_TransformedUsingOffset = zeros(1, lengthOfdata - numberOfFirstPoints);
for i = (numberOfFirstPoints+1):lengthOfdata
    y_TransformedUsingOffset(i - numberOfFirstPoints) = y(i) - meanOffsetVal; 
end

trandformedLength = length(y_TransformedUsingOffset);
x = linspace(1,trandformedLength,trandformedLength);

% y = kx + b
% k = (y2-y1)/(x2-x1)
% alfa = arctg(k)
alfaInRad = zeros(1, trandformedLength);
alfaInDeg = zeros(1, trandformedLength);

for i = (numberOfPoints+1):length(x)
    if i <= length(x)
        currentPoint = i - numberOfPoints;
        y2 = y_TransformedUsingOffset(currentPoint);
        y1 = y_TransformedUsingOffset(i);
        x2 = currentPoint;
        x1 = i;        

        TAN_alfa = (y2-y1)/(x2-x1);
        
        alfaInRad(i) = atan(TAN_alfa);
        alfaInDeg(i) = rad2deg(alfaInRad(i));
    end
end

alfaInDeg_16smooth = smoothdata(alfaInDeg,'movmedian',16);
alfaInDeg_32smooth = smoothdata(alfaInDeg,'movmedian',32);
alfaInDeg_48smooth = smoothdata(alfaInDeg,'movmedian',48);

%transformed raw foo with deg foo
% figure
% plot(x,alfaInDeg, x, y);
% grid on
figure
plot(x,alfaInDeg, x, y_TransformedUsingOffset);
grid on

%different type of smooth experiment
figure
plot(x,alfaInDeg, x,alfaInDeg_16smooth, x,alfaInDeg_32smooth, x,alfaInDeg_48smooth);
grid on

