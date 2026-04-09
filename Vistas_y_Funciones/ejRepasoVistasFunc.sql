/*1*/
delimiter//
create function compraRetorno( idCompra int) returns text deterministic
begin 
declare retorno text default "no esta pago";
select sum(p.monto) from pago p
where p.compra_id = c.idCompra
group by compra_id;

if(c.precio = p.monto) then
set retorno ="esta pago";
end if;

return retorno
end //
delimiter;

select compraRetorno( 1,1000,200);

/*2*/
delimiter//
create function empleadoComision(dni int) returns float deterministic
begin 
declare comision float default = 0;
declare totalVendido float;
select sum(c.precio) into totalVendido from compra c
where month(c.fecha) = month(curdate()) 
group by c.empleado_dni;

if(select e.fechaIngreso between year(now()) - interval 5 YEAR) then 
set comision = totalVendido * 0,05;
end if;

if(select e.fechaIngreso > year(now()) - interval 5 YEAR and year(now() - interval 10 YEAR) then 
set comision = totalVendido * 0,07;
end if;

if(select e.fechaIngreso between year(now()) - interval 10 YEAR) then 
set comision = totalVendido * 0,10;
end if;

return comision;
end//
delimiter;

select empleadoComision(5);

/*3*/
delimiter//
create function modeloAuto(modelo_id int, mes int) returns int deterministic
begin
declare cant int default 0;
select count(patente) into cant from auto a
join compra c on a.patente = c.auto_patente
where month(c.fecha) = mes
group by modelo_id;

return cant 
end//
delimiter;

select modeloAuto(2, 9)

/*1*/
create view resumenVista as select d.dni, d.email ,c.fecha a.patente, m.marca, a.color, compraRetorno(5)
join cliente cl on c.cliente_dni = cl.dni
join modelo m on a.modelo_id = m.id
join auto a on c.auto_patente = a.patente
group by c.id;

/*2*/
 

