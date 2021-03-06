# PSO-VRPWT

# 项目简介：<br/>
最近需要实现一篇论文的算法，讲的是将PSO(粒子群算法)应用到TSPTW问题(时间窗车辆调度问题)上，查询了一些资料，以往的资料大多是蚁群算法的应用，所以就试着自己一步步完成这个算法。

# 参考论文：<br/>
[1]A Novel Set-Based Particle Swarm Optimization Method for Discrete Optimization Problems<br/>
[2]Gong Y J, Zhang J, Liu O, et al. Optimizing the Vehicle Routing Problem With Time Windows: A Discrete Particle Swarm Optimization Approach[J]. IEEE Transactions on Systems Man & Cybernetics Part C, 2012, 42(2):254-267.<br/>
论文建议先阅读[1], 再阅读[2]会比较好理解，这个算法比较巧妙的地方在于我们将每一个可能的路线规划图作为一个粒子（注意是将整个规划图作为一个粒子而不是规划图中的节点，我们让粒子进行运动并且不断修改它的运动方向，其实就是调整规划图中连接节点各条边的指向，使得粒子位置被不断进行更新，新的粒子对应着各条边被调整后的整幅规划图），我们算法的最终目的就是得到最优的规划图(也就是最好的粒子)，该粒子的适应值(车辆的travelTime和route number)达到最优

# benchmark参考：<br/>
https://www.sintef.no/projectweb/top/vrptw/

# 代码说明：<br/>
整个程序都有注释，按照论文中的算法进行复现，并且能够在控制台显示出路径的优化过程

# 使用说明：<br/>
運行main文件，開始啓動程序，將讀取文件中的data.txt文件並開始計算，將結果輸出至控制臺。<br/>
data.txt格式说明：首行代表仓库，后面100行代表顾客，分别是顾客编号，X坐标，Y坐标，货物需求，最早服务开始时间，最迟服务开始时间，和服务所需时间。<br/>
輸出：迭代次数+全局最優適應值（规划图的闭环数量），隨著迭代次數增加，適應值不斷得到優化，目前是迭代100次。<br/>
本程序可以將路綫數量從17左右優化到5目前最优解是4圈，關於進一步優化的方法還在研究。

# 代码结果展示：
下面输出的是最终的规划图，从0出发有5行，代表5个闭环，以第一个为例子，从0出发到5号顾客，然后从5号顾客出发到92号顾客，依此类推，可以得到5个从0出发最后回到0的路线图。<br/>
0 5<br/>
0 29<br/>
0 33<br/>
0 36<br/>
0 45<br/>
1 89<br/>
2 98<br/>
3 20<br/>
4 74<br/>
5 92<br/>
6 53<br/>
7 18<br/>
8 6<br/>
...



