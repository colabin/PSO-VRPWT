function cost = GetCost(xi,customers)
%UPDATEV Summary of this function goes here
%   Detailed explanation goes here
routeCount=0;
travelTime=0;
for x=1:101
    for y=1:101
        if(xi(x,y)==1)
            travelTime=travelTime+sqrt((customers(x,1)-customers(y,1))^2+(customers(x,2)-customers(y,2))^2);
        end
    end
end
for x=1:101
    if(xi(1,x)==1)
        routeCount=routeCount+1;
    end
end

fprintf('%d\n',travelTime);
cost=routeCount + atan(travelTime)*2/pi;  

