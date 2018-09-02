function sort = AdaMatrix(customers)
%UPDATEV Summary of this function goes here
%   Detailed explanation goes here

sort=zeros(102,102);
for i=1:102
    for j=1:102
        sort(i,j)=j;
    end
end

cusDistance=zeros(102,102);
for i=1:102
    for j=1:102
%         fprintf('%d,%d\n',customers(i,2),customers(j,2));
%         fprintf('%d,%d\n',customers(i,3),customers(j,3));
       cusDistance(i,j) = sqrt((customers(i,1)-customers(j,1))^2+(customers(i,2)-customers(j,2))^2);
    end
end

m=cusDistance(102,:);

for f=1:102
    for k=1:102
        for m=k+1:102
            if (cusDistance(f,k) > cusDistance(f,m))  		              
		                temp = cusDistance(f,m);
		                cusDistance(f,m)=cusDistance(f,k);
		                cusDistance(f,k) = temp;
		                tmp2 = sort(f,m);
		                sort(f,m)=sort(f,k);
		                sort(f,k)=tmp2;
            end
        end
    end
end