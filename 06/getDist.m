%计算两点距离子函数
function [dist,dist2]=getDist(A,B)
dist2=(A.x-B.x)^2+(A.y-B.y)^2;
dist=sqrt(dist2);
end