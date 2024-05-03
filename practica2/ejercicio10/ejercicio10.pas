program untitled;
uses crt;
const
	valorAlto = 'zzzz';
type
	reg_empleado = record
		departamento:string;
		division:integer;
		numero:integer;
		categoria:integer;
		horas:integer;
	end;
	
	valor_hora = array of real;

	mae_empleado = file of reg_empleado;


procedure obtenerValores(var valores:valor_hora);
var
	categoria,i:integer;
	archivo:text;
	valor:real;
begin
	
	assign(archivo,'valoresPorHora.txt');
	reset(archivo);
	
	for i:= 1 to 15 do begin
		read(archivo,categoria,valor);
		valores[categoria]:= valor;
	end;
	
	close(archivo);
	
end;
procedure leer(var mae:mae_empleado,regM:reg_empleado);
begin
	if not EOF(mae)then
		read(mae,regM)
	else
		regM.departamento:= 'zzzz'
end;

procedure informar(var mae:mae_empleado,valores:valor_hora);
var
	act_dep:string;
	act_div,horas_div,horas_dep:integer;
	monto_div,monto_dep:real;
	regM:reg_empleado;
begin
	assign(mae,'archivo_empleados');
	reset(mae);
	leer(mae,regM);
	
	while(regM.departamento <> valorAlto)do begin
	
		writeln('Departamento: ',regM.departamento);
		horas_dep:= 0;
		monto_dep:= 0;
		act_dep:= regM.departamento;
		
		while(regM.departamento = act_dep)do begin
		
			writeln('Division: ',regM.division);
			horas_div:= 0;
			monto_div:= 0;
			act_div:= regM.division;
			
			while(regM.departamento = act_dep)and(regM.division = act_div)do begin
				
				writeln('El número de empleado es: ',regM.numero);
				writeln('Total de horas trabajadas: ',regM.horas);
				writeln('Monto a cobrar: ',valores[regM.categoria]*regM.horas);
				monto_div:= monto_div + (valores[regM.categoria]*regM.horas));
				horas_div:= horas_div + regM.horas);
				
				leer(mae,regM);
			
			end;
			
			writeln('Total de horas de la division: ',horas_div);
			writeln('Monto a cobrar de la division: ',monto_div);
			writeln();
		end;
		
		writeln('Total de horas del departamento: ',horas_dep);
		writeln('Monto a cobrar del departamento: ',monto_dep);
	
	end;
	
	close(mae);
	
end;




var i : byte;

BEGIN
	
	
END.

