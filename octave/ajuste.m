

% CONSTANTES


V=0:0.01:2;
T=0:0.225:45;

%---------- INGRESO DE DATOS ------------------------

medicion = dlmread('temperatura_ambiente.txt','\t',1,0);

%---------- AJUSTES ---------------------------------

rmedicion = medicion;					% Se inicializa una nueva matriz
Param=fmins('A_x_mas_B',[.707 -1.06],[0,0.0001,0,0,0,0,0,0,0,],[],rmedicion(2:end,:)');	% Param es un vector donde el primer elemento es A y el segundo B						
A=Param(1)   % A/V^2
B=Param(2)


%---------- GRAFICOS --------------------------------

figure
hold on


plot(rmedicion(:,1),rmedicion(:,2),'ro','Markersize',5)

plot(V,A*V+B,'r-','Linewidth',1)


L = legend(sprintf('M1 A = %f  B= %f',A, B),'location', 'northwest');


%Estos comandos agregan rotulos y detalles a los graficos
xlabel('V [V]')
ylabel('T [°C]')
axis([0 2 25 45])
grid minor

% Una vez generada la imagen, se imprime a un archivo (recordar "help print" para obtener ayuda con la funcion).
print('V_T.png','-dpng');



