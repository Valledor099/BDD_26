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
CREATE PROCEDURE insertCancelled


    