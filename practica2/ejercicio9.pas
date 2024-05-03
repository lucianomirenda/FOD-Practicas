program untitled;
const
	valorAlto = 9999;
type
	regVotos = record
		cod_prov,cod_loc,num_mesa,cant_votos:integer;
	end;
	
	votosFile = file of regVotos;


procedure leer(var archivo:votosFile;var reg:regVotos);
begin
	if not EOF(archivo)then
		read(archivo,reg)
	else
		reg.cod_prov:= valorAlto;
end;

procedure informar(var archivo_votos:votosFIle);
var
	regV:regVotos;
	prov_act,loc_act,cant_loc,cant_prov,cant_total:integer;
begin
	Assign(archivo_votos,'votos.dat');
	reset(archivo_votos);
	leer(archivo_votos,regV);
	
	cant_total:= 0;
	
	while(regV.cod_prov <> valorAlto)do begin
	
		prov_act:= regV.cod_prov;
		cant_prov:= 0;
		
		writeln('Codigo de provincia: ',prov_act);
		
		while(prov_act = regV.cod_prov)do 
			
			loc_act:= regV.cod_loc;
			cant_loc:= 0;
			
			writeln('Codigo de localidad: ',loc_act);
				
			while(prov_act = regV.cod_prov)and(loc_act = regV.cod_loc)do begin
				cant_loc:= cant_loc + regV.cant_votos;
				leer(archivo_votos,regV);
			end;
			
			cant_prov:= cant_prov + cant_loc;
			
			writeln('Cantidad de votos: ',cant_loc);
		
		end;
			
		writeln('Total votos provincia: ',cant_prov);
		
		cant_total:= cant_total + cant_prov;
	end;
	
	writeln('La cantidad total de votos es: ',cant_total);	
	
	close(archivo_votos);
	
	
end;


var
	archivo:votosFile;
BEGIN
	informar(archivo);
	
END.

