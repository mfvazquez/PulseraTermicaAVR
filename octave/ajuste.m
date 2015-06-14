function ajuste(archivo)

% CONSTANTES


V=0:0.01:2;
T=0:0.225:45;

%---------- INGRESO DE DATOS ------------------------

medicion = dlmread(archivo,'\t',1,0);

%---------- AJUSTES ---------------------------------


rmedicion = medicion;					% Se inicializa una nueva matriz
rmedicion(:,2) = rmedicion(:,2).^-1
Param=fmins('steinhart',[1 1 1],[0,0.0001,0,0,0,0,0,0,0,],[],rmedicion(2:end,:)');	% Param es un vector donde el primer elemento es A y el segundo B						
A=Param(1)   % A/V^2
B=Param(2)
C=Param(3)

%---------- GRAFICOS --------------------------------

figure
hold on


rmedicion(:,2) = rmedicion(:,2).^-1;
plot(rmedicion(:,1),rmedicion(:,2),'ro','Markersize',5)
plot(V,((A+B*log(V)+C*(log(V)).^3).^-1),'r-','Linewidth',1)


L = legend(sprintf('M1 A = %f  B= %f  C = %f',A, B, C),'location', 'northwest');


%Estos comandos agregan rotulos y detalles a los graficos
xlabel('V [V]')
ylabel('T [°C]')
%axis([0 2 20 45])
grid minor

% Una vez generada la imagen, se imprime a un archivo (recordar "help print" para obtener ayuda con la funcion).
print(strcat(archivo, '.png'),'-dpng');



