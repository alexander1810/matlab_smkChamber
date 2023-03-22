f = fopen('UL_B4.txt_2023-03-20 10_47_21.txt');
data = textscan(f,'{"tag":%d,"cmd":%d,"data":%18s}{"value":[%f,%f,%f,%f,%f,%f]}');




% dataLength = length(data(0));

fclose(f);
