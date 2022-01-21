%Discrete Cake Eating Problem

itermax=60;
dimK=100;
dimEps=2;
K0=2;
ro=0.95;
beta=0.95;

K=0:1:(dimK-1);
K=K0*ro.^K';

eps=[0.8,1.2];
pi=[0.6 0.4;0.2 0.8];

V=zeros(dimK,dimEps);

auxV=zeros(dimK,dimEps);

for iter=1:itermax;
    for ik=1:(dimK-1);
        for ieps=1:dimEps;
            Vnow=sqrt(K(ik))*eps(ieps);
            Vwait=pi(ieps,1)*V(ik+1,1)+pi(ieps,2)*V(ik+1,2);
            auxV(ik,ieps)=max(Vnow,beta*Vwait);
        end
    end
    V=auxV;
end

plot(K,V)