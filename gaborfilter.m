function [complexGabout,realGabout,imagGabout]=gaborfilter(I,n,theta,u,sigma)
if isa(I,'double')~=1 %ȷ�������Ƿ�Ϊָ����Ķ���
    I=double(I);
end
for x = -n:n
    for y = -n:n
        G(n+x+1,n+y+1) = ((1/(2*pi*sigma.^2)).*exp(-.5*(x.^2+y.^2)/sigma.^2)...
        *exp(2*pi*sqrt(-1)*(u*x*cos(theta)+u*y*sin(theta))));
    end %e��2�η�: exp(2) 
end

% figure(2),
% subplot(121),imagesc(real(G)),colorbar;title('ʵ����ά');%��ʾʹ�þ������ӳ�����ɫ��ͼ��
% subplot(122);imagesc(imag(G)),colorbar;title('�鲿��ά');
complexG=G-mean(mean(G));%mean:������ľ�ֵ
realG=real(G)-mean(mean(real(G)));%real:���ظ�������Ԫ�ص�ʵ��
imagG=imag(G)-mean(mean(imag(G)));
complexGabout = conv2(I,double(complexG),'same');%��ά���,same:������I��С��ͬ�ľ�������Ĳ���
realGabout = conv2(I,double(realG),'same');%I��realG����ά���
imagGabout = conv2(I,double(imagG),'same');

