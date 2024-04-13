program untitled;
Uses sysutils;
const
	valorAlto = 9999;
	df = 5;
type
	
	detalle = record
		codigo:integer;
		fecha:integer;
		tiempo:integer;
	end;
	
	maestro = record
		codigo:integer;
		fecha:integer;
		tiempoTotal:integer;
	end;
	
	detalleFile = file of detalle;
	maestroFile = file of maestro;
	
	arrayDetalleFile = array[1 .. df] of detalleFile;
	arrayDetalleReg = array[1 .. df] of detalle;

procedure leer(var archivo:detalleFile;var reg:detalle);
begin
	if not EOF(archivo)then
		read(archivo,reg)
	else
		reg.codigo:= valorAlto;
end;
procedure enlazarDetalles(var detalles:arrayDetalleFile);
var
	i:integer;
begin
	for i:=1 to df do 
		assign(detalles[i],'detalle'+IntToStr(i)+'.dat');
end;
procedure abrirDetalles(var detalles:arrayDetalleFile);
var
	i:integer;
begin
	for i:=1 to df do 
		reset(detalles[i]);
end;
procedure leerDetalles(var detallesFile:arrayDetalleFile;var detallesReg:arrayDetalleReg);
var
	i:integer;
begin
	for i:=1 to df do
		leer(detallesFile[i],detallesReg[i]);
end;
procedure minimo(var detFile:arrayDetalleFile;var detReg:arrayDetalleReg;var min:detalle);
var
	i,pos:integer;
begin
	min.codigo:= 9999;
	min.fecha:= 9999;
	
	for i:= 1 to df do 
		if(detReg[i].codigo < min.codigo)or((detReg[i].codigo = min.codigo)and( detReg[i].fecha < min.fecha))then begin
			min:= detReg[i];
			pos:= i;
		end;
		
	leer(detFile[pos],detReg[pos]);
	
end;
procedure cerrarDetalles(var detallesFile:arrayDetalleFile);
var
	i:integer;
begin
	for i:=1 to df do 
		close(detallesFile[i]);
end;

procedure crearMaestro(var detallesFile:arrayDetalleFile;var detallesReg:arrayDetalleReg;var maestro:maestroFile);
var
	min:detalle;
	regM:maestro;
begin
	Assign(maestro,'/var/log');
	enlazarDetalles(detallesFile);
	abrirDetalles(detallesFile);
	leerDetalles(detallesFile,detallesReg);
	rewrite(maestro);
	minimo(detallesFile,detallesReg,min);
	
	while(min.codigo <> valorAlto)do begin
		
		regM.codigo:= min.codigo;
		regM.fecha:= min.fecha;
		regM.tiempoTotal:= 0;
		
		while(min.codigo = regM.codigo)and(min.fecha = regM.fecha)do begin
			regM.tiempoTotal:= regM.tiempoTotal + min.tiempo;
			minimo(detallesFile,detallesReg,min);
		end;
		
		write(maestro,regM);
	
	end;
	
	close(maestro);
	cerrarDetalles(detallesFile);

end;
var 
	detallesFile:arrayDetalleFile;
	detallesReg:arrayDetalleReg;
	mae:maestroFile;
BEGIN

	crearMaestro(detallesFile,detallesReg,mae);
	
END.

