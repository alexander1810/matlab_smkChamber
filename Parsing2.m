parsCMD = 82;
deviceCounter = 10;
counterOfCol = deviceCounter*2;

const_str = '%f;'
format_str = '';
for i = 1:counterOfCol
    format_str = strcat(format_str, const_str);
end
f = fopen('8.txt');
format = strcat('Parsed;%*f;', format_str);
data = textscan(f,format,'CollectOutput',1);
rawdata = cell2mat(data);
rawData_length = length(rawdata);


dataWithBlueData = zeros(rawData_length, deviceCounter);
dataWithRedData = zeros(rawData_length, deviceCounter);
cntWithBlueData = 0;
cntWithRedData = 0;

%save blueDiode data 
for i = 1:counterOfCol
    if(mod(i,2) ~= 0)
        cntWithBlueData = cntWithBlueData+1;
        dataWithBlueData(:,cntWithBlueData) = rawdata(:,i);
    else
        cntWithRedData = cntWithRedData+1;
        dataWithRedData(:,cntWithRedData) = rawdata(:,i);
    end
end

% dataWith82Cmd = zeros(rawData_length, counterOfCol);
% cntWith82data = 0;

% for i = 1:rawData_length
%     if rawdata(i, 2) == parsCMD
%         cntWith82data = cntWith82data+1;
%         dataWith82Cmd(cntWith82data, :) = rawdata(i, :);
%     end
% end
% p = dataWith82Cmd(1:cntWith82data, :);
% dataWith82Cmd_length = length(p);
% 
% globalParsedCellOnDevices = {};
% countersOfReadyDataForPloting = zeros(1, deviceCounter);
% for i = 1:deviceCounter
%     for j = 1:dataWith82Cmd_length
%         if dataWith82Cmd(j, 1) == i
%             countersOfReadyDataForPloting(i) = countersOfReadyDataForPloting(i)+1;
%             globalParsedCellOnDevices{countersOfReadyDataForPloting(i), i} = dataWith82Cmd(j,:);
%         end
%     end
% end

legentStringCell = {};
legendCounter = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ca = 0.0001;
cb = 0.001;
cc = 3;
x_target = linspace(0,length(x),length(x));
y_target = ca*(x_target.^2)+cb*x_target+cc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure 
for i = 1:deviceCounter
    
    x  = linspace(1, rawData_length, rawData_length);
    
    legendCounter = legendCounter + 1;
    strNumber = num2str(i);
    fullStrForLegend = strcat('Device#', strNumber);
    legentStringCell{1,legendCounter} = fullStrForLegend;
    
    subplot(2,1,1)
    plot(x, dataWithBlueData(:,i));
    legend(legentStringCell);
    hold on
    grid on
    title('Blue Diode')
    xlabel 'Smoke level';
    ylabel 'time';
    
    subplot(2,1,2)
    plot(x, dataWithRedData(:,i));
    legend(legentStringCell);
    hold on
    grid on
    title('Red Diode')
    xlabel 'Smoke level';
    ylabel 'time';
end

% figure 
% for i = 1:deviceCounter
%     currentDataLength = countersOfReadyDataForPloting(i);
%     if currentDataLength ~= 0 
%         emptyMatrixForFlotting = zeros(currentDataLength,counterOfCol);
%         for j = 1:currentDataLength
%             emptyMatrixForFlotting(j,:) = globalParsedCellOnDevices{j, i};
%         end
%         
%         x  = linspace(1, currentDataLength, currentDataLength);
%         
%         legendCounter = legendCounter + 1;
%         strNumber = num2str(i);
%         fullStrForLegend = strcat('Device#', strNumber);
%         legentStringCell{1,legendCounter} = fullStrForLegend;
%         
%         mx = emptyMatrixForFlotting(:,3);
%         
%         subplot(2,1,1) 
%         plot(x, emptyMatrixForFlotting(:,3));
%         legend(legentStringCell);
%         hold on
%         grid on
%         title('Blue Diode')
%         xlabel 'Smoke level';
%         ylabel 'time';
%         
%         subplot(2,1,2)
%         plot(x, emptyMatrixForFlotting(:,4));
%         legend(legentStringCell);
%         hold on
%         grid on
%         title('Red Diode')
%         xlabel 'Smoke level';
%         ylabel 'time';
%     end
% end



subplot(2,1,1)
plot(x_target, y_target,'-*');
subplot(2,1,2)
plot(x_target, y_target,'-*');

fclose(f);


