program untitled;
const 
	valorAlto = 9999;
type
	novelaReg = record
		codigo,duracion:integer;
		genero,nombre,director:string;
		precio:real;
	end;
	
	novelaFile = file of novelaReg;

procedure leerNovela(var reg:novelaReg);
begin
	writeln('ingrese el código');
	readln(reg.codigo);
	if(reg.codigo <> -1)then begin
		writeln('ingrese la duracion');
		readln(reg.duracion);
		writeln('ingrese el nombre');
		readln(reg.nombre);
		writeln('ingrese el director');
		readln(reg.director);
		writeln('ingrese el genero');
		readln(reg.genero);
		writeln('ingrese el precio');
		readln(reg.precio);
	end;
end;

procedure cargarArchivo(var archivo:novelaFile);
var
	reg:novelaReg;
begin

	rewrite(archivo);
	reg.codigo:= 0;
	reg.duracion:= 0;
	reg.nombre:= ' ';
	reg.director:= ' ';
	reg.genero:= ' ';
	reg.precio:= 0.0;
	write(archivo,reg);
	
	writeln('Ingrese una novela. Para terminar el codigo -1');
	
	leerNovela(reg);
	
	while(reg.codigo <> -1)do begin	
		write(archivo,reg);
		writeln('Ingrese una novela. Para terminar el codigo -1');
		leerNovela(reg);
	end;
	
	close(archivo);
	
end;

procedure leerArchivo(var archivo:novelaFile;var reg:novelaReg);
begin
	if not EOF(archivo)then
		read(archivo,reg)
	else
		reg.codigo:= valorAlto;
end;

procedure ingresarUnaNovela(var archivo:novelaFile);
var
	cabecera,reg:novelaReg;
	pos:integer;
begin
	reset(archivo);
	leerNovela(reg);
	
	leerArchivo(archivo,cabecera);
	
	if(cabecera.codigo < 0)then begin
		//obtengo la posición del registro eliminado
		pos:= cabecera.codigo * -1;
		//posiciono el archivo
		seek(archivo,pos);
		//leo el archivo en tal posición
		leerArchivo(archivo,cabecera);
		//me vuelvo a posicionar
		seek(archivo,pos);
		//escribo el nuevo registro
		write(archivo,reg);
		//voy a la cabecera
		seek(archivo,0);
		//escribo la nueva cabecera
		write(archivo,cabecera);

	end else begin
	
		Seek(archivo,fileSize(archivo));
		write(archivo,reg);
	
	end;
	
	close(archivo);

end;

procedure buscarNovela(var archivo:novelaFile;cod:integer;var pos:integer);
var
	reg:novelaReg;
begin
	pos:= 0;
	reset(archivo);
	leerArchivo(archivo,reg);
	while(reg.codigo <> valorAlto)and(reg.codigo <> cod)do begin
		leerArchivo(archivo,reg);
		pos:= pos + 1;
	end;
	
	if(reg.codigo <> cod)then
		pos:= -1;
		
end;

procedure modificarNovela(var archivo:novelaFile);
var
	nuevaNovela:novelaReg;
	codigo:integer;
	pos:integer;
begin

	writeln('Ingrese el código de la novela que quiere modificar: ');
	readln(codigo);
	
	buscarNovela(archivo,codigo,pos);
	leerNovela(nuevaNovela);
	
	if(pos <> -1)then begin
		seek(archivo,pos);
		write(archivo,nuevaNovela);
		writeln('Se ha modificado la novela');
	end else
		writeln('No se encontro la novela');
	
end;

procedure eliminarNovela(var archivo:novelaFile);
var
	cabecera,nuevaCabecera:novelaReg;
	pos,codigo:integer;
begin
	writeln('Ingrese el código de la novela que desea eliminar');
	readln(codigo);
	buscarNovela(archivo,codigo,pos);
	if(pos <> -1)then begin
		seek(archivo,0);
		read(archivo,cabecera);
		seek(archivo,0);
		nuevaCabecera:= cabecera;
		nuevaCabecera.codigo:= pos * -1;
		write(archivo,nuevaCabecera);
		seek(archivo,pos);
		write(archivo,cabecera);
		
		writeln('Se ha eliminado la novela');
	end else 
		writeln('No se encontro la novela');
	
	close(archivo);

end;


procedure exportarNovelasTexto(var archivo:novelaFile);
var
	novelasTexto:text;
	nombre:string;
	reg:novelaReg;
begin
	writeln('Ingrese el nombre del archivo de texto: ');
	readln(nombre);
	assign(novelasTexto,nombre);
	rewrite(novelasTexto);	
	reset(archivo);
	leerArchivo(archivo,reg);
	
	while(reg.codigo <> valorAlto)do begin
		
		writeln(novelasTexto,reg.codigo,' ',reg.genero,' ',reg.nombre,' ',reg.director,' ',reg.duracion,' ',reg.precio:3:2);
		leerArchivo(archivo,reg);
		
	end;
	
	close(archivo);
	close(novelasTexto);
	
end;

procedure mensajeMenu;
begin
	writeln('Ingrese una opción: ');
	writeln('"1" para cargar el archivo');
	writeln('"2" para ingresar una nueva novela');
	writeln('"3" para modificar una novela');
	writeln('"4" para eliminar una novela');
	writeln('"5" para exportar un archivo de texto con las novelas actuales');
	writeln('"0" para salir');
end;

procedure menu(var archivo:novelaFile);
var
	nombre:string;
	opcion:integer;
begin
	writeln('Ingrese el nombre del archivo novelas');
	readln(nombre);
	assign(archivo,nombre);
	
	repeat
		mensajeMenu();
		readln(opcion);
		case opcion of
			1: cargarArchivo(archivo);
			2: ingresarUnaNovela(archivo);
			3: modificarNovela(archivo);
			4: eliminarNovela(archivo);
			5: exportarNovelasTexto(archivo);
		else 
			writeln('opcion incorrecta');
		end;
	
	until(opcion = 0);
	
	writeln('Fin del programa');

end;
var 
	archivo:novelaFile;

BEGIN
	
	menu(archivo);
	
END.

