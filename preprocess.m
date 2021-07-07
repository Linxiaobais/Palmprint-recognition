function [picgaborcode]=preprocess(picnumber)
% PathRoot='D:\Desktop\Palmprint_Identification\PolyU_Palmprint_600\';
PathRoot='PolyU_Palmprint_600\';
list=dir(PathRoot);
k=2+picnumber;
% f1=imread(strcat('D:\Desktop\Palmprint_Identification\PolyU_Palmprint_600\',list(k).name));
f1=imread(strcat('PolyU_Palmprint_600\',list(k).name));

%图像二值化
g=ordfilt2(f1,200,ones(10,40));%二维顺序统计滤波,在10*40的窗口内中值滤波
bw=imbinarize(g,0.2);
subplot(2,4,1),imshow(f1);title('原始图像');
subplot(2,4,2),imshow(g);title('平滑处理图像');
subplot(2,4,3),imshow(bw);title('平滑处理二值图像');

%边界跟踪
dim=size(bw);
col=round(dim(2)/2)-90;         %计算起始点列坐标,round:取整
row=find(bw(:,col),1);          %计算起始点行坐标
connectivity=8;                 %连通区域
num_points=1800;
contour=bwtraceboundary(bw,[row,col],'N',connectivity,num_points);

%%
[MM,NN]=size(bw);
[x,y]=size(bw);
[r, c] = size(bw);%r=284，c=384
flogx=round(r/2);%flogx为竖直方向上的中心点142
flogy=round(c/2);%flogy为水平方向的中心点192

%%
%提取轮廓
im1=edge(bw,'sobel');
subplot(2,4,4),imshow(im1),title('轮廓图');

%%
%建坐标系
BB=bwboundaries(bw);%跟踪二值图像的边界区域
im2=zeros(MM,NN);
for kk=1:length(BB(1))
    boundary=BB{kk};%第k个轮廓，存储轮廓各像素坐标
end       
for l=1:length(boundary)
    im2(boundary(l,1),flogy)=1;%竖直中心线坐标
end
im3=im1&im2;%中心线与轮廓的交点
im3=double(im3);%转换为双精度值
%subplot(2,4,8),imshow(im2),title('中心线图');%绘制竖直中心线
%subplot(2,4,8),imshow(im3);%绘制重合点图

%遍历，找出手指之间的两个点
[mm,nn]=find(im3==1);
zuobiao=[mm,nn];
zb1=zuobiao(1,1)+5;%上面交点纵坐标加5
zb2=zuobiao(2,1)-5;%下面交点横坐标减5
im4=zeros(x,y);
B4=bwboundaries(bw);%寻找轮廓,B4为存储轮廓信息
for kkk=1:length(B4)
    boundary=B4{kkk};%第k个轮廓，存储轮廓各像素坐标
    
    %只显示中心线左边轮廓
    for l=1:length(boundary)
        if boundary(l,2)<=flogy
             im4(boundary(l,1),boundary(l,2))=1;
        end
    end  
end
%subplot(2,4,8),imshow(im4),title('左边轮廓图');

tag=0; flag=0;%上指间
tag1=0; flag1=0;%下指间，指间两点坐标初始化
B5=bwboundaries(im4);%B5为左半边手掌轮廓信息
for kkkk=1:length(B5)
    boundary=B5{kkkk};
    
    %找出指间两点坐标
    for l=1:length(boundary)
         if boundary(l,1)<95 && boundary(l,1)>zb1  %95 上指间纵坐标大致区域
           if boundary(l,2)>tag %找最右下方的点  
               tag=boundary(l,2);
               flag=boundary(l,1);
               if boundary(l,2)==tag && boundary(l,1)>flag
                   flag=boundary(l,1);
               end
           end            
         end
         if boundary(l,1)>200&&boundary(l,1)<zb2 %下指间纵坐标大致区域
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

subplot(2,4,5),imshow(f1),title('建坐标图');
hold on%作用是保持原图并接受此后绘制的新的曲线，叠加绘图；
p1 = [flag,tag];%上面两根手指间隙坐标
p2 = [flag1,tag1];%下面两根手指间隙坐标
distance=sqrt((p1(1)-p2(1)).^2+(p1(2)-p2(2)).^2);%两指间的距离
pmid = [(flag1+flag)/2,(tag1+tag)/2];%两指间的中点坐标
kfa=((-p2(2)-(-p1(2)))/(p2(1)-p1(1)));%法线斜率:-(y2-y1)/(x2-x1)
%disp(kfa);
%kl=-(1/kfa);%l的斜率
xfaend=350;
yfaend=kfa*(xfaend-pmid(2))+pmid(1);%法线终点的坐标
plot([pmid(2),xfaend],[pmid(1),yfaend],'Color','r','LineWidth',1);
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','g','LineWidth',1);%横坐标差值，纵坐标差值
hold off; 
%%
%旋转图像
at=atand(kfa);% 返回元素的反正切,即角度
f1=imrotate(f1,at,'bilinear','crop');%绕图像中点逆时针旋转at度，保持原图像大小
[m,n]=size(f1);  %[284,384]
degree=atand((m/2-flag)/(tag-n/2));%上指间与图像中心连线的角度
%flag,tag是上面两根手指间隙的坐标列和行
%旋转后的指间坐标与图像中点坐标的行和列的长度
x2=sqrt((tag-n/2).^2+(flag-m/2).^2)*cosd(degree+at); 
y2=sqrt((tag-n/2).^2+(flag-m/2).^2)*sind(degree+at); 
%disp(x2);disp(y2);
tag=n/2-x2;
flag=m/2+y2;
tag1=tag;
flag1=flag+distance;
subplot(2,4,6),imshow(f1),title('调整图');

hold on
p1 = [flag,tag];
p2 = [flag1,tag1];%旋转后两指间的坐标
pmid = [(flag1+flag)/2,(tag1+tag)/2];
kfa=-((p2(2)-p1(2))/(p2(1)-p1(1)));%法线斜率
xfaend=360;%自定义长度
yfaend=kfa*(xfaend-pmid(2))+pmid(1);
plot([pmid(2),xfaend],[pmid(1),yfaend],'Color','r','LineWidth',1);
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','g','LineWidth',1);
%绘制调整后的ROI区域
xawaypmid=36; %36 两指连线到roi的距离
pROIacross1=[pmid(1)+xawaypmid*kfa,pmid(2)+xawaypmid];%区域左边线和法线交点
at=atand(kfa);% 返回元素的反正切,即角度
sat=sind(at);%返回元素的正弦
cat=cosd(at);
xROIlt=pROIacross1(2)+sat*64;
yROIlt=pROIacross1(1)-cat*64; %区域的左上点
xROIlb=pROIacross1(2)-sat*64;
yROIlb=pROIacross1(1)+cat*64; %区域的左下点
pROIacross2=[pmid(1)+xawaypmid*kfa+128*sat,pmid(2)+xawaypmid+128*cat];%区域右边线和法线交点
xROIrt=pROIacross2(2)+sat*64; 
yROIrt=pROIacross2(1)-cat*64;%区域的右上点
xROIrb=pROIacross2(2)-sat*64;
yROIrb=pROIacross2(1)+cat*64; %区域的右下点
plot([xROIlt,xROIlb],[yROIlt,yROIlb],'Color','b','LineWidth',1);%左线
plot([xROIrt,xROIrb],[yROIrt,yROIrb],'Color','b','LineWidth',1);%右线
plot([xROIrt,xROIlt],[yROIrt,yROIlt],'Color','b','LineWidth',1);%上线
plot([xROIrb,xROIlb],[yROIrb,yROIlb],'Color','b','LineWidth',1);%下线
hold off; 

%%
RGB=f1;%ROI截取
RGB1=imcrop(RGB,[xROIlt,yROIlt,127,127]);%[xmin ymin width height]
subplot(2,4,7),imshow(RGB1),title('截取图');
%截取图存入相应文件夹
%imwrite(RGB1,strcat('D:\Desktop\Palmprint_Identification\ROIResult\',list(k).name));
imwrite(RGB1,strcat('ROIResult\',list(k).name));

%ROI特征提取
n=8;% 滤波窗口大小12
sigma=5.6179;%高斯函数标准方差
theta=pi/4;%滤波方向
u=0.0916;%滤波频率
f1=RGB1;

[complexGabout,realGabout,imagGabout]=gaborfilter(f1,n,theta,u,sigma);%返回滤波后的图像

% figure(3),
% subplot(241),imshow(uint8(RGB1)),title('ROI');%uint8:转换为8位无符号整数
% subplot(242);imagesc((realGabout));title('滤波后的实部');%实部对图像进行平滑滤波
% subplot(243);imagesc(imagGabout);title('滤波后的虚部');%虚部用来边缘检测
% subplot(245);imshow(imbinarize(realGabout));title('实部二值化');
% subplot(246);imshow(imbinarize(imagGabout));title('虚部二值化');

[Real]=realGabout(1:4:end,1:4:end)>0;%下采样
[Image]=imagGabout(1:4:end,1:4:end)>0;
%[Image]=downsampling(imagGabout);
% subplot(247);imshow((Real));title('实部下采样');
% subplot(248);imshow((Image));title('虚部下采样');

%picgaborcode=imbinarize(realGabout);
picgaborcode=Real;
end
