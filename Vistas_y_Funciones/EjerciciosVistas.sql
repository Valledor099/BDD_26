use classicmodels;
/*6-10-11-13*/

/*6*/
CREATE VIEW clientesNoPagos AS SELECT c.customerNumber AS clientes FROM customers c
WHERE c.customerNumber NOT IN (SELECT p.CustomerNumber FROM payments p);

SELECT * FROM clientesNoPagos;

/*10*/
CREATE VIEW clientmasde2anios AS SELECT c.customerName AS ClienteNombre, c.addressLine1 AS direccion FROM customers c 
WHERE c.customerNumber IN (SELECT p.CustomerNumber FROM payments p
WHERE (p.paymentDate < curdate() - INTERVAL 2 year) AND p.amount > 30000 );

SELECT * FROM clientmasde2anios;


/*11*/
CREATE VIEW pedidosTardeCancel AS SELECT o.orderNumber AS numerosdeOrden FROM orders o
WHERE o.status = "Cancelled" OR o.status = "Resolved";

SELECT * FROM pedidosTardeCancel;

/*13*/
CREATE VIEW clienteHistorico AS SELECT subq.cliente AS cliente 
FROM (SELECT sum(od.quantityOrdered)  AS cant, o.customerNumber as cliente FROM orderdetails od
JOIN orders o ON o.orderNumber = od.orderNumber
GROUP BY cliente) as subq
ORDER BY subq.cant DESC
LIMIT 1;

select * from clienteHistorico;

/*Functions*/
/*1*/
delimiter //
CREATE FUNCTION cantOrdenes (fechaInicio date, fechaFin date, estado text) returns int deterministic
begin
	declare cantOrdenes int;
    SELECT COUNT(orderNumber) AS cant INTO cantOrdenes FROM orders 
    WHERE (status = estado) AND (orderDate between fechaInicio and fechaFin);
    return cantOrdenes;
end//
delimiter ;

SELECT cantOrdenes("2003-01-01",current_date(),"Cancelled") as "Cantidad de ordenes";

/*2*/
delimiter //
CREATE FUNCTION Ordenes (fechaDesde DATE, fechaHasta DATE) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE cantO INT;
    SELECT COUNT(orderNumber) as cant INTO cantO FROM orders
    WHERE (shippedDate BETWEEN fechaDesde AND fechaHasta);
    RETURN cantO;

END //
delimiter ;

DROP FUNCTION Ordenes;

SELECT Ordenes("2003-01-01", current_date()) as "Cantidad de ordenes";

/*3-7-8-10-12-14*/

/*3*/
delimiter //
CREATE FUNCTION Ciudad(numeroCliente int) returns TEXT deterministic
BEGIN
	DECLARE ciudadEmpleado TEXT;
    SELECT city INTO ciudadEmpleado FROM offices
    WHERE officeCode = (SELECT officeCode FROM employees
    WHERE employeeNumber = (select salesRepEmployeeNumber FROM customers
    WHERE customerNumber = numeroCliente));
    
    RETURN ciudadEmpleado;

END //
delimiter ;

DROP function Ciudad;

SELECT Ciudad(103);

/*7*/
delimiter //
CREATE FUNCTION beneficioOrden(nroOrden INT, nroProducto varchar(45)) returns FLOAT deterministic
BEGIN
	DECLARE beneficio FLOAT;
    select subq.precio - subq.precioD INTO beneficio FROM (
    SELECT ord.priceEach as precio, p.buyPrice as precioD FROM products p
    JOIN orderdetails ord ON ord.productCode = p.productCode
    WHERE (p.productCode = nroProducto) and (ord.orderNumber = nroOrden)) as subq;
    RETURN beneficio;
END//
delimiter ;

drop FUNCTION beneficioOrden;

SELECT beneficioOrden(10100, "S18_1749");

/*8*/
delimiter //
CREATE FUNCTION estadoCancel(numeroOrden int) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE estado int default 0;
    if ( (SELECT orderNumber FROM orders WHERE status = "cancelled" and orderNumber = numeroOrden)) THEN
    set estado = -1;
    END IF;
    RETURN estado;
    
END //
delimiter ;

drop FUNCTION estadoCancel;
select estadoCancel(10100) as 'Cancelado o no?';

/*10*/
delimiter //
CREATE FUNCTION ventaBaja (codigoProducto TEXT) RETURNS FLOAT DETERMINISTIC
begin
	DECLARE promedio float;
    DECLARE cantMenos int;
    DECLARE Total int;
    
    SELECT COUNT(p.productCode) INTO cantMenos FROM products p
    JOIN orderdetails ord ON ord.productCode = p.productCode
    WHERE p.MSRP > ord.priceEach ;
	
    SELECT COUNT(p.productCode) INTO Total FROM products p;
    
    set promedio = cantMenos / Total;
	RETURN promedio;
end //
delimiter ;

drop function ventaBaja;

SELECT ventaBaja("S18_1589");

/*12*/
delimiter //
CREATE FUNCTION produOrder(fechaInicio DATE, fechaFin DATE, codeprodu INT) RETURNS FLOAT deterministic
BEGIN
	DECLARE mayorVenta FLOAT DEFAULT 0;
    
    SELECT MAX(ord.priceEach) INTO mayorVenta FROM orderdetails ord
    JOIN orders o ON o.orderNumber = ord.orderNumber
    WHERE (codeprodu = ord.productCode) AND (o.orderDate BETWEEN fechaInicio AND fechaFin); 
    RETURN mayorVenta;
    
END//

    


