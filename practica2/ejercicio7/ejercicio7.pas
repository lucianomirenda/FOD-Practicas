program untitled;

type
	
	covidInfoDetalle = record
		codLocalidad:integer;
		codCepa:integer;
		cantCasos:integer;
		cantRecuperados:integer;
		cantFallecidos:integer;
	end;
	
	covidInfoMaestro = record
		nombreLocalidad:string;
		nombreCepa:string;
		cantNuevos:integer;
		codLocalidad:integer;
		codCepa:integer;
		cantCasos:integer;
		cantRecuperados:integer;
		cantFallecidos:integer;
	end;
	
	fileDetalle = file of covidInfoDetalle;
	maestro = file of covidInfoMaestro;

	arregloDetalles = array [1..10] of fileDetalle;
	arregloInfo = array [1..10] of covidInfoDetalle;
	
procedure leer(var detalle:fileDetalle;info:covidInfoDetalle);
begin
	if(not EOF(detalle))then
		read(detalle,info)
	else
		info.codLocalidad:= 9999;

end;

procedure abrirArchivos(archivos:arregloDetalles;regArreglo:arregloInfo);
var
	i:integer;
begin
	for i:= 1 to 10 do begin
		reset(archivos[i]);
		read(archivos[i],regArreglo[i]);
		
	end;
end;	

	
var 
	arregloArchivosDetalle:arregloDetalles;
	arregloRegDetalle:arregloInfo;
	archivoMaestro:maestro;
	i:integer;
	nombreDetalle:string;
BEGIN
	nombreDetalle:= 'detalle';
	
	assign(arregloArchivosDetalle[1],'detalle1.dat');
	assign(arregloArchivosDetalle[2],'detalle2.dat');
	assign(arregloArchivosDetalle[3],'detalle3.dat');
	assign(arregloArchivosDetalle[4],'detalle4.dat');
	assign(arregloArchivosDetalle[5],'detalle5.dat');
	assign(arregloArchivosDetalle[6],'detalle6.dat');
	assign(arregloArchivosDetalle[7],'detalle7.dat');
	assign(arregloArchivosDetalle[8],'detalle8.dat');
	assign(arregloArchivosDetalle[9],'detalle9.dat');
	assign(arregloArchivosDetalle[10],'detalle10.dat');
	
	abrirArchivos(arregloArchivosDetalle,arregloRegDetalle);
	
	
	
END.

