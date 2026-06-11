use classicmodels;

DELIMITER $$

CREATE PROCEDURE Generar20MilPedidos()
BEGIN
    -- Variables de control del bucle
    DECLARE i INT DEFAULT 1;
    DECLARE v_customerNumber INT;
    DECLARE v_orderNumber INT;
    DECLARE v_status VARCHAR(15);
    
    -- Variables para fechas
    DECLARE v_orderDate DATE;
    DECLARE v_requiredDate DATE;
    DECLARE v_shippedDate DATE;
    
    -- Variables para el detalle del pedido
    DECLARE v_productCode VARCHAR(15);
    DECLARE v_priceEach DECIMAL(10,2);
    DECLARE v_quantityOrdered INT;

    -- Variables para la optimización aleatoria
    DECLARE v_max_cust INT;
    DECLARE v_max_prod INT;
    DECLARE v_rand_index INT;

    -- 1. PREPARACIÓN ULTRA-RÁPIDA: Crear tablas temporales con índices correlativos (1, 2, 3...)
    DROP TEMPORARY TABLE IF EXISTS tmp_customers;
    CREATE TEMPORARY TABLE tmp_customers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        customerNumber INT
    );
    INSERT INTO tmp_customers (customerNumber) SELECT customerNumber FROM customers;
    SELECT COUNT(*) INTO v_max_cust FROM tmp_customers;

    DROP TEMPORARY TABLE IF EXISTS tmp_products;
    CREATE TEMPORARY TABLE tmp_products (
        id INT AUTO_INCREMENT PRIMARY KEY,
        productCode VARCHAR(15),
        buyPrice DECIMAL(10,2)
    );
    INSERT INTO tmp_products (productCode, buyPrice) SELECT productCode, buyPrice FROM products;
    SELECT COUNT(*) INTO v_max_prod FROM tmp_products;

    -- Obtener el número de pedido más alto actual
    SELECT IFNULL(MAX(orderNumber), 10000) INTO v_orderNumber FROM orders;

    -- Desactivar el autocommit e iniciar transacción única para máxima velocidad
    SET autocommit = 0;
    START TRANSACTION;

    -- 2. BUCLE PRINCIPAL
    WHILE i <= 20000 DO
        
        SET v_orderNumber = v_orderNumber + 1;

        -- Buscar cliente aleatorio de forma instantánea usando el ID de la tabla temporal
        SET v_rand_index = FLOOR(1 + (RAND() * v_max_cust));
        SELECT customerNumber INTO v_customerNumber FROM tmp_customers WHERE id = v_rand_index;

        -- Generar fechas aleatorias coherentes
        SET v_orderDate = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 1000) DAY);
        SET v_requiredDate = DATE_ADD(v_orderDate, INTERVAL FLOOR(5 + (RAND() * 10)) DAY);
        
        -- Asignar un estado aleatorio
        SET v_status = ELT(FLOOR(1 + (RAND() * 6)), 'Shipped', 'Resolved', 'Cancelled', 'On Hold', 'Disputed', 'In Process');

        -- Asignar fecha de envío según el estado
        IF v_status = 'Shipped' OR v_status = 'Resolved' THEN
            SET v_shippedDate = DATE_ADD(v_orderDate, INTERVAL FLOOR(1 + (RAND() * 4)) DAY);
        ELSE
            SET v_shippedDate = NULL;
        END IF;

        -- Insertar en la tabla 'orders'
        INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
        VALUES (v_orderNumber, v_orderDate, v_requiredDate, v_shippedDate, v_status, NULL, v_customerNumber);

        -- Buscar producto aleatorio de forma instantánea usando la tabla temporal
        SET v_rand_index = FLOOR(1 + (RAND() * v_max_prod));
        SELECT productCode, buyPrice INTO v_productCode, v_priceEach FROM tmp_products WHERE id = v_rand_index;
        
        -- Calcular precio final y cantidad
        SET v_priceEach = v_priceEach * (1 + (RAND() * 0.30));
        SET v_quantityOrdered = FLOOR(10 + (RAND() * 90));

        -- Insertar en la tabla 'orderdetails'
        INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
        VALUES (v_orderNumber, v_productCode, v_quantityOrdered, v_priceEach, 1);

        SET i = i + 1;
        
    END WHILE;

    -- Guardar absolutamente todo al final de un solo golpe
    COMMIT;
    SET autocommit = 1;

    -- Limpieza de tablas temporales
    DROP TEMPORARY TABLE IF EXISTS tmp_customers;
    DROP TEMPORARY TABLE IF EXISTS tmp_products;
    
END$$

DELIMITER ;

drop procedure Generar20MilPedidos;

CALL Generar20MilPedidos();
 
 SELECT * FROM orders where orderNumber = 29101;

-- con index
create index indiceFecha on orders(orderDate);
explain analyze SELECT * FROM orders where orderDate between '2021-06-06' and now();
-- '-> Index lookup on orders using indiceFecha (orderDate=DATE\'2021-06-06\')  (cost=7.7 rows=22) (actual time=0.0241..0.112 rows=22 loops=1)\n'


-- sin index
explain analyze SELECT * FROM orders where orderDate = '2021-06-06';
-- '-> Filter: (orders.orderDate between \'2021-06-06\' and <cache>(now()))  (cost=6869 rows=33982) (actual time=1.17..53 rows=61423 loops=1)\n    -> Table scan on orders  (cost=6869 rows=67965) (actual time=0.0372..39.2 rows=70324 loops=1)\n'

-- con index compuesto
create index indiceCE on orders(customerNumber, status);
explain analyze SELECT * FROM orders where customerNumber =6722 and status = 'Shipped';
-- '-> Index lookup on orders using indiceCE (customerNumber=6722, status=\'Shipped\')  (cost=1.4 rows=4) (actual time=0.0151..0.0252 rows=4 loops=1)\n'

explain analyze SELECT * FROM orders where customerNumber =6722;
-- '-> Index lookup on orders using customerNumber (customerNumber=6722)  (cost=2.1 rows=6) (actual time=0.0134..0.0257 rows=6 loops=1)\n'


explain analyze SELECT * FROM orders where status = 'Shipped';
-- '-> Filter: (orders.`status` = \'Shipped\')  (cost=6869 rows=6797) (actual time=0.0176..40.8 rows=20877 loops=1)\n    -> Table scan on orders  (cost=6869 rows=67965) (actual time=0.0165..36.5 rows=70324 loops=1)\n'
