clear;clc;
PathRoot='PolyU_Palmprint_600\';
list=dir(PathRoot);%�г��ļ�������
fileNum=size(list); 
for k=1:fileNum(1)-2
%for k=1:1
    picgaborcode=preprocess(k);%����32*32��ʵ������
    newPathRoot='plamFeature\';%�����ļ��е�·����
    %newPathRoot='D:\Desktop\Palmprint_Identification\plamFeature\';
    imwrite(picgaborcode,strcat(newPathRoot,list(k+2).name));%strcat:ˮƽ�����ַ���
    disp(strcat(list(k+2).name,'�ļ�д��ɹ���'));
end
