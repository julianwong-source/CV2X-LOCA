function [locx,locy] = triposition(xa,ya,da,xb,yb,db,xc,yc,dc)
%              ���㶨λ��                          %
%���룺
%   1.�ο��ڵ�A��xa,ya��,B(xb,yb),C(xc,yc)
%   2.��λ�ڵ�D(locx,locy)��������ľ���ֱ�Ϊda,db,dc
%���أ�
%   ��locx��locy)Ϊ����Ķ�λ�ڵ�D���λ������
%
syms x y   %f���ű���
%--------------��ⷽ����------------------------------------
f1 = '2*x*(xa-xc)+xc^2-xa^2+2*y*(ya-yc)+yc^2-ya^2=dc^2-da^2';
f2 = '2*x*(xb-xc)+xc^2-xb^2+2*y*(yb-yc)+yc^2-yb^2=dc^2-db^2';
% �����x,y�ķ��ŷ����飬�õ���ķ��ű�ʾ��������xx,yy
[xx,yy] = solve(f1,f2,x,y); 
px = eval(xx);  %�����ֵpx(1),px(2)
py = eval(yy);  %�����ֵpy(1),py(2)
locx = px;
locy = py;