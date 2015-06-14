function error_cuadr=A_log_B_x(Param,puntos)

	A=Param(1);
	B=Param(2);
	x=puntos(1,:);
	y=puntos(2,:);

% La función devuelve el error cuadratico, es decir, la sumatoria de los cuadrados de 
% la diferencia entre los datos experimentales de y y la función de ajuste:

	error_cuadr=sum((y-(A*log(B*x))).^2);

endfunction
