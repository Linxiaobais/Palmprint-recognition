load hosp.mat;
load hodp.mat;
%�����ÿ��0.01ͳ��һ�Σ���ΧΪ0-0.5��һ����ʮ����
s=size(hosp);%[1,1500]
d=size(hodp);%[1,178200]
numhosp=zeros(1,0.5/0.01);
numhodp=zeros(1,0.5/0.01);
%ͳ��50������ÿ����ĸ���
for h=1:s(1,2)  %fix:��0ȡ��
    numhosp(1,fix(100*hosp(1,h)))=numhosp(1,fix(100*hosp(1,h)))+1;
end
for i=1:d(1,2)
    numhodp(1,fix(100*hodp(1,i)))=numhodp(1,fix(100*hodp(1,i)))+1;
end

figure(1),
subplot(1,2,1),
x=0.01:0.01:0.50;
hs=numhosp(1,fix(x*100))/s(1,2); %ÿ������ռ�ٷֱ�
hd=numhodp(1,fix(x*100))/d(1,2);
plot(x,hs,x,hd);
xlabel('Hamming distance');
ylabel('Percentage(%)');
title(' Genuine and imposter distributions');

FRR=zeros(1,50);%����ܾ��ʣ�ͬ�������߽����ұ�
FAR=zeros(1,50);%��������ʣ����������߽������
                %��ȷ�����ʣ�1-FRR

for i=1:50
    FRR(i)=1-sum(hs(1:i));%sum:ǰi��Ԫ�����
    FAR(i)=sum(hd(1:i));
end
FRR(FRR<0)=0;
%ROC
subplot(1,2,2),
x=0.01:0.01:0.50;
semilogx(100*FAR(fix(x*100)),100*(1-FRR(fix(x*100))));%semilogx�����ݻ���Ϊx��Ķ����̶�
xlabel('False Acceptance Rate(%)');
ylabel('Genuine Acceptance Rate(%)');

figure(2),
x=0.01:0.01:0.50;
plot(x,FRR(fix(x*100)),x,FAR(fix(x*100)));
title(' FRR(��)��FAR(��)');

min=1;
for i=1:50
    if min>abs(FAR(i)-FRR(i))
        min=abs(FAR(i)-FRR(i));
        minX=i;
    end
end
minX=minX/100;
disp('EER=') %��ֵ������,FRR=FAR��ֵ
disp(FRR(fix(minX*100)));
