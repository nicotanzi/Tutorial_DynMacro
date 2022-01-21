% Cake Eating Problem

function [F, vargout] =CE(NO, betaO,sigmaO)

close all;

N=NO;
beta=betaO;
K=1:0.5:200;
R = zeros(1,size(K,2));
r = zeros(1,size(K,2));
m = zeros(1,size(K,2));
Kprime = zeros(1,size(K,2));
T=100;
toler=.001;
D=zeros(1,T);
sigma=sigmaO;



for i=1:size(K,2);
    S = zeros(size(K,2),1);
    for j=1:i-1;   
        if sigma==1
    S(j,1)=log(K(1,i)-K(1,j))+beta.*max(K);
        else
    S(j,1)=((K(1,i)-K(1,j)).^(1-sigma))./(1-sigma)+beta.*max(K);
        end
    end  
    R(1,i)=max(S);
end



for h=1:T;
     
    
for i=1:size(K,2);
    s = zeros(size(K,2),1);
    for j=1:i-1;
        if sigma==1
    s(j,1)=log(K(1,i)-K(1,j))+beta.*R(1,j);
        else
    s(j,1)=((K(1,i)-K(1,j)).^(1-sigma))./(1-sigma)+beta.*R(1,j);
        end
    end
    [r(1,i),m(1,i)]=max(s);
       
end  

diff=(R-r);

if abs (diff)<=toler
    break
else
    R=r;
end
D(1,h)=max(diff);
end

F=r;
figure (1)
plot (F);
figure (2)
plot(D);

for i=1:size(K,2)
    Kprime(1,i)=K(1,m(1,i));
end

figure (3)
plot (K,Kprime,K,K);
legend('Policy Fuction','45°');
grid