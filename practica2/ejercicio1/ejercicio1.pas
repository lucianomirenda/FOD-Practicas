
program untitled;
const
	valorAlto = 9999;
type
	
	empleado = record
		codigo:integer;
		nombre:string;
		monto:real;
	end;
	
	empleadosFile = file of empleado;

procedure leer(var archivo:empleadosFile;var emp:empleado);
begin
	if(not(EOF(archivo)))then
		read(archivo,emp);
	else
		emp.codigo:= valorAlto;
end;

procedure compactarArchivo(var empFile:empleadosFile);
var
	empleadosFileMaestro:empleadosFile;
	emp,empActual:empleado;
	suma:real;
begin
	reset(empFile);
	rewrite(empleadosFileMaestro);
	
	leer(empFile,emp);
	while (emp.codigo <> 9999)do begin
		suma:= 0;
		empActual:= emp;
		while (empActual.codigo = emp.codigo)do begin
			suma:= suma + emp.monto;
			leer(empFile,emp);
		end;
		empActual.monto:= suma;
		write(empleadosFileMaestro,empActual);
		
	end;

end;
	
var
	empleadosFileLogico:empleadosFile;
 
BEGIN
	assign(empleadosFileLogico,'empleadosFile.dat');
	
	compactarArchivo(empleadosFileLogico);
	
	
END.

