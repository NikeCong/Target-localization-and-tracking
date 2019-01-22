%网格定位算法
%定位初始化
Length=100; %场地空间长度，单位：米
Width=100;  %场地空间宽度，单位：米
d=50;       %观测站最大测量距离
Xnum=5;     %观测站在水平方向的个数
Ynum=5;     %观测站在垂直方向的个数
divX=Length/Xnum/2;divY=Width/Ynum/2;   %为了在正中间查看观测站分布调节量（主要体现在图的坐标系上面）
 
%目标随机出现在监测场地的真实位置，这里也随机给定
Target.x=Width*(Xnum-1)/Xnum*rand;      %(Xnum-1)/Xnum对目标的x轴做了限制，最大坐标只能到（80，80），因为这里的场地空间100*100为从-10-->90*-10-->90,如果无(Xnum-1)/Xnum，则目标位置可能（100,100），超出了范围
Target.y=Length*(Ynum-1)/Ynum*rand;     %同上

DIST=[];   %放置观测站与目标之间距离的集合
for j=1:Ynum   %观测站的网格部署 j表示行数，从下往上数为1-->5
    for i=1:Xnum
        Station((j-1)*Xnum+i).x=(i-1)*Length/Xnum; %j=1: 1.x-->5.x   j=2: 6.x-->10.x  ...
        Station((j-1)*Xnum+i).y=(j-1)*Length/Ynum;
        dd=getDist(Station((j-1)*Xnum+i),Target);
        DIST=[DIST dd]; %=[DIST,dd];
    end
end

%找出探测到目标信号最强的三个观测站，也就是离目标最近的观测站
[set,index]=sort(DIST) %set为排列好的从小到大的数值集合，index为索引集合
NI=index(1:3);  %最近的3个，即index1~3个元素
Est_Target.x=0;      %目标估计位置x初始化
Est_Target.y=0;      %目标估计位置y初始化
if DIST(NI(3))<d      %检查3个中最大的那个数是否在观测站可探测距离范围之内
    for i=1:3
        Est_Target.x=Est_Target.x+Station(NI(i)).x/3;      %目标估计位置x
        Est_Target.y=Est_Target.y+Station(NI(i)).y/3;      %目标估计位置y
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure      %画图
hold on;box on;axis([0-divX Length-divX 0-divY Width-divX]);     %输出图形的框架
xx=[Station(NI(1)).x, Station(NI(2)).x, Station(NI(3)).x];
yy=[Station(NI(1)).y, Station(NI(2)).y, Station(NI(3)).y];
fill(xx,yy,'y');

for j=1:Ynum   %观测站的网格部署 j表示行数，从下往上数为1-->5
    for i=1:Xnum
        h1=plot(Station((j-1)*Xnum+i).x, Station((j-1)*Xnum+i).y, '-ko', 'markerface','g');
        text(Station((j-1)*Xnum+i).x+1, Station((j-1)*Xnum+i).y, num2str((j-1)*Xnum+i));
    end
end

Error_Dist=getDist(Est_Target,Target);
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
