function [yi,quality,clock,result] = isValid(j,x,clock,yi,quality,customers,result)
%UPDATEV Summary of this function goes here
%   Detailed explanation goes here
if(j==x)
    result=0;
    return;
end
if(x==1)
    result=0;
    return;
end
if(yi(x)==1)
    result=0;
    return;
end
if(customers(x,3)>quality)
    result=0;
    return;
end
e_time=customers(x,4);
l_time=customers(x,5);
distance=sqrt((customers(x,1)-customers(j,1))^2+(customers(x,2)-customers(j,2))^2);
arrive_time=clock+distance;
if(arrive_time>l_time)
    result=0;
    return;
end

leave_time=max(arrive_time,e_time)+customers(x,6);

% yi(x)=1;
quality=quality-customers(x,3);
clock=leave_time;
result=1;

