use classicmodels;
/*1*/


delimiter // 
CREATE PROCEDURE precioAlto(out cantP int)
BEGIN
	
    SELECT p.productName FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p);
    
    SET cantP = (SELECT count(p.productName) FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p));

END //
delimiter ;

DROP procedure precioAlto;

call precioAlto(@cant);
select @cant;

/*2*/
delimiter //
CREATE PROCEDURE borrarOrden(in orden int, out cant int)
BEGIN
	
    SET cant = (SELECT count(*) FROM orderdetails
    WHERE orden = orderNumber);
    
    if(cant is null) then
    SET cant = 0;
    
    else
    DELETE FROM orderdetails
    WHERE orden = orderNumber;
    
    DELETE FROM orders
    WHERE orden = orderNumber;
	
    end if;	
   

END //
delimiter ;

call borrarOrden(1, @cant);
select @cant;

/*3*/
delimiter //
CREATE PROCEDURE borrarLinea()
BEGIN 

END//
delimiter ;