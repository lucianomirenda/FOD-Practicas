program untitled;
Uses sysutils;
const
	valorAlto = 9999;
type
	regProductosMaestro = record
		codigo:integer;
		nombre:string;
		desc:string;
		stockAct:integer;
		stockMin:integer;
		precio:real;
	end;
	
	regProductosDetalle = record
		codigo:integer;
		cantVendida:integer;
	end;
	
	fileProductosMaestro = file of regProductosMaestro;
	fileProductosDetalle = file of regProductosDetalle;
	
	vectorFileProductosDetalle = array[1 .. 30] of fileProductosDetalle;
	
	vectorRegProductosDetalle = array[1 .. 30] of regProductosDetalle;
	
procedure leer(var detalle:fileProductosDetalle;var regD:regProductosDetalle);
begin
	if not EOF(detalle)then 
		read(detalle,regD)
	else
		regD.codigo:= 9999;
end;

procedure inicializarDetalles(var vecFileDetalles:vectorFileProductosDetalle;var vecRegDetalles:vectorRegProductosDetalle);
var
	i:integer;
begin
	for i:=1 to 30 do 
		leer(vecFileDetalles[i],vecRegDetalles[i]);
end;

procedure resetearDetalles(var vecFileDetalles:vectorFileProductosDetalle);
var
	i:integer;
begin
	for i:= 1 to 30 do begin
		reset(vecFileDetalles[i]);
	end;
end;
procedure minDetalle(var vecRegDetalles:vectorRegProductosDetalle;var vecFileDetalles:vectorFileProductosDetalle;var min:regProductosDetalle);
var
	i,pos:integer;
begin

	min.codigo:= 9999;

	for i:= 1 to 30 do begin
		
		if(vecRegDetalles[i].codigo < min.codigo)then begin
			min:= vecRegDetalles[i];
			pos:= i;
		end;
	end;
	
	leer(vecFileDetalles[pos],vecRegDetalles[pos]);
	
end;

procedure cerrarDetalles(var vecDetalles:vectorFileProductosDetalle);
var
	i:integer;
begin
	for i:= 1 to 30 do begin
		close(vecDetalles[i]);	
	end;
end;


procedure actualizarMaestro(var vectorReg:vectorRegProductosDetalle;var vectorFiles:vectorFileProductosDetalle;var maestro:fileProductosMaestro);
var
	textStockMin:text;
	min:regProductosDetalle;
	regM:regProductosMaestro;
begin
	assign(textStockMin,'textStockMin.dat');
	rewrite(textStockMin);
	
	resetearDetalles(vectorFiles);
	reset(maestro);
	
	inicializarDetalles(vectorFiles,vectorReg);
	read(maestro,regM);
	
	minDetalle(vectorReg,vectorFiles,min);
	
	while(min.codigo <> valorAlto)do begin
		
		while(min.codigo <> regM.codigo)do 
			read(maestro,regM);
		
		while(min.codigo = regM.codigo)do begin
			regM.stockAct:= regM.stockAct - min.cantVendida;
			minDetalle(vectorReg,vectorFiles,min);
		end;
		
		if(regM.stockAct < regM.stockMin)then begin
			writeln(textStockMin,regM.nombre,' ',regM.desc,' ',regM.precio);
		end;
		
		Seek(maestro,FilePos(maestro)-1);
		write(maestro,regM);
		
	end;
	
	cerrarDetalles(vectorFiles);
	close(maestro);
	close(textStockMin);
	
end;

	
var
	vecRegProdDetalles:vectorRegProductosDetalle;
	vecFileProdDetalles:vectorFileProductosDetalle;
	maestro:fileProductosMaestro;
	text:string;
	i:integer;
BEGIN
	Assign(maestro,'maestroProductos.dat');
	
	for i:= 1 to 30 do begin
		text:= IntToStr(i);
		Assign(vecFileProdDetalles[i],'detalle'+text+'.dat');
	end;
	
	actualizarMaestro(vecRegProdDetalles,vecFileProdDetalles,maestro);
	
END.

