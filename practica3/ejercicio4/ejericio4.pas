program untitled;
const
	valorAlto = 9999;
type
	florReg = record
		nombre:string[45];
		codigo:integer;
	end;
	
	floresFile = file of florReg;
	

procedure leerFlor(var regF:florReg);
begin

	writeln('Ingrese el codigo');
	readln(regF.codigo);
	if(regF.codigo <> -1)then begin
		writeln('Ingrese el nombre');
		readln(regF.nombre);
	end;
	
end;

procedure leerArchivo(var fileF:floresFile;var regF:florReg);
begin
	
	if not EOF(fileF)then
		read(fileF,regF)
	else
		regF.codigo:= valorAlto;
	
end;
procedure buscarFlor(var fileF:floresFile;codigo:integer;var pos:integer);
var
	regF:florReg;
begin
	reset(fileF);
	leerArchivo(fileF,regF);
	pos:= 0;
	
	while(regF.codigo <> valorAlto)and(regF.codigo <> codigo)do begin 
		leerArchivo(fileF,regF);
		pos:= pos + 1;
	end;
	
	if(regF.codigo <> codigo)then
		pos:= -1;
		
	close(fileF);
	
end;
procedure agregarFlor(var fileF:floresFile;nombre:string;codigo:integer);
var
	cabecera,nuevaFlor:florReg;
	pos:integer;
begin
	reset(fileF);
	
	nuevaFlor.nombre:= nombre;
	nuevaFlor.codigo:= codigo;
	
	leerArchivo(fileF,cabecera);
	
	if(cabecera.codigo <> valorAlto)and(cabecera.codigo <> 0)then begin
	
		pos:= cabecera.codigo * -1; //obtengo la posicion
		
		seek(fileF,pos); //me posiciono
		
		read(fileF,cabecera); //me traigo la antigua cabecera
		
		seek(fileF,pos); //me posiciono
		
		write(fileF,nuevaFlor); //sobre escribo la antigua cabecera con mi nueva flor
		
		seek(fileF,0); //me posiciono en la cabecera
		
		write(fileF,cabecera); //sobre escribo mi cabecera con la antigua cabecera
	
	
	end else begin
		
		seek(fileF,fileSize(fileF));
		write(fileF,nuevaFlor);
		
	end;
	
	close(fileF);
	
end;

procedure eliminarFlor(var fileF:floresFile);
var
	cabecera,nuevaCabecera:florReg;
	pos,codigo:integer;
begin
	
	writeln('Ingrese el codigo de la flor que quiere eliminar');
	readln(codigo);
	
	buscarFlor(fileF,codigo,pos);
	
	reset(fileF);
	
	if(pos <> -1)then begin
		
		read(fileF,cabecera); //leo la antigua cabecera
		
		//creo la nueva cabecera y la guardo
		nuevaCabecera:= cabecera;
		nuevaCabecera.codigo:= pos * -1;
		seek(fileF,0);
		write(fileF,nuevaCabecera);
		
		//sobre escribo en la posicion que quiero eliminar
		seek(fileF,pos);
		write(fileF,cabecera);
	
		writeln('La flor se elimino correctamente');
		
	end else begin
	
		writeln('No existe una flor con ese codigo');
	end;
	
	close(fileF);
	
end;

procedure enlistarFlores(var fileF:floresFile);
var
	flor:florReg;
begin
	reset(fileF);
	
	leerArchivo(fileF,flor);
	
	while(flor.codigo <> valorAlto)do begin
	
		if(flor.codigo > 0)then begin
			writeln('------');
			writeln('nombre: ',flor.nombre);
			writeln('codigo: ',flor.codigo);
		end;
		
		leerArchivo(fileF,flor);
	
	end;
	
	writeln('------');
	
	close(fileF);
	
	
end;

procedure opciones;
begin
	writeln('1. Para agregar una flor');
	writeln('2. Para eliminar un flor');
	writeln('3. Para enlista las flores');
	writeln('4. crear archivo');
	writeln('0. Para salir');
end;

procedure opcion1(var fileF:floresFile);
var
	nombre:string;
	codigo:integer;
begin
	writeln('ingrese un nombre');
	readln(nombre);
	writeln('ingrese una codigo');
	readln(codigo);
	agregarFlor(fileF,nombre,codigo);

end;
procedure crearArchivo(var fileF:floresFile);
var
	flor:florReg;
begin
	rewrite(fileF);
	flor.nombre:= '';
	flor.codigo:= 0;
	seek(fileF,0);
	write(fileF,flor);
	close(fileF);
	
end;	

procedure menu(var fileF:floresFile);
var
	opcion:integer;
begin
	opciones;
	readln(opcion);
	while(opcion <> 0)do begin
	
		case opcion of
			1: opcion1(fileF); 
			2: eliminarFlor(fileF);
			3: enlistarFlores(fileF);
			4: crearArchivo(fileF);
		else 
			writeln('Opcion incorrecta');
		end;
		
		opciones;
		readln(opcion);
	end;
	
	writeln('adios');

end;



var 
	fileF:floresFile;
	nombre:string;
BEGIN
	writeln('Ingrese un nombre para el archivo de flores');
	readln(nombre);
	
	assign(fileF,nombre);
	
	menu(fileF);
	
END.

