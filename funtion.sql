--1
CREATE OR REPLACE FUNCTION compra2(_id_user text, productos integer[], arrcant integer[])
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare

    _cantidad_compras integer;
    _cantidad_filas integer;
   _valor_compra integer;
	_precio integer;
	id integer;
	_fecha timestamp;
BEGIN
    select now() into _fecha;
    _cantidad_compras := 0;
    _cantidad_filas := array_length(productos,1);
   _valor_compra := 0;
    if(_cantidad_filas > 0)then
        for i in 1.._cantidad_filas loop
            --precio := _cantidad_compras := _cantidad_compras + 1;
        	select precio into _precio from producto p where p.id_producto = productos[i] ;
        	--select * from producto where id_producto = productos[i] returning precio into _precio;
        	_valor_compra := _valor_compra + _precio * arrcant[i];
        end loop;
    end if;
   
   insert into compra (total_compra) values (_valor_compra) returning id_compra into id;
   insert into realiza (rut,id_compra,fecha_compra) values (_id_user,id,_fecha);
  
   if (_valor_compra > 0)then
   		for j in 1.._cantidad_filas loop
   			insert into detalle (id_producto,id_compra,cantidad) values (productos[j],id,arrcant[j]);
   		end loop;
   end if;
    return id;
END;
$function$
;

select compra2('305085438-3','{1,2}','{1,2}')
select compra2('136568875-5','{4,2}','{1,1}')

--2
CREATE OR REPLACE FUNCTION monto(_id_compra integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
	_rec RECORD;
    monto integer;
begin
	
	select total_compra into monto from compra where compra.id_compra = _id_compra;
	
	for _rec in select producto.id_producto as prod, detalle.cantidad as cant,
	producto.descuento as des, usuario.registrados_n as register
	from detalle 
	join producto on (producto.id_producto = detalle .id_producto) 
	join realiza  on (realiza.id_compra = detalle .id_compra )
	join usuario  on (usuario.rut = realiza.rut) 
	where detalle.id_compra = _id_compra 
	loop 
	if (_rec.register)then 
		monto = monto - (_rec.des * _rec.cant);
		if (monto < 20000)then 
			monto = monto + monto*0.1;
		end if;
	else
		monto = monto;
	end if;

	
	end loop;
	return monto;
   
END;
$function$

select monto(3)
select monto(4)

select * from compra c 
select * from detalle d 
select * from producto p2 

--3

CREATE OR replace procedure dir(_id_compra integer, dir_envio text)
 LANGUAGE plpgsql
AS $$
declare
	rec RECORD;
	rec1 RECORD;
    monto integer;
   	dire text; 
    dire1 text;
begin
	dire = '';
	dire1 = '';
	for rec in select realiza.rut as rut,usuario.cuidad as city,usuario.comuna as comuna,usuario.calle as calle,usuario.numero as numero 
	from realiza 
	join usuario on realiza.rut = usuario.rut 
	where realiza.id_compra  = _id_compra

		
	loop 
	--obtener la direccion del comprador
		if (dir_envio is null)then
		dire = dire || rec.calle || ',' || rec.numero || ',' || rec.city || ',' || rec.comuna || '..';
		update compra set direccion_envio = dire  where id_compra = _id_compra; 
		else 
		update compra set direccion_envio = dir_envio  where id_compra = _id_compra;
	end if;
	end loop;
	
	for rec1 in select provee.rut as rut , usuario.cuidad as city, usuario.comuna as comuna , usuario.calle as calle,usuario.numero as num
	from provee 
	join usuario on (usuario.rut = provee.rut)
	where id_producto in (
	select detalle.id_producto as id_producto 
	from detalle 
	where detalle.id_compra = 1)
	
	loop
		dire1 = dire1 || rec1.calle || ',' || rec1.num || ',' || rec1.city || ',' ||rec1.comuna || '--';
	end loop;
	update compra set direccion_retiro = dire1 where id_compra = _id_compra;
 
END;
$$


call dir(1,null)
call dir(2,null)

call dir(1,'Ovalle')
select provee.rut as rut , usuario.cuidad as city, usuario.comuna as comuna , usuario.calle as calle,usuario.numero as num
from provee 
join usuario on (usuario.rut = provee.rut)
where id_producto in (
select detalle.id_producto as id_producto 
from detalle 
where detalle.id_compra = 1)

select * from provee p 
select * from usuario u
select * from detalle d 
select * from empresa e 
select * from producto p2 
select * from realiza r 
select direccion_envio from compra c 
select * from compra c2 
select usuario.cuidad as city ,usuario.comuna as comuna,usuario.calle as calle, usuario.numero as  num
	from compra  
	inner join realiza on (realiza.id_compra = 1)
	inner join usuario on (usuario.rut = realiza.rut )
	inner join detalle on (detalle.id_compra = compra.id_compra) 
	inner join provee on (provee.rut = usuario.rut )
	where compra.id_compra = 1
	
	
select realiza.rut as rut,usuario.cuidad as city,usuario.comuna as comuna,usuario.calle as calle,usuario.numero as numero 
from realiza 
join usuario on realiza.rut = usuario.rut 
where realiza.id_compra  = 1

insert into provee (rut, id_producto) values ('278432021-9',3);
insert into provee (rut, id_producto) values ('305085438-3',4);
insert into provee (rut, id_producto) values ('241713940-5',1);
insert into provee (rut, id_producto) values ('905280622-5',5);
insert into provee (rut, id_producto) values ('926517328-9',2);
insert into provee (rut, id_producto) values ('323253216-0',6);
insert into provee (rut, id_producto) values ('648183626-3',7);
insert into provee (rut, id_producto) values ('871686152-3',8);
insert into provee (rut, id_producto) values ('425064965-2',9);
insert into provee (rut, id_producto) values ('599075296-2',10);