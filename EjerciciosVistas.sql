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



