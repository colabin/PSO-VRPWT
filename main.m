clear all;
%设置数据格式
format long;
%设置粒子群算法参数
max_iteration=30;         %最大迭代次数
swarm_size=10;             %种群规模（粒子数量）
particle_size=101;            %粒子维数(100个顾客和1个仓库）

%存储顾客属性的矩阵,屬性參照d.xls文件
customers=zeros(particle_size,6);
%粒子群位置
particle=zeros(max_iteration,swarm_size,particle_size,particle_size);
%粒子群速度矩阵
velocity=zeros(max_iteration,swarm_size,particle_size,particle_size,1);
%全局速度矩陣
eset=zeros(particle_size,particle_size);
%局部最优粒子位置及适应度矩阵
pbest=zeros(max_iteration,swarm_size,particle_size,particle_size);
%全局最优粒子位置及适应度矩阵
gbest=zeros(max_iteration,particle_size,particle_size);

%读入顾客信息
% NUM = xlsread('data.xls');
NUM=importdata('data.txt');

customers=NUM(:,2:7);
%sortMatrix=AdaMatrix(customers);

% for x=1:102
%        fprintf('%d ',sortMatrix(102,x));
% end


%生成Eset
for x=1:particle_size
    for y=1:particle_size
        if(x~=y&&y~=1)    %默認不前往仓库和自己位置
            eset(x,y)=1;
        end
    end
end


%初始化粒子群，生成swarm个从仓库出发首尾相连的路线图
for x=1:swarm_size
    cus=randperm(particle_size-1)+1; %2-101的随机顺序
    cus=[1,cus]; %从仓库出发
    for y=1:particle_size-1
        particle(1,x,cus(y),cus(y+1))=1;
    end
    particle(1,x,cus(particle_size),1)=1; %最后回到仓库
end

%初始化速度
for x=1:swarm_size
    for y=1:particle_size
        for z=1:particle_size
            num=rand();
            if(num<0.6&&y~=z&&z~=1)
                velocity(1,x,y,z,1)=rand();
            end
        end
    end
end

%
%初始化pbest和gbest,gbest设置第一个粒子
for x=1:swarm_size
    for y=1:particle_size
        for z=1:particle_size
            pbest(1,x,y,z)= particle(1,x,y,z);
        end
    end
end
for x=1:particle_size
    for y=1:particle_size
        gbest(1,x,y)= particle(1,1,x,y);
    end
end

for iteration=1:100
    for index=1:swarm_size
        clock=0;;
        quality=1000;

        yi=zeros(particle_size);
        velocity=UpdateVelocity(particle,index,velocity,pbest,iteration);

        %    cut速度
        for x=1:particle_size
            for y=1:particle_size
                if(velocity(iteration,index,x,y,1)<0.5)
                    velocity(iteration,index,x,y,1)=0;
                end;
            end
        end

        %       update Xi*
        particle_new=zeros(particle_size,particle_size);

        serve_num=0;
        j=1; %从仓库出发
        while(serve_num<100)

            flag = false ;
            result=0;
            %從v裏面找
            v=[];
            for x=1:particle_size
                if(velocity(iteration,index,j,x,1)>0)
                    v=[x,v];
                end
            end
            v= v(randperm(length(v))); %把速度打乱，增加速度多样性

            num=rand();%用于粒子的选取
            if(num>0.5)
                heru=99999;
                nextCus = 0;
                r_clock = 0;
                r_quality = 0;
                for x=1:length(v)
                    [ryi,rquality,rclock,result]=isValid(j,v(x),clock,yi,quality,customers,result);
                    if(result==1)
                        bkm = max(now+ sqrt((customers(v(x),1) - customers(j,1))^2+ (customers(v(x),2) - customers(j,2))^2), customers(v(x),4))-now;
                        rkm = customers(v(x),5)- ( now+ sqrt((customers(v(x),1) - customers(j,1))^2+ (customers(v(x),2) - customers(j,2))^2));
                        if(bkm+rkm<heru)
                            heru = bkm+rkm;
                            nextCus = v(x);
                            r_clock = rclock;
                            r_quality = rquality;
                        end
                    end
                end

                if(nextCus>0)
                    fprintf('vset %d %d\n',j,nextCus)
                    yi(nextCus)=1;
                    quality=rquality;
                    clock=rclock;
                    particle_new(j,nextCus)=1;
                    j=nextCus;
                    serve_num=serve_num+1;
                    if(serve_num==100)
                        particle_new(j,1)=1; %服务完最后一个顾客后返回仓库
                    end
                    flag=true;
                end


            else
                for l=1:length(v)
                    x=v(l);
                    %                 if(velocity(iteration,index,j,x,1)>0)
                    %               for x=2:particle_size
                    %                 if(velocity(iteration,index,j,x,1)>0)
                    [ryi,rquality,rclock,result]=isValid(j,x,clock,yi,quality,customers,result);
                    if(result==1)
                        fprintf('heru method vset %d %d\n',j,x)
                        yi(x)=1;
                        quality=rquality;
                        clock=rclock;
                        particle_new(j,x)=1;
                        j=x;
                        serve_num=serve_num+1;
                        if(serve_num==100)
                            particle_new(j,1)=1; %服务完最后一个顾客后返回仓库
                        end
                        flag=true;
                        break;
                    end
                    %                 end
                end
            end
            %从x找
            if(flag==false)
                for x=2:particle_size
                    if(particle(iteration,index,j,x)==1)
                        [ryi,rquality,rclock,result]=isValid(j,x,clock,yi,quality,customers,result);
                        if(result==1)
                            fprintf('xset %d %d\n',j,x)
                            yi(x)=1;
                            quality=rquality;
                            clock=rclock;
                            particle_new(j,x)=1;
                            j=x;
                            serve_num=serve_num+1;
                            if(serve_num==100)
                                particle_new(j,1)=1; %服务完最后一个顾客后返回仓库
                            end
                            flag=true;
                            break;
                        end
                    end
                end
            end
            %从eset里面找
            if(flag==false)
                heru=99999;
                nextCus = 0;
                r_clock = 0;
                r_quality = 0;
                for x=2:101
                    [ryi,rquality,rclock,result]=isValid(j,x,clock,yi,quality,customers,result);
                    if(result==1)
                        bkm = max(now+ sqrt((customers(x,1) - customers(j,1))^2+ (customers(x,2) - customers(j,2))^2), customers(x,4))-now;
                        rkm = customers(x,5)- ( now+ sqrt((customers(x,1) - customers(j,1))^2+ (customers(x,2) - customers(j,2))^2));

                        if(bkm+rkm<heru)
                            heru = bkm+rkm;
                            nextCus = x;
                            r_clock = rclock;
                            r_quality = rquality;
                        end
                    end
                end

                if(nextCus>0)
                    fprintf('eset %d %d\n',j,nextCus)
                    yi(nextCus)=1;
                    quality=rquality;
                    clock=rclock;
                    particle_new(j,nextCus)=1;
                    j=nextCus;
                    serve_num=serve_num+1;
                    if(serve_num==100)
                        particle_new(j,1)=1; %服务完最后一个顾客后返回仓库
                    end
                    flag=true;
                end
            end

            %都没找到返回仓库，重置時間和貨物后繼續尋找下一個顧客
            if(flag==false)
                clock=0;
                quality=1000;
                particle_new(j,1)=1;
                j=1;
                disp('回到仓库');

            end
        end

        %更新对应位置上的粒子
        particle(iteration+1,index,:,:)= particle_new(:,:);
%         GetCost(particle_new,customers);
    end

    %更新pbest和gbest
    for par=1:swarm_size
        m=zeros(101,101);
        n=zeros(101,101);
        m(:,:)=pbest(iteration,par,:,:);
        n(:,:)=particle(iteration+1,par,:,:);
        if(iteration==1)
            cost1 = 999;  %如果是第一次迭代則設置為很大用於更新
        else
            cost1 = GetCost(m,customers);
        end
        cost2 = GetCost(n,customers);
        if(cost1>cost2)
            pbest(iteration+1,par,:,:)=particle(iteration+1,par,:,:);
%             n(:,:)=particle(iteration+1,par,:,:);
%             cost2=GetCost(n,customers);
        else
            pbest(iteration+1,par,:,:)=pbest(iteration,par,:,:);
        end
    end
    %更新gbest
    temp=zeros(101,101);
    temp(:,:)=gbest(iteration,:,:);
    for par=1:swarm_size
        m=zeros(101,101);
        n=zeros(101,101);
        n(:,:)=pbest(iteration+1,par,:,:);
        cost2=GetCost(n,customers);
        if(iteration==1&&par==1)
            cost1 = 999;
        else
            cost1 = GetCost(temp,customers);
        end
        if(cost1>cost2)
            disp(iteration);
            disp(cost2);
            cost1=cost2;
            temp(:,:)=n(:,:);
        end
    end
    gbest(iteration+1,:,:)=temp(:,:);
end

%打印最後的結果
for x=1:101
    for y=1:101
        if(gbest(101,x,y))==1
            fprintf('%d %d\n',x-1,y-1);
           
        end
    end
end

 temp2=zeros(101,101);
 temp2(:,:)=gbest(101,:,:);
 fprintf('%d \n',GetCost(temp2,customers));