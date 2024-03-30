program untitled;
const
	valorAlto = 9999;
type
	regAlumnoMaestro = record	
		codigo:integer;
		nombre:string;
		apellido:string;
		cantMateriasSinFinal:integer;
		cantMateriasConFinal:integer;
	end;
	
	regAlumnoDetalle = record
		codigo:integer;
		aproboFinal:boolean;
		aproboCursada:boolean;
	end;
	
	fileAlumnoMaestro = file of regAlumnoMaestro;
	fileAlumnoDetalle = file of regAlumnoDetalle;

procedure leer	(var archivo:fileAlumnoDetalle;var dato:regAlumnoDetalle);
begin
	if not EOF(archivo)then
		read(archivo,dato)
	else
		dato.codigo:= valorAlto;
end;

procedure actualizarMaestro(var maestro:fileAlumnoMaestro;var detalle:fileAlumnoDetalle);
var
	regD:regAlumnoDetalle;
	regM:regAlumnoMaestro;
begin
	reset(maestro);
	reset(detalle);
	
	leer(detalle,regD);
	
	while(regD.codigo <> valorAlto)do begin
		
		read(maestro,regM);
		
		while(regM.codigo <> regD.codigo)do 
			read(maestro,regM);
			
		while(regM.codigo = regD.codigo)do begin
			
			if(regD.aproboFinal)then begin
				regM.cantMateriasConFinal:= regM.cantMateriasConFinal + 1;
				regM.cantMateriasSinFinal:= regM.cantMateriasSinFinal - 1;
			end 
			else if(regD.aproboCursada)then begin
				regM.cantMateriasSinFinal:= regM.cantMateriasSinFinal + 1;
			end
			
		end;
		
		Seek(maestro,FilePos(maestro)-1);
		write(maestro,regM);
	
	end;
	close(maestro);
	close(detalle);
	

end;	

procedure exportarAlumnosConMasFinales(var fileAlumnos:fileAlumnoMaestro);
var
	textAlumnos:text;
	reg:regAlumnoMaestro;
begin
	Assign(textAlumnos,'textAlumnos.txt');
	reset(fileAlumnos);
	
	while not EOF(fileAlumnos)do begin
		read(fileAlumnos,reg);
		if(reg.cantMateriasConFinal > reg.cantMateriasSinFinal)then begin
			writeln(textAlumnos,reg.codigo,' ',reg.nombre,' ',reg.apellido,' ',reg.cantMateriasConFinal,' ',reg.cantMateriasSinFinal);
		end;
	end;
	
	close(fileAlumnos);
	close(textAlumnos);


end;

var
	maestro:fileAlumnoMaestro;
	detalle:fileAlumnoDetalle;

BEGIN
	
	Assign(maestro,'maestroAlumnos.dat');
	Assign(detalle,'detalleAlumnos.dat');
	
	actualizarMaestro(maestro,detalle);
	exportarAlumnosConMasFinales(maestro);
	
END.

