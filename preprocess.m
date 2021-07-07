function [picgaborcode]=preprocess(picnumber)
% PathRoot='D:\Desktop\Palmprint_Identification\PolyU_Palmprint_600\';
PathRoot='PolyU_Palmprint_600\';
list=dir(PathRoot);
k=2+picnumber;
% f1=imread(strcat('D:\Desktop\Palmprint_Identification\PolyU_Palmprint_600\',list(k).name));
f1=imread(strcat('PolyU_Palmprint_600\',list(k).name));

%ͼ���ֵ��
g=ordfilt2(f1,200,ones(10,40));%��ά˳��ͳ���˲�,��10*40�Ĵ�������ֵ�˲�
bw=imbinarize(g,0.2);
subplot(2,4,1),imshow(f1);title('ԭʼͼ��');
subplot(2,4,2),imshow(g);title('ƽ������ͼ��');
subplot(2,4,3),imshow(bw);title('ƽ�������ֵͼ��');

%�߽����
dim=size(bw);
col=round(dim(2)/2)-90;         %������ʼ��������,round:ȡ��
row=find(bw(:,col),1);          %������ʼ��������
connectivity=8;                 %��ͨ����
num_points=1800;
contour=bwtraceboundary(bw,[row,col],'N',connectivity,num_points);

%%
[MM,NN]=size(bw);
[x,y]=size(bw);
[r, c] = size(bw);%r=284��c=384
flogx=round(r/2);%flogxΪ��ֱ�����ϵ����ĵ�142
flogy=round(c/2);%flogyΪˮƽ��������ĵ�192

%%
%��ȡ����
im1=edge(bw,'sobel');
subplot(2,4,4),imshow(im1),title('����ͼ');

%%
%������ϵ
BB=bwboundaries(bw);%���ٶ�ֵͼ��ı߽�����
im2=zeros(MM,NN);
for kk=1:length(BB(1))
    boundary=BB{kk};%��k���������洢��������������
end       
for l=1:length(boundary)
    im2(boundary(l,1),flogy)=1;%��ֱ����������
end
im3=im1&im2;%�������������Ľ���
im3=double(im3);%ת��Ϊ˫����ֵ
%subplot(2,4,8),imshow(im2),title('������ͼ');%������ֱ������
%subplot(2,4,8),imshow(im3);%�����غϵ�ͼ

%�������ҳ���ָ֮���������
[mm,nn]=find(im3==1);
zuobiao=[mm,nn];
zb1=zuobiao(1,1)+5;%���潻���������5
zb2=zuobiao(2,1)-5;%���潻��������5
im4=zeros(x,y);
B4=bwboundaries(bw);%Ѱ������,B4Ϊ�洢������Ϣ
for kkk=1:length(B4)
    boundary=B4{kkk};%��k���������洢��������������
    
    %ֻ��ʾ�������������
    for l=1:length(boundary)
        if boundary(l,2)<=flogy
             im4(boundary(l,1),boundary(l,2))=1;
        end
    end  
end
%subplot(2,4,8),imshow(im4),title('�������ͼ');

tag=0; flag=0;%��ָ��
tag1=0; flag1=0;%��ָ�䣬ָ�����������ʼ��
B5=bwboundaries(im4);%B5Ϊ��������������Ϣ
for kkkk=1:length(B5)
    boundary=B5{kkkk};
    
    %�ҳ�ָ����������
    for l=1:length(boundary)
         if boundary(l,1)<95 && boundary(l,1)>zb1  %95 ��ָ���������������
           if boundary(l,2)>tag %�������·��ĵ�  
               tag=boundary(l,2);
               flag=boundary(l,1);
               if boundary(l,2)==tag && boundary(l,1)>flag
                   flag=boundary(l,1);
               end
           end            
         end
         if boundary(l,1)>200&&boundary(l,1)<zb2 %��ָ���������������
            if boundary(l,2)>tag1
                    tag1=boundary(l,2);
                    flag1=boundary(l,1);
                    if boundary(l,2)==tag1 && boundary(l,1)>flag1
                        flag1=boundary(l,1);
                    end
           end
         end
    end    
end

subplot(2,4,5),imshow(f1),title('������ͼ');
hold on%�����Ǳ���ԭͼ�����ܴ˺���Ƶ��µ����ߣ����ӻ�ͼ��
p1 = [flag,tag];%����������ָ��϶����
p2 = [flag1,tag1];%����������ָ��϶����
distance=sqrt((p1(1)-p2(1)).^2+(p1(2)-p2(2)).^2);%��ָ��ľ���
pmid = [(flag1+flag)/2,(tag1+tag)/2];%��ָ����е�����
kfa=((-p2(2)-(-p1(2)))/(p2(1)-p1(1)));%����б��:-(y2-y1)/(x2-x1)
%disp(kfa);
%kl=-(1/kfa);%l��б��
xfaend=350;
yfaend=kfa*(xfaend-pmid(2))+pmid(1);%�����յ������
plot([pmid(2),xfaend],[pmid(1),yfaend],'Color','r','LineWidth',1);
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','g','LineWidth',1);%�������ֵ���������ֵ
hold off; 
%%
%��תͼ��
at=atand(kfa);% ����Ԫ�صķ�����,���Ƕ�
f1=imrotate(f1,at,'bilinear','crop');%��ͼ���е���ʱ����תat�ȣ�����ԭͼ���С
[m,n]=size(f1);  %[284,384]
degree=atand((m/2-flag)/(tag-n/2));%��ָ����ͼ���������ߵĽǶ�
%flag,tag������������ָ��϶�������к���
%��ת���ָ��������ͼ���е�������к��еĳ���
x2=sqrt((tag-n/2).^2+(flag-m/2).^2)*cosd(degree+at); 
y2=sqrt((tag-n/2).^2+(flag-m/2).^2)*sind(degree+at); 
%disp(x2);disp(y2);
tag=n/2-x2;
flag=m/2+y2;
tag1=tag;
flag1=flag+distance;
subplot(2,4,6),imshow(f1),title('����ͼ');

hold on
p1 = [flag,tag];
p2 = [flag1,tag1];%��ת����ָ�������
pmid = [(flag1+flag)/2,(tag1+tag)/2];
kfa=-((p2(2)-p1(2))/(p2(1)-p1(1)));%����б��
xfaend=360;%�Զ��峤��
yfaend=kfa*(xfaend-pmid(2))+pmid(1);
plot([pmid(2),xfaend],[pmid(1),yfaend],'Color','r','LineWidth',1);
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','g','LineWidth',1);
%���Ƶ������ROI����
xawaypmid=36; %36 ��ָ���ߵ�roi�ľ���
pROIacross1=[pmid(1)+xawaypmid*kfa,pmid(2)+xawaypmid];%��������ߺͷ��߽���
at=atand(kfa);% ����Ԫ�صķ�����,���Ƕ�
sat=sind(at);%����Ԫ�ص�����
cat=cosd(at);
xROIlt=pROIacross1(2)+sat*64;
yROIlt=pROIacross1(1)-cat*64; %��������ϵ�
xROIlb=pROIacross1(2)-sat*64;
yROIlb=pROIacross1(1)+cat*64; %��������µ�
pROIacross2=[pmid(1)+xawaypmid*kfa+128*sat,pmid(2)+xawaypmid+128*cat];%�����ұ��ߺͷ��߽���
xROIrt=pROIacross2(2)+sat*64; 
yROIrt=pROIacross2(1)-cat*64;%��������ϵ�
xROIrb=pROIacross2(2)-sat*64;
yROIrb=pROIacross2(1)+cat*64; %��������µ�
plot([xROIlt,xROIlb],[yROIlt,yROIlb],'Color','b','LineWidth',1);%����
plot([xROIrt,xROIrb],[yROIrt,yROIrb],'Color','b','LineWidth',1);%����
plot([xROIrt,xROIlt],[yROIrt,yROIlt],'Color','b','LineWidth',1);%����
plot([xROIrb,xROIlb],[yROIrb,yROIlb],'Color','b','LineWidth',1);%����
hold off; 

%%
RGB=f1;%ROI��ȡ
RGB1=imcrop(RGB,[xROIlt,yROIlt,127,127]);%[xmin ymin width height]
subplot(2,4,7),imshow(RGB1),title('��ȡͼ');
%��ȡͼ������Ӧ�ļ���
%imwrite(RGB1,strcat('D:\Desktop\Palmprint_Identification\ROIResult\',list(k).name));
imwrite(RGB1,strcat('ROIResult\',list(k).name));

%ROI������ȡ
n=8;% �˲����ڴ�С12
sigma=5.6179;%��˹������׼����
theta=pi/4;%�˲�����
u=0.0916;%�˲�Ƶ��
f1=RGB1;

[complexGabout,realGabout,imagGabout]=gaborfilter(f1,n,theta,u,sigma);%�����˲����ͼ��

% figure(3),
% subplot(241),imshow(uint8(RGB1)),title('ROI');%uint8:ת��Ϊ8λ�޷�������
% subplot(242);imagesc((realGabout));title('�˲����ʵ��');%ʵ����ͼ�����ƽ���˲�
% subplot(243);imagesc(imagGabout);title('�˲�����鲿');%�鲿������Ե���
% subplot(245);imshow(imbinarize(realGabout));title('ʵ����ֵ��');
% subplot(246);imshow(imbinarize(imagGabout));title('�鲿��ֵ��');

[Real]=realGabout(1:4:end,1:4:end)>0;%�²���
[Image]=imagGabout(1:4:end,1:4:end)>0;
%[Image]=downsampling(imagGabout);
% subplot(247);imshow((Real));title('ʵ���²���');
% subplot(248);imshow((Image));title('�鲿�²���');

%picgaborcode=imbinarize(realGabout);
picgaborcode=Real;
end
