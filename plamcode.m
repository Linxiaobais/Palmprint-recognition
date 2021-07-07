clear;clc;
PathRoot='PolyU_Palmprint_600\';
list=dir(PathRoot);%列出文件夹内容
fileNum=size(list); 
for k=1:fileNum(1)-2
%for k=1:1
    picgaborcode=preprocess(k);%返回32*32的实部特征
    newPathRoot='plamFeature\';%定义文件夹的路径。
    %newPathRoot='D:\Desktop\Palmprint_Identification\plamFeature\';
    imwrite(picgaborcode,strcat(newPathRoot,list(k+2).name));%strcat:水平串联字符串
    disp(strcat(list(k+2).name,'文件写入成功！'));
end
