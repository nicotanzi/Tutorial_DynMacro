%Discrete Cake Eating (Ver. 1)

function [F, vargout] =DCE(NO, betaO,sigmaO, zl0 ,zh0, plh0)

close all;

N=10;
beta=0.9;
dimEps=2;
K0=0.1;
ro=0.95;
K=K0:0.005:4;
R = zeros(1,size(K,2));
r = zeros(1,size(K,2));
U = zeros(1,size(K,2));
zl=4;
zh=2;
plh=0.5;
eps=[zl zh];
pi=[(1-plh) plh; 0.2 0.8]; 
T=100;
toler=.001;
D=zeros(1,T);
sigma=0.4;


%R(1,i) representa a V(zl,ro.*K)
for i=1:size(K,2);
    S = zeros(1,size(K,2)); 
        if sigma==1
    S(1,i)=beta.*(pi(1,2).*eps(1,2).*log((ro).*K(1,i)) + (pi(1,1)).*(ro).*max(K));
        else
    S(1,i)=beta.*( pi(1,2).*eps(1,2).*((ro.*K(1,i)).^(1-sigma))/(1-sigma) + pi(1,1).*(ro).*max(K));
        end
    R(1,i)=S(1,i);
end



for h=1:T;
     
    
for i=1:size(K,2);
    s = zeros(1,size(K,2));
        if sigma==1
    s(1,i)=beta.*(pi(1,2).*eps(1,2).*log(ro.*K(1,i))+(pi(1,1)).*R(1,i));
        else
    s(1,i)=beta.*(pi(1,2).*eps(1,2).*((ro.*K(1,i)).^(1-sigma))/(1-sigma) +(pi(1,1)).*R(1,i));
        end
    r(1,i)=s(1,i);
       
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
    if sigma==1
    U(1,i)=eps(1,2).*log(K(1,i));
        else
    U(1,i)=eps(1,2).*(K(1,i).^(1-sigma))/(1-sigma);
        end
end

figure (3)
plot (K,U,K,r);
legend('Eat','Wait°');
grid