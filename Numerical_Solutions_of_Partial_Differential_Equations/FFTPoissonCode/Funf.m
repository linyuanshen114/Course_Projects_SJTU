function y=Funf(x,y)
    y=+4*pi*pi*(x.^2+y.^2).*(1-x).*(1-y).*sin(2*pi*x.*y)+4*pi*(x+y-x.^2-y.^2).*cos(2*pi*x.*y);