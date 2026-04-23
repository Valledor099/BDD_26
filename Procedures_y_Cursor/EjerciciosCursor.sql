/*9*/
delimiter //
CREATE PROCEDURE getCiudadesOffices(out lista VARCHAR(4000))
BEGIN
	declare hayFilas boolean;
    declare ciudadObtenida VARCHAR(45) default "";
    declare officesCursor cursor for select o.city from offices o;
    declare continue handler for not found set hayFilas = 0;
    set lista = "";
    
    open officesCursor;
    officesLoop:loop
		fetch officesCursor into ciudadObtenida;
        if hayFilas = 0 then
			leave officesLoop;
		end if;
        set lista = concat(ciudadObtenida, ", ", lista);
	end loop officesLoop;
	close officesCursor;
end //
delimiter ;

CALL getCiudadesOffices(@lista);
SELECT @lista;

/*10*/

delimiter // 
CREATE PROCEDURE insertCancelled(out cant int)
BEGIN
	declare hayFilas boolean;
    declare ordenCancelada varchar(45) default "";
    declare ordersCursor cursor for select ord.status from orders ord;
	declare continue handler for not found set hayFilas = 0;
    set cant = 0;
    open ordersCursor;
    ordersLoop:loop
		fetch ordersCursor into ordenCancelada;
        if hayFilas = 0 then
			leave ordersLoop;
		end if;
        if(ordenCancelada = "Cancelled") then
        set cant = cant + 1;
        end if;
        end loop ordersLoop;
        close ordersCursor;
end//
delimiter ;

call insertCancelled(@cant);
select @cant;

/*11*/
delimiter //
CREATE PROCEDURE alterCommentOrder(in idCl int)
BEGIN
	declare hayFilas boolean;
    declare completarCommentario text default "";
    declare totalOrden int;
    declare ordenCursor cursor for select ord.comments from orders ord;
    declare continue handler for not found set hayFilas = 0;
    
    SELECT sum(ordd.quantityOrdered * ordd.priceEach) into totalOrden from orderdetails ordd
    JOIN orders ord ON ord.orderNumber = ordd.orderNumber
    WHERE ord.customerNumber = idCl;
    
    open ordenCursor;
    ordenLoop:loop
		fetch ordenCursor into completarCommentario;
			if hayFilas = 0 then
				leave ordenLoop;
			end if;
            if completarCommentario is NULL then
				Update orders
					SET comments = concat("El total de la orden es", totalOrden)
					WHERE customerNumber = idCl;
			end if;
            end loop ordenLoop;
            close ordenCursor;
end // 
delimiter ;

drop procedure alterCommentOrder;
call alterCommentOrder(101);
 
 /*13*/
 
delimiter //
CREATE FUNCTION venta (idE int) returns float deterministic
begin
	declare totalVenta float default 0;
    
	SELECT sum(ordd.quantityOrdered * ordd.priceEach) into totalVenta from orderdetails ordd
    JOIN orders ord ON ord.orderNumber = ordd.orderNumber
    JOIN customers c ON c.customerNumber = ord.customerNumber
    JOIN employees e ON e.employeeNumber = c.salesRepEmployeeNumber
    Where e.employeeNumber = idE; 
	
    return totalVenta;
end //
delimiter ;
drop function venta;

alter table employes
add column comision int not null default 0;


delimiter //
CREATE procedure actualizarComision()
begin
	declare hayFilas boolean;
	declare totalVenta float;
    declare agregarComision int default 0;
    declare numeroEmpleado int;
    declare employeeCursor cursor for select employeeNumber from employees;
    declare continue handler for not found set hayFilas = 0;
    
    
    open employeeCursor;
    employeeLoop:loop
		fetch employeeCursor into numeroEmpleado;
			if hayFilas = 0 then
				leave employeeLoop;
			end if;
            
            if(venta(numeroEmpleado) > 100000) then
            set agregarComision = venta(numeroEmpleado) * 0.05;
            
            else if (venta(numeroEmpleado) < 100000 and venta(numeroEmpleado) > 50000) then
            set agregarComision = venta(numeroEmpleado) * 0.03;
				end if;
				end if;
                
			update employees
			set comision = agregarComision
			where employeeNumber = numeroEmpleado;
            
            end loop employeeLoop;
            close employeeCursor;
end //
delimiter ;
drop procedure actualizarComision;
call actualizarComision();

/*Ej agregado*/

Create table if not exists reporte_ventas 
(
	numeroOrden int,
    nombreCliente varchar(45),
    pais varchar(45),
    totalGastado float,
    cantItems int,
    estado varchar(45),
    diasParaEntrega int
);


delimiter //
CREATE procedure insertReporteVentas()
begin 
	declare hayFilas boolean;
	declare totalVenta float;
    declare numOrden int;
    declare nomCliente varchar(45);
    declare paises varchar(45);
    declare totalGast float;
    declare cantidadItems int;
    declare est varchar(45);
    declare diasEntrega int;
    declare employeeCursor cursor for select * from orders;
    declare continue handler for not found set hayFilas = 0;
    open employeeCursor;
    employeeLoop:Loop
    fetch employeeCursor into numOrden, nomCliente, paises, totalGast, cantidadItems, est, diasEntrega;
    if hayFilas = 0 then
				leave employeeLoop;
			end if;
	insert into reporte_ventas(NumeroOrden, nombreCliente, pais, totalGastado, cantItems, estado, diasParaEntrega)
    SELECT 
    n,
    CONCAT('Cliente_', n),
    ELT((n % 5)+1, 'Argentina','Brasil','Chile','Uruguay','Peru'),
    n * 1000,
    (n % 10) + 1,
    ELT((n % 3)+1, 'Pendiente','Enviado','Entregado'),
    (n % 20) + 1
FROM (
    SELECT @row := @row + 1 AS n
    FROM information_schema.tables, (SELECT @row := 0) r
    LIMIT 10000
) t;
end loop employeeLoop;
close employeeCursor;
end//
delimiter ;

call insertReporteVentas();






    
        

    