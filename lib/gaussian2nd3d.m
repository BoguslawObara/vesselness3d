function [gxx,gyy,gzz,gxy,gxz,gyz] = gaussian2nd3d(s) 
%% grid coordinates
k = 3;
[x,y,z] = ndgrid(-round(k*s(1)):round(k*s(1)),-round(k*s(2)):round(k*s(2)),-round(k*s(3)):round(k*s(3)));

%% Gaussian 2nd derivatives
a = -(1/(((2*pi)^(3/2))*s(1)*s(2)*s(3)));
b = exp( -x.^2/(2*s(1)^2) -y.^2/(2*s(2)^2) -z.^2/(2*s(3)^2) );
gxx =  a .* (x.^2/s(1)^4 - 1/s(1)^2) .* b;
gyy =  a .* (y.^2/s(2)^4 - 1/s(2)^2) .* b;
gzz =  a .* (z.^2/s(3)^4 - 1/s(3)^2) .* b;  
gxy =  a .* (x.*y)/(s(1)^2.*s(2)^2) .* b;
gxz =  a .* (x.*z)/(s(1)^2.*s(3)^2) .* b;
gyz =  a .* (y.*z)/(s(2)^2.*s(3)^2) .* b;

end