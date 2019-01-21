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
        X=[X;Node(i).x, Node(i).y];  %保存探测到目标的观测站位置
    end 
end

M=size(X,1);    %探测到目标的观测站个数
if M>0
    Est_Target.x=sum(X(:,1))/M;     %质心算法估计位置x
    Est_Target.y=sum(X(:,2))/M;     %质心算法估计位置y
    Error_Dist=getDist(Est_Target,Target) %目标真实位置与估计位置的偏差距离
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure      %画图
hold on;box on;axis([0 100 0 100]);     %输出图形的框架
for i=1:N
    h1=plot(Node(i).x,Node(i).y,'ko','markerface','g','MarkerSize',10); 
    text(Node(i).x+2,Node(i).y,['Node',num2str(i)]); %
end
%画目标的真实位置和估计位置
h2=plot(Target.x, Target.y,'k^','MarkerFace','b','MarkerSize',10);
h3=plot(Est_Target.x, Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);

%将估计位置与真实位置用线连起来
line([Target.x,Est_Target.x],[Target.y,Est_Target.y],'color','k');
%画出目标方圆d的范围
circle(Target.x,Target.y,d);
%标明h1,h2,h3是什么
legend([h1,h2,h3],'observation station','target position', 'estimate position');
xlabel(['error=',num2str(Error_Dist),'m']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
