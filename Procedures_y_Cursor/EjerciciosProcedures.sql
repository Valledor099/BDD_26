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
CREATE PROCEDURE borrarLinea(IN linea TEXT, out respuesta TEXT)
BEGIN 
	
    IF EXISTS(SELECT productLine FROM products WHERE productLine = linea) THEN
    SET respuesta = "La línea de productos no pudo borrarse porque contiene productos asociados.";
	
    ELSE 
    DELETE FROM productlines
    WHERE productiLine = linea;
    SET respuesta = "La linea de productos fue borrada";
    
    END IF;
    
END//
delimiter ;

CALL borrarLinea("Classic Cars", @respuesta);
SELECT @respuesta;

/*8*/
delimiter //
CREATE PROCEDURE modificarComment(in orden int, in comm TEXT, out funciono int)
BEGIN
	IF EXISTS(SELECT orderNumber FROM orders WHERE orderNumber = orden)THEN
    
    UPDATE orders
    SET comments = comm
    WHERE orderNumber = orden;
    
    SET funciono = 1;
    
    ELSE
    
    SET funciono = 0;
    
    END IF;

END //
delimiter ;

CALL modificarComment(312, "hola" , @funciono);
SELECT @funciono;
