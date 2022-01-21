%% Cake Eating Problem

% Existe una torta con tamaño constante através del tiempo
% Hay un consumidor representativo, con preferencias CRRA caracterizadas por
% Factor de descuento: beta
% Coeficiente de Aversión al Riesgo Relativo: sigma

% Se produce usando únicamente capital anterior, con la función:
% Y(t) = A K(t-1) ^ alfa
% A > 0     y    0 < alfa < 1 

% El capital se deprecia a una tasa delta
% Por ende la riqueza (ingreso + capital) es:
% W(t) = A K(t-1) ^ alfa  +   (1-delta) K(t-1)

% K(t) representa el capital elegido en el período t
% c(t) representa el consumo elegido en el período t
% La ley de mov del capital es: , W(t) = K(t) - c(t),
% y K(t)>= 0   c(t)>=0 

% La ecuación de Bellman puede escribirse como:
% V(K) = max{ U(f(K)-K') + beta V(K') }
% Donde, maximizamos respecto a K'
% Donde, W(t) = f( K(t-1) )

% El objetivo es hallar V(), lo haremos iterativamente
% En vez de V ponemos un V_n en el lado derecho de la ecuación
% Eso nos escupe una nueva función que llamaremos V_n+1
% Como el operador de Bellman es una contracción nos acercamos a V

% Pensaremos a una función somo un conjunto de pares ordenados:
% {(y,x): y=f(x)} el código nos permitirá hallar el conjunto
% Pero no nos permitira hallar la forma funcional

close all; % limpio el espacio de trabajo de MATLAB

%% PARÁMETROS

beta=0.99; % beta del problema
sigma=1;
K=1:0.5:200; % K es el vector (fila) de valores que puede tomar la torta
T=174; % Número de iteraciones
toler=.0001;