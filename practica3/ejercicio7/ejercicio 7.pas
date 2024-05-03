program untitled;
const
	valorAlto = 'zzzz';
type
	avesReg = record
		codigo:integer;
		especie,familia,desc,zona:string;
	end;
	
	avesFile = file of avesReg;
	
	avesBajas = file of string;
	
procedure leerReg(var ave:avesReg);
begin
	writeln('Ingrese el codigo');
	readln(ave.codigo);

	if(ave.codigo <> -1)then begin
		writeln('Ingrese la especie');
		readln(ave.especie);
		ave.familia:= '';
		ave.desc:= '';
		ave.zona:= '';
	end;
	
end;	

procedure agregarAve(var avesF:avesFile);
var
	reg:avesReg;
begin
	
	reset(avesF);
	leerReg(reg);
	seek(avesF,fileSize(avesF));
	
	while(reg.codigo <> -1)do begin
		write(avesF,reg);
		writeln('Ingrese -1 para salir');
		leerReg(reg);
	end;
		
	close(avesF);
	
end;

procedure crearBajasFile(var bajas:avesBajas);
var
	especie:string;
begin
	assign(bajas,'bajas.dat');
	rewrite(bajas);
	
	writeln('Ingrese la especie que quiere dar de baja');
	readln(especie);
	while(especie <> 'zzzz')do begin
		write(bajas,especie);
		writeln('Ingrese la especie que quiere dar de baja o zzzz para salir');
		readln(especie);
	end;
	
	close(bajas);
end;

procedure leerBaja(var bajas:avesBajas;var especie:string);
begin
	if not EOF(bajas)then 
		read(bajas,especie)
	else
		especie:= 'zzzz';
		
end;	

procedure leerAve(var aves:avesFile;var ave:avesReg);
begin
	if not EOF(aves)then
		read(aves,ave)
	else begin
		ave.codigo:= 5000;
		ave.especie:= 'zzzz';
	end;
end;

procedure bajaLogica(var avesF:avesFile;var bajas:avesBajas);
var
	ave:avesReg;
	especie:string;
begin
	
	reset(avesF);
	reset(bajas);
	
	leerBaja(bajas,especie);
	
	
	writeln('2');
	while(especie <> 'zzzz')do begin
		
		leerAve(avesF,ave);
		while(ave.codigo <> 5000)do begin
		
			while(ave.especie <> especie)do //deberia pensar que podria no encontrar la especie??
				leerAve(avesF,ave);
		
			while(ave.especie = especie)do begin
				ave.codigo:= ave.codigo * -1;
				seek(avesF,filePos(avesF)-1);
				write(avesF,ave);
				leerAve(avesF,ave);
			end;			
		
		end;
		writeln('2');
		seek(avesF,0);
		leerBaja(bajas,especie);
	
	end;
	
	writeln('2');
	
	close(avesF);
	close(bajas);
	
end;

procedure bajaFisica(var avesF:avesFile;nombreMaestro:string;var nuevoAvesF:avesFile);
var
	cant,i,pos:integer;
	ave:avesReg;
begin

	reset(avesF);
	cant:= 0;	
	leerAve(avesF,ave);
	
	while(ave.codigo <> 5000)do begin
		
		if(ave.codigo < 0)then begin
			pos:= filePos(avesF)-1;
			cant:= cant + 1; //suma una baja
			seek(avesF,fileSize(avesF)-cant); 
			read(avesF,ave); 
			seek(avesF,pos);
			write(avesF,ave);
		end;
		
		leerAve(avesF,ave);
		
	end;
	
	reset(avesF);
	assign(nuevoAvesF,'nuevo.dat');
	rewrite(nuevoAvesF);
	writeln('7');
	
	for i:= 1 to fileSize(avesF)-cant do begin
		read(avesF,ave);
		write(nuevoAvesF,ave);
	end;
	
	writeln('8');
	
	close(avesF);
	close(nuevoAvesF);
	
	
	writeln('9');
end;

procedure bajaFisica2(var avesF:avesFile;nombreMaestro:string);
var
	baja:boolean;
	nuevoAvesF:avesFile;
	pos,size,i:integer;
	ave:avesReg;
begin
	reset(avesF);
	
	size:= fileSize(avesF);
	
	for i:= 1 to fileSize(avesF) do begin //es necesario hacer el procedimiento con el supuesto tamaño del archivo
		
		pos:= 0;
		baja:= false;	
		while(pos < size)and(not baja)do begin //pregunto solamente dentro del nuevo tamaño del archivo
			
			leerAve(avesF,ave);
			
			if(ave.codigo < 0)then begin
				size:= size - 1;  //reduzco el tamaño del archivo
				seek(avesF,size); //me posiciono en el ultimo registro
				read(avesF,ave); // leo el ultimo registro
				seek(avesF,pos); //me posiciono en el registro a borrar
				write(avesF,ave); //lo sobre escribo con el ultimo registro
				
				baja:= true;
			end;
			
			pos:= pos + 1;
			
		end;
	
	end;

	reset(avesF);
	
	rewrite(nuevoAvesF);
	for i:= 0 to size do begin
		read(avesF,ave);
		write(nuevoAvesF,ave);
	end;
	
	assign(nuevoAvesF,nombreMaestro);
	close(nuevoAvesF);
end;

procedure listarAves(var avesF:avesFile);
var
	aves:avesReg;
begin
	reset(avesF);
	leerAve(avesF,aves);
	
	while(aves.codigo <> 5000)do begin
		writeln('-----');
		writeln('codigo: ',aves.codigo);
		writeln('especie: ',aves.especie); 
		leerAve(avesF,aves);
	end;
	
	writeln('-----');
	
	
end;

procedure opciones;
begin

	writeln('1. Crear el archivo');
	writeln('2. Agregar ave');
	writeln('3. Crear archivo de especies a dar de baja');
	writeln('4. Efectuar la baja logica');
	writeln('5. Efectuar la baja fisica');
	writeln('6. listar aves');
	writeln('7. listar aves nuevo ');
	writeln('0. salir');

end;
procedure crearArchivo(var avesF:avesFile);
begin
	rewrite(avesF);
	close(avesF);
end;

procedure menu(var avesF:avesFile;nombreMaestro:string);
var
	opcion:integer;
	bajas:avesBajas;
	avesNuevo:avesFile;
begin

	opciones;
	writeln('Ingrese una opcion');
	readln(opcion);
	
	while(opcion <> 0) do begin
	
		case opcion of 
			1: crearArchivo(avesF);
			2: agregarAve(avesF);
			3: crearBajasFile(bajas);
			4: bajaLogica(avesF,bajas);
			5: bajaFisica(avesF,nombreMaestro,avesNuevo);
			6: listarAves(avesF);
			7: listarAves(avesNuevo);
		end;
		opciones;
		writeln('Ingrese una opcion');
		readln(opcion);
	end;
	writeln('adios');
	close(avesF);
	
	
end;


var 
	nombreMaestro:string;
	avesF:avesFile;
BEGIN
	
	writeln('Ingrese el nombre del archivo de aves: ');
	readln(nombreMaestro);
	
	assign(avesF,nombreMaestro);
	
	menu(avesF,nombreMaestro);

END.

