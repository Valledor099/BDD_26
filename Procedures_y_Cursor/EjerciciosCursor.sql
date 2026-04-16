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
            if completarCommentario = NULL then
				Update orders
					SET comments = concat("El total de la orden es", totalOrden)
					WHERE customerNumber = idCl;
			end if;
            end loop ordenLoop;
            close ordenCursor;
end // 
delimiter ;

drop procedure alterCommentOrder;

call alterCommentOrder(121);

    
        

    