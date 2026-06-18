USE classicmodels;

-- 1 -- 
DELIMITER //
create procedure compra (in idcliente int, in idproducto text, in cantidad int, in fechaenvio date)
begin 
start transaction;
update products set quantityInStock = quantityInStock - cantidad
where productCode = idproducto;
if(select quantityInStock from products where productCode = idproducto) < 0 then 
rollback;
signal sqlstate '45000' set MESSAGE_TEXT = 'Error, saldo insuficiente';
end if;
commit;
end//
DELIMITER ;

drop procedure compra;

CALL compra (12,'S10_1678', 10000,date(now()))

-- 2 --
DELIMITER //
CREATE PROCEDURE realizar_pago(
    IN p_customerNumber INT,
    IN p_checkNumber VARCHAR(50),
    IN p_paymentDate DATE,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_aprobado BOOL;

    START TRANSACTION;

    INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
    VALUES (p_customerNumber, p_checkNumber, p_paymentDate, p_amount);

    SET v_aprobado = simular_pago_tarjeta(p_checkNumber);

    IF v_aprobado THEN
        IF p_amount > 800000 THEN
            UPDATE customers
            SET creditLimit = 1500000
            WHERE customerNumber = p_customerNumber;
        END IF;
        COMMIT;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pago rechazado';
    END IF;
END//
DELIMITER ;

-- 3 --
DELIMITER //
CREATE PROCEDURE cancelar_pedido(IN p_orderNumber INT)
BEGIN
    DECLARE v_status VARCHAR(50);

    START TRANSACTION;

    SELECT status INTO v_status FROM orders WHERE orderNumber = p_orderNumber;

    IF v_status = 'Shipped' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede cancelar un pedido que ya fue enviado';
    END IF;

    UPDATE orders SET status = 'Cancelled' WHERE orderNumber = p_orderNumber;

    UPDATE products p
    JOIN orderdetails od ON p.productCode = od.productCode
    SET p.quantityInStock = p.quantityInStock + od.quantityOrdered
    WHERE od.orderNumber = p_orderNumber;

    COMMIT;
END//
DELIMITER ;

-- 4 --
DELIMITER //
CREATE PROCEDURE reasignar_vendedor(
    IN p_old_employeeNumber INT,
    IN p_new_employeeNumber INT
)
BEGIN
    DECLARE v_old_officeCode VARCHAR(10);
    DECLARE v_new_officeCode VARCHAR(10);

    START TRANSACTION;

    SELECT officeCode INTO v_old_officeCode FROM employees WHERE employeeNumber = p_old_employeeNumber;

    SELECT officeCode INTO v_new_officeCode FROM employees WHERE employeeNumber = p_new_employeeNumber;

    IF v_new_officeCode IS NULL OR v_new_officeCode != v_old_officeCode THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Vendedor no apto para esta zona';
    END IF;

    UPDATE customers
    SET salesRepEmployeeNumber = p_new_employeeNumber
    WHERE salesRepEmployeeNumber = p_old_employeeNumber;

    COMMIT;
END//
DELIMITER ;


