function [l1,l2,l3,v1,v2,v3,v4,v5,v6,v7,v8,v9] ...
                        = eigen3d_m(x1,x2,x3,x4,x5,x6,x7,x8,x9)

%% matlab version
l1 = zeros(size(x1));
l2 = zeros(size(x1));
l3 = zeros(size(x1));
v1 = zeros(size(x1));
v2 = zeros(size(x1));
v3 = zeros(size(x1));
v4 = zeros(size(x1));
v5 = zeros(size(x1));
v6 = zeros(size(x1));
v7 = zeros(size(x1));
v8 = zeros(size(x1));
v9 = zeros(size(x1));
for i=1:size(x1,1)
    for j=1:size(x1,2)
        for k=1:size(x1,3)
            [v,d] = eig([x1(i,j,k) x2(i,j,k) x3(i,j,k); x4(i,j,k) x5(i,j,k) x6(i,j,k); x7(i,j,k) x8(i,j,k) x9(i,j,k)]);
            l1(i,j,k) = d(1,1);
            l2(i,j,k) = d(2,2);
            l3(i,j,k) = d(3,3);            
            v1(i,j,k) = v(1,1);
            v2(i,j,k) = v(2,1);
            v3(i,j,k) = v(3,1);
            v4(i,j,k) = v(1,2);
            v5(i,j,k) = v(2,2);
            v6(i,j,k) = v(3,2);
            v7(i,j,k) = v(1,3);
            v8(i,j,k) = v(2,3);
            v9(i,j,k) = v(3,3);
        end
    end
end

end