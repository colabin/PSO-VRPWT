# PSO-VRPWT

项目简介：<br/>
最近需要实现一篇论文的算法，讲的是将PSO(粒子群算法)应用到TSPTW问题(时间窗车辆调度问题)上，查询了一些资料，以往的资料大多是蚁群算法的应用，所以就试着自己一步步完成这个算法。

参考论文：<br/>
[1]A Novel Set-Based Particle Swarm Optimization Method for Discrete Optimization Problems
[2]Gong Y J, Zhang J, Liu O, et al. Optimizing the Vehicle Routing Problem With Time Windows: A Discrete Particle Swarm Optimization Approach[J]. IEEE Transactions on Systems Man & Cybernetics Part C, 2012, 42(2):254-267.<br/>
论文建议先阅读[1], 再阅读[2]会比较好理解，这个算法比较巧妙的地方在于我们将每一个可能的路线规划图作为一个粒子（注意是将整个规划图作为一个粒子而不是规划图中的节点，我们让粒子进行运动并且不断修改它的运动方向，其实就是调整规划图中连接节点各条边的指向，使得粒子位置被不断进行更新，新的粒子对应着各条边被调整后的整幅规划图），我们算法的最终目的就是得到最优的规划图(也就是最好的粒子)，该粒子的适应值(车辆的travelTime和route number)达到最优

benchmark参考：<br/>
https://www.sintef.no/projectweb/top/vrptw/

代码说明：<br/>
笔者是临时学的matlab，命名等细节不太规范，整个程序都有注释，按照论文中的算法进行复现，并且能够在控制台显示出路径的优化过程，因为设备，对参数设置细节不清楚，时间问题等其他方面原因，没有达到论文中的效果，但是优化过程确实体现出粒子群算法的优化效果，读者可以对参数和迭代步骤可以进行进一步优化

