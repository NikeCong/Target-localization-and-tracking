%画圆子函数
function circle(x0,y0,r)
sita=0:pi/20:2*pi;
plot(x0+r*cos(sita),y0+r*sin(sita)); %中心在（x0，y0），半径为r
end