% Cake Eating Problem
function [F, vargout] =CE(NO, betaO,sigmaO)
close all;
clearvars

%Par�metros del modelo
N=100; %Number of states grid
beta=0.99; %factor de descuento
sigma=1; %par�metro de la funci�n de utilidad. Si sigma=1 entonces u(c)=ln(c)

%Espacio de estados
K=1:0.5:200; %tama�o posible de la torta

%N�mero de iteraciones
T=100;
toler=.001; 

%Vectores de zeros donde se almacenar�n los resultados
R = zeros(1,size(K,2));
r = zeros(1,size(K,2));
m = zeros(1,size(K,2));
Kprime = zeros(1,size(K,2));
D=zeros(1,T);

for i=1:size(K,2);
    S = zeros(size(K,2),1);
    for j=1:i-1;
        c(i,j)=K(1,i)-K(1,j);
        if sigma==1 %Elecc�n de la funci�n de utilidad
    S(j,1)=log(K(1,i)-K(1,j))+beta.*max(K); %�usa como guess la funci�n m�ximo como funcion de valor?
        else
    S(j,1)=((K(1,i)-K(1,j)).^(1-sigma))./(1-sigma)+beta.*max(K);
        end
    end  
    R(1,i)=max(S); %Toma el m�ximo de u+beta*v0(K)
end

%Iteraciones para las condiciones (3.1) y (3.2)
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

if abs (diff)<=toler %verfico la condicion (3.2)
    break
else
    R=r;
end
D(1,h)=max(diff); %vector V_n - V_{n-1}
end

F=r;
figure (1) %Funcion de valor a la que converge
plot (F);

figure (2) % Velocidad de convergencia
plot(D);

for i=1:size(K,2)
    Kprime(1,i)=K(1,m(1,i)); %Construccion k' en la funcion de pol�tica
end

%Funcion de pol�tica
figure (3)
plot (K,Kprime,K,K);
legend('Policy Fuction','45�');
grid