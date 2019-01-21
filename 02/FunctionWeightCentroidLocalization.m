%加权质心算法
%定位初始化
Length=100; %场地空间长度，单位：米
Width=100;  %场地空间宽度，单位：米
d=50;       %观测站最大测量距离
Node_number=6;        %观测站个数
SNR=50;     %信噪比,单位db

for i=1:Node_number   %观测站位置初始化，位置随机给定
    Node(i).x=Width*rand;
    Node(i).y=Length*rand;
end

%目标出现在监测场地的真实位置，这里也随机给定
Target.x=Width*rand;
Target.y=Length*rand;
X=[];   %初始化，找出能探测到目标的观测站的位置集合
W=[];   %权值 
for i=1:Node_number
    dd=getDist(Node(i),Target);
    Q=(1/dd)/(10^(20/SNR));  %根据信噪比公式求噪声方差, 这里假设S与距离满足S=1/dd关系
    if dd<=d
        X=[X;Node(i).x,Node(i).y];
        W=[W,1/((dd+sqrt(Q)*randn))^2]; %信号衰减公式
    end
end

%权值归一化
W=W./sum(W);    %表示W中的每一个值与sum(W)相除
M=size(X,1);    %探测到目标的观测站个数
sumx=0;sumy=0;
for i=1:M
    sumx=sumx+X(i,1)*W(i);
    sumy=sumy+X(i,2)*W(i);
end
Est_Target.x=sumx;      %目标估计位置x
Est_Target.y=sumy;      %目标估计位置y
Error_Dist=getDist(Est_Target,Target)      %目标真实位置与估计位置的偏差距离
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure      %画图
hold on;box on;axis([0 100 0 100]);     %输出图形的框架
for i=1:Node_number
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
