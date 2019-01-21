%定位初始化
Length=100; %场地空间长度，单位：米
Width=100;  %场地空间宽度，单位：米
d=50;       %观测站最大测量距离
N=6;        %观测站个数

for i=1:N   %观测站位置初始化，位置随机给定
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end

%目标出现在监测场地的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
X=[];   %初始化，找出能探测到目标的观测站的位置集合
for i=1:N
    if getDist(Node(i),Target)<=d
        X=[X;Node(i).x,Node(i).y];
    end 
end