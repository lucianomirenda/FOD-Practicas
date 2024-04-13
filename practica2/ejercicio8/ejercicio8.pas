program untitled;
uses sysutils;
const
	valorAlto = 9999;
type
	regCliente = record
		codigo:integer;
		nombre,apellido:string;
	end;
	
	regVenta = record
		cliente:regCliente;
		ano,mes,dia:integer;
		monto:real;
	end;
	
	fileVentas = file of regVenta;

procedure leer(var archivo:fileVentas;var regV:regVenta);
begin
	if not EOF(archivo)then
		read(archivo,regV)
	else
		regV.cliente.codigo:= valorAlto;
end;
procedure informe(var archivo:fileVentas);
var
	codigoAct,mesAct,anoAct:integer;
	regV:regVenta;
	cantMes,cantAno,cantTotal:real
begin

	assign(archivo,'fileVentas.dat');
	reset(archivo);
	leer(archivo,regV);
	
	cantTotal:= 0;
	
	while regV.cliente.codigo <> valorAlto do begin
		
		codigoAct:= regV.cliente.codigo;
		
		writeln('nombre del cliente: ',regV.cliente.nombre);
		writeln('apellido del cliente: ',regV.cliente.apellido);
		
		while(regV.cliente.codigo = codigoAct)do begin
			cantAno:= 0;
			anoAct:= regV.ano;
			while(regV.cliente.codigo = codigoAct)and(regV.ano = anoAct)do begin
				cantMes:= 0;
				mesAct:= regV.mes;
				while(regV.cliente.codigo = codigoAct)and(regV.ano = anoAct)and(regV.mes = mesAct)do begin
					cantTotal:= cantTotal + regV.monto;
					cantMes:= cantMes + regV.monto;
					cantAno:= cantAno + regV.monto;
					
					leer(archivo,regV);
					
				end;
				
				if not (cantMes = 0)then
					writeln('En el mes gasto un monto de ',cantMes);
			
			end;
			
			writeln('En el año el cliente gasto un monto de ',cantAno);
		
		end;
	
	end;
	
	close(arhivo);
	writeln('El monto total de ventas obtenido fue de ', cantTotal);

end;
var
	archivo:fileVentas;
BEGIN
	informe(archivo);
	
END.

