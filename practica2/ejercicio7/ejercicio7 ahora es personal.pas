program untitled;
uses sysutils;
const
	df = 10;
	valorAlto = 9999;
type

	detalle = record
		cod_localidad:integer;
		cod_cepa:integer;
		casos_activos:integer;
		casos_nuevos:integer;
		casos_recuperados:integer;
		casos_fallecidos:integer;
	end;
	
	maestro = record
		cod_localidad:integer;
		nombre_localidad:string;
		cod_cepa:integer;
		nombre_cepa:integer;
		casos_activos:integer;
		casos_nuevos:integer;
		casos_recuperados:integer;
		casos_fallecidos:integer;
	end;
	
	detalle_file = file of detalle;
	maestro_file = file of maestro;
	
	array_detalle_file = array[1..df] of detalle_file;
	array_detalle_reg = array[1..df] of detalle;

procedure leer(var archivo:detalle_file;var reg:detalle);
begin
	if not EOF(archivo)then
		read(archivo,reg)
	else
		reg.cod_localidad:= valorAlto;
end;

procedure assignResetLeer(var array_file:array_detalle_file;var array_reg:array_detalle_reg);
var
	i:integer;
begin
	for i:= 1 to df do begin
		assign(array_file[i],'detalle'+IntToStr(i));
		reset(array_file[i]);
		leer(array_file[i],array_reg[i]);
	end;
end;

procedure minimo(var array_file:array_detalle_file;var array_reg:array_detalle_reg;var min:detalle);
var
	pos,i:integer;
begin
	min.cod_localidad:= valorAlto;
	min.cod_cepa:= valorAlto;
	
	for i:=1 to df do 
		if(array_reg[i].cod_localidad < min.cod_localidad)OR((array_reg[i].cod_localidad = min.cod_localidad)and(array_reg[i].cod_cepa < min.cod_cepa))then begin
			min:= array_reg[i];
			pos:= i;
		end;
	
	leer(array_file[pos],array_reg[pos]);
	
end;
procedure cerrarDetalles(var array_file:array_detalle_file);
var
	i:integer;
begin
	for i:=1 to df do
		close(array_file[i]);
end;

procedure actualizarMaestro(var array_file:array_detalle_file;var array_reg:array_detalle_reg;var maestro:maestro_file);
var
	regM:maestro;
	min:detalle;
	activos:integer;
	nuevos:integer;
begin
	assignResetLeer(array_file,array_reg);
	reset(maestro);
	minimo(array_file,array_reg,min);
	read(maestro,regM);
	
	while(min.cod_localidad <> valorAlto)do begin
		
		while(min.cod_localidad <> regM.cod_localidad)do
			read(maestro,regM);
			
		activos:= 0;
		nuevos:= 0;
		
		while(min.cod_localidad = regM.cod_localidad)and(min.cod_cepa = regM.cod_cepa)do begin
			regM.casos_fallecidos:= regM.casos_fallecidos + min.casos_fallecidos;
			regM.casos_recuperados:= regM.casos_recuperados + min.casos_recuperados;
			nuevos:= nuevos + min.casos_nuevos;
			activos:= activos + min.casos_activos;
			minimo(array_file,array_reg,min);
		end;
		
		regM.casos_activos:= activos;
		regM.casos_nuevos:= nuevos;
		
		Seek(maestro,FilePos(maestro)-1);
		write(maestro,regM);
		
	end;
	
	close(maestro);
	cerrarDetalles(array_file);
	
end;

procedure leerMaestro(var archivo:maestro_file;var reg:maestro);
begin
	if not EOF(archivo)then
		read(archivo,reg)
	else
		reg.cod_localidad:= valorAlto;
end;

procedure informe(var mae:maestro_file);
var
	regM:maestro;
	localidad:integer;
	cant_loc:integer;
	cant_casos:integer;
begin
	reset(mae);
	leerMaestro(mae,regM);
	cant_loc:= 0;
	
	while (regM.cod_localidad <> valorAlto)do begin
		
		localidad:= regM.cod_localidad;
		cant_casos:= 0;
		while(localidad = regM.cod_localidad)do begin
			cant_casos:= cant_casos + regM.casos_activos;
			leerMaestro(mae,regM);
		end;
		
		if(cant_casos > 50)then
			cant_loc:= cant_loc + 1;
		
	end;
	
	close(mae);
	
	writeln('La cantidad de localidades con mas de 50 casos activos son',cant_loc);
	
end;
var 
	array_file:array_detalle_file;
	array_reg:array_detalle_reg;
	mae:maestro_file;
BEGIN

	assign(mae,'maestro.dat');
	actualizarMaestro(array_file,array_reg,mae);
	informe(mae);
END.

