program untitled;
const
	valorAlto = 'zzzz';
type
	regAlfabetosMaestro = record
		provincia:string;
		cantAlfabetos:integer;
		totalEncuestados:integer;
	end;
	
	regAlfabetosDetalle = record
		provincia:string;
		codigoLocalidad:integer;
		cantAlfabetos:integer;
		cantEncuestados:integer;
	end;
	
	fileAlfabetosMaestro = file of regAlfabetosMaestro;
	fileAlfabetosDetalle = file of regAlfabetosDetalle;
	
procedure leer(var detalle:fileAlfabetosDetalle;var reg:regAlfabetosDetalle);
begin
	if NOT EOF(detalle)then
		read(detalle,reg)
	else
		reg.provincia:= 'zzzz';
	
end;

procedure minDetalle(var regD1,regD2, min:regAlfabetosDetalle;var det1,det2:fileAlfabetosDetalle);
begin
	if(regD1.provincia < regD2.provincia)then begin
		min:= regD1;
		leer(det1,regD1);
	end else begin
		min:= regD2;
		leer(det2,regD2);
	end;
end;
	
procedure actualizarMaestro(var detalle1,detalle2:fileAlfabetosDetalle;var maestro:fileAlfabetosMaestro);
var
	regD1,regD2,minD:regAlfabetosDetalle;
	regM:regAlfabetosMaestro;
begin
	reset(detalle1);
	reset(detalle2);
	reset(maestro);


	leer(detalle1,regD1);
	leer(detalle2,regD2);
	read(maestro,regM);
	
	minDetalle(regD1,regD2,minD,detalle1,detalle2);
	
	while(minD.provincia <> valorAlto)do begin
		
		while(minD.provincia <> regM.provincia)do begin
			read(maestro,regM);
		end;
		
		while(minD.provincia = regM.provincia)do begin
			regM.cantAlfabetos:= regM.cantAlfabetos + minD.cantAlfabetos;
			regM.totalEncuestados:= regM.totalEncuestados + minD.cantEncuestados;
			
			minDetalle(regD1,regD2,minD,detalle1,detalle2);
		end;
		
		Seek(maestro,FilePos(maestro)-1);
		write(maestro,regM);
		
	end;
	
	close(maestro);
	close(detalle1);
	close(detalle2);
	
end;

var
	alfabetosMaestro:fileAlfabetosMaestro;
	alfabetosDetalle1,alfabetosDetalle2:fileAlfabetosDetalle;
BEGIN
	Assign(alfabetosMaestro,'alfabetosMaestro.dat');
	Assign(alfabetosDetalle1,'alfabetosDetalle1.dat');
	Assign(alfabetosDetalle2,'alfabetosDetalle2.dat');
	
	actualizarMaestro(alfabetosDetalle1,alfabetosDetalle2,alfabetosMaestro);
	
END.

