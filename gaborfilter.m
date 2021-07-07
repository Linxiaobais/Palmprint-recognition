function [complexGabout,realGabout,imagGabout]=gaborfilter(I,n,theta,u,sigma)
if isa(I,'double')~=1 %确定输入是否为指定类的对象
    I=double(I);
end
for x = -n:n
    for y = -n:n
        G(n+x+1,n+y+1) = ((1/(2*pi*sigma.^2)).*exp(-.5*(x.^2+y.^2)/sigma.^2)...
        *exp(2*pi*sqrt(-1)*(u*x*cos(theta)+u*y*sin(theta))));
    end %e的2次方: exp(2) 
end

% figure(2),
% subplot(121),imagesc(real(G)),colorbar;title('实部二维');%显示使用经过标度映射的颜色的图像
% subplot(122);imagesc(imag(G)),colorbar;title('虚部二维');
complexG=G-mean(mean(G));%mean:求数组的均值
realG=real(G)-mean(mean(real(G)));%real:返回复数数组元素的实部
imagG=imag(G)-mean(mean(imag(G)));
complexGabout = conv2(I,double(complexG),'same');%二维卷积,same:返回与I大小相同的卷积的中心部分
realGabout = conv2(I,double(realG),'same');%I和realG做二维卷积
imagGabout = conv2(I,double(imagG),'same');

