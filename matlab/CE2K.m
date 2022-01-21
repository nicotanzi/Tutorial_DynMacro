%Cake Eating (Ver. 2)

dimIter=30;
beta=0.9;

K=0:0.005:1;
dimK=length(K);

V=zeros(dimK,dimIter);
G=zeros(dimK,dimIter);

for iter=1:dimIter
    
    aux=zeros(dimK,dimK)+NaN;
    for ik=1:dimK
        for ik2=1:(ik-1)
            aux(ik,ik2)=log(K(ik)-K(ik2))+beta.*V(ik2,iter);
        end
    end
    V(:,iter+1)= max(aux')';

end

plot(V);