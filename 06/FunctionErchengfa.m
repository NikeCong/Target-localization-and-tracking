%三维平面最小二乘定位算法
%定位初始化
Length=100; %场地空间长度，单位：米
Width=100;  %场地空间宽度，单位：米
Height=100; %场地空间高度，单位：米
d=50;       %观测站最大测量距离
Node_number=5;  %观测站的个数，最少必须有4个
n=Node_number;
R=5;    %观测站测量噪声方差
for i=1:Node_number     %观测站的位置初始化，这里位置是随机给定的
    %此处不考虑观测站在同一平面的情况，若在同一平面，可先估计出x,y,再算出z
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
    Node(i).z=Height*rand;
    Node(i).D=Node(i).x^2+Node(i).y^2+Node(i).z^2;  %固定参数便于位置估计
end
    
%目标随机出现在监测场地的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
Target.z=Height*rand;

%观测站探测目标
X=[];   %基站（观测站）的位置集合
Z=[];   %测量距离

for i=1:Node_number
    [d1,d2]=getDist(Node(i),Target);    %观测站离目标的真实距离
    d1=d1+sqrt(R)*randn;    %假设测量距离受到均值为5的高斯白噪声的污染
    X=[X;Node(i).x,Node(i).y,Node(i).z];
    Z=[Z,d1];
end

H=[];b=[];

for i=1:Node_number-1
    H=[H;2*(X(n,1)-X(i,1)),2*(X(n,2)-X(i,2)),2*(X(n,3)-X(i,3))];
    b=[b;Z(i)^2-Z(n)^2+Node(n).D-Node(i).D];
end

% for i=2:Node_number
%     H=[H;2*(X(i,1)-X(1,1)),2*(X(i,2)-X(1,2)),2*(X(i,3)-X(1,3))];
%     b=[b;Z(1)^2-Z(i)^2+Node(i).D-Node(1).D];
% end

Estimate=inv(H'*H)*H'*b;    %目标的估计位置
Est_Target.x=Estimate(1); Est_Target.y=Estimate(2); Est_Target.z=Estimate(3);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure      %画图
hold on;box on;axis([0 100 0 100 0 100]);     %输出图形的框架

for i=1:Node_number
    h1=plot3(Node(i).x,Node(i).y,Node(i).z, 'ko', 'markerface','g','markersize',10);
    text(Node(i).x+2, Node(i).y,Node(i).z,['Node',num2str(i)])
end

%画目标的真实位置和估计位置
h2=plot3(Target.x, Target.y, Target.z,'k^','MarkerFace','b','MarkerSize',10);
h3=plot3(Est_Target.x, Est_Target.y, Est_Target.z,'ks','MarkerFace','r','MarkerSize',10);

[Error_Dist,d2]=getDist(Est_Target,Target);
%将估计位置与真实位置用线连起来
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],[Target.z,Est_Target.z],'color','k');
%标明h1,h2,h3是什么
legend([h1,h2,h3],'observation station','target position', 'estimate position');
xlabel(['error=',num2str(Error_Dist),'m']);
axis square; view(3); grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
