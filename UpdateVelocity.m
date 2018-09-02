function velocity = UpdateVelocity(particle,index,velocity,pbest,iteration)
%UPDATEV Summary of this function goes here
%   Detailed explanation goes here
w = 0.7;
c = 2;
%velocity=zeros(max_iteration,swarm_size,particle_size,particle_size,1);

for x=1:101
    for y=1:101
        if( velocity(iteration,index,x,y,1)*w>1)
            velocity(iteration,index,x,y,1)=1;
        else
            velocity(iteration,index,x,y,1)=velocity(iteration,index,x,y,1)*w;
        end
    end
end



self_position=zeros(101,2); %记录每个点的上一个顾客和下一个顾客
for x=1:101
    for y=1:101
        if(particle(iteration,index,x,y)==1)
            self_position(y,1)=x;
            self_position(x,2)=y;
            break;
%         elseif(y==102)
%             disp(111111111111111111);
%             disp(x);
        end
    end
end

best_order=zeros(10,101,2); %记录每个点的上一个顾客和下一个顾客
for size=1:10
    for x=1:101
        for y=1:101
            if(pbest(iteration,size,x,y)==1)
                best_order(size,y,1)=x;
                best_order(size,x,2)=y;
                
%             elseif(y==102)
%                 disp(222222222222);
%                 disp(x);
            end
        end
    end
end

best_position=zeros(101,2);
for dimension=2:101
    num=rand();%用于粒子的选取
    num2=rand();%用於更新概率 
    if(num<0.3)
        for x=1:101
            for y=1:2
                best_position(x,y)=best_order(index,x,y);
            end
        end
    else
        choose=round(rand()*9+1);  %这里的10是swarm_size
        for x=1:101
            for y=1:2
                best_position(x,y)=best_order(choose,x,y);
            end
        end
    end

    it=iteration+1;
    if( best_position(dimension,1)~=0&&best_position(dimension,1)~= self_position(dimension,1))
       
        if(c*num2>1)
            velocity(it,index,best_position(dimension,1),dimension,1)=1;
        elseif(c*num2>velocity(iteration,index,best_position(dimension,1),dimension,1))
            velocity(it,index,best_position(dimension,1),dimension,1)=c*num2;
        end
    end
    if( best_position(dimension,2)~=0&&best_position(dimension,2)~= self_position(dimension,2))
       
        if(c*num2>1)
            velocity(it,index,dimension,best_position(dimension,2),1)=1;
        elseif(c*num2>velocity(iteration,index,dimension,best_position(dimension,2),1))
            velocity(it,index,dimension,best_position(dimension,2),1)=c*num2;
        end
    end
end





