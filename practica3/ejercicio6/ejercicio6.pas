program untitled;
const
	valorAlto = 9999;
type

	prendasReg = record
		codigo,stock:integer;
		desc,colores,tipo:string;
		precio:real;
	end;
	
	prendasFile = file of prendasReg;
	
	bajasFile = file of integer;

procedure leerPrendas(var prendasF:prendasFile;var reg:prendasReg);
begin
	if not EOF(prendasF)then
		read(prendasF,reg)
	else
		reg.codigo:= valorAlto;
end;

procedure leerBajas(var bajasF:bajasFile;var codigo:integer);
begin
	if not EOF(bajasF)then
		read(bajasF,codigo)
	else
		codigo:= valorAlto;
end;

procedure bajarPrendas(var prendasF:prendasFile;var bajasF:bajasFile);
var
	codBaja:integer;
	prenda:prendasReg;
begin
	
	reset(prendasF);
	reset(bajasF);
	
	leerBajas(bajasF,codBaja);
	
	while(codBaja <> valorAlto)do begin
		
		leerPrendas(prendasF,prenda);
		
		while(codBaja <> prenda.codigo)do   //deberia pensar en que puede no encontrar el codigo?
			leerPrendas(prendasF,prenda);
			
		prenda.stock:= prenda.stock * -1;
		
		seek(prendasF,FilePos(prendasF)-1);
		
		write(prendasF,prenda);
		
		seek(prendasF,0);
		
		leerBajas(bajasF,codBaja);
	
	end;
	
	close(bajasF);
	close(prendasF);

end;

procedure nuevoMaestro(var prendaF:prendasFile;var nuevoPrendaF:prendasFile;var nombreMaestro:string);
var
	prenda:prendasReg;
begin
	reset(prendaF);
	
	assign(nuevoPrendaF,'nuevo.dat');
	rewrite(nuevoPrendaF);

	leerPrendas(prendaF,prenda);
	
	while(prenda.codigo <> valorAlto)do begin
		
		if(prenda.stock > 0)then
			write(nuevoPrendaF,prenda);
		
		leerPrendas(prendaF,prenda);
	
	end;
	
	close(prendaF);
	close(nuevoPrendaF);
	
	rename(nuevoPrendaF,nombreMaestro);

end;

var
	prendasF:prendasFile;
	bajasF:bajasFile;
	nuevoPrendasF:prendasFile;
	nombreMaestro:string;
BEGIN
	
	nombreMaestro:= 'prendas.dat';
	
	assign(prendasF,nombreMaestro);
	
	bajarPrendas(prendasF,bajasF);
	
	nuevoMaestro(prendasF,nuevoPrendasF,nombreMaestro);
	
	
END.

