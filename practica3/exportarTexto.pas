
program untitled;

uses crt;

procedure crearArchivoTexto();
var
	archivo:text;
	nombre:string;
	num:integer;
begin
	assign(archivo,'numero.txt');
	rewrite(archivo);

	readln(nombre);
	readln(num);
	while(num <> -1)do begin
		writeln(archivo,nombre,' ',num);
		
		readln(nombre);
		readln(num);
	
	end;
	
	close(archivo);
	
end;

var 
	i : byte;

BEGIN
	crearArchivoTexto();
	i:= 1;
	i:= 2 + i;
END.

