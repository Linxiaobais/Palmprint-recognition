clear;clc;
% PathRoot='D:\Desktop\Palmprint_Identification\plamFeature\';
PathRoot='plamFeature\';
list=dir(PathRoot);
fileNum=(size(list)-2); %样本个数
fileNum=fileNum(1,1); %600

hosp=zeros(1,1500);%同一手掌的海明距离
hodp=zeros(1,178200);%不同手掌的海明距离
counthosp=0;
counthodp=0;
count=0;
for i=1:fileNum/6-1%不同手掌类间距离,100组手掌
    for j=1:6
        for k=i*6+1:fileNum
            hamming=hammingcomp((i-1)*6+j,k);%返回汉明距离最小的那个值
            counthodp=counthodp+1;
            hodp(1,counthodp)=hamming;
            count=count+1;
            disp(count);
        end
    end
end
save hodp hodp;
for i=1:fileNum/6%同一个手掌类内距离,100组手掌
    for j=1:5
        for k=j+1:6
            hamming=hammingcomp((i-1)*6+j,(i-1)*6+k);
            counthosp=counthosp+1;
            hosp(1,counthosp)=hamming;
        end
    end
end
save hosp hosp;  
