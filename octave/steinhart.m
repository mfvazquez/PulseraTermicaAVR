%-----------------------------------------------------
% Dispositivos Semiconductores 66.25/86.03
% http://www.fi.uba.ar/materias/6625
%  Contenido: Funcion auxiliar para el ajuste de curvas de MOSFETs del TP Nº1 en Octave
%  Autor: Ing. Ariel Lutenberg
%  Fecha: 29 de Junio de 2008
%  Modificado por:
%   - Diego Fanego (12 de marzo de 2010)
%   - Sebastián Carbonetto (17 de septiembre de 2013)
%-----------------------------------------------------

%El objetivo del ajuste mediante esta funcion y 'fminserach' es minimizar 
% iterativamente el error cuadratico entre los valores de Y medidos y el 
% resultado de Y = A*X+B , donde A y B son los parámetros de ajuste, y 
% dependiendo de la curva a ajustar, se relacionarán con los parámetros
% eléctricos de alguna manera

function error_cuadr=steinhart(Param,puntos)

	A=Param(1);
	B=Param(2);
	C=Param(3);
	x=puntos(1,:);
	y=puntos(2,:);

%-----------------------------------------------------
% La función devuelve el error cuadratico, es decir, la sumatoria de los cuadrados de 
% la diferencia entre los datos experimentales de y y la función de ajuste:

	error_cuadr=sum((y-(A+B*log(x)+C*(log(x)).^3)).^2);

endfunction
