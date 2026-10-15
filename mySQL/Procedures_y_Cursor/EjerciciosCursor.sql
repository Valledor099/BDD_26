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


DELIMITER $$
 
DROP PROCEDURE IF EXISTS sp_insert_con_cursor$$
 
CREATE PROCEDURE sp_insert_con_cursor()
BEGIN
 
    DECLARE v_emp_number    INT;
    DECLARE v_done          INT DEFAULT FALSE;
 

    DECLARE cur_empleados CURSOR FOR
        SELECT employeeNumber
        FROM classicmodels.employees
        WHERE jobTitle = 'Sales Rep';
 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
 
  
    DECLARE v_customerNumber    INT;
    DECLARE v_orderNumber       INT;
    DECLARE i                   INT DEFAULT 1;
    DECLARE j                   INT;
    DECLARE v_numOrders         INT;
    DECLARE v_orderDate         DATE;
    DECLARE v_requiredDate      DATE;
    DECLARE v_shippedDate       DATE;
    DECLARE v_status            VARCHAR(15);
    DECLARE v_comments          TEXT;
    DECLARE v_salesRep          INT;
 

    DROP TEMPORARY TABLE IF EXISTS tmp_sales_reps;
    CREATE TEMPORARY TABLE tmp_sales_reps (
        id      INT AUTO_INCREMENT PRIMARY KEY,
        emp_num INT
    );
 
 
    OPEN cur_empleados;
 
    leer_empleados: LOOP
        FETCH cur_empleados INTO v_emp_number;
        IF v_done THEN
            LEAVE leer_empleados;
        END IF;
        INSERT INTO tmp_sales_reps (emp_num) VALUES (v_emp_number);
    END LOOP leer_empleados;
 
    CLOSE cur_empleados;
 
  
    IF (SELECT COUNT(*) FROM tmp_sales_reps) = 0 THEN
        INSERT INTO tmp_sales_reps (emp_num)
        VALUES (1166),(1165),(1188),(1216),(1286),(1323),(1337);
    END IF;
 

    SET v_customerNumber = (SELECT IFNULL(MAX(customerNumber), 200) + 1
                            FROM classicmodels.customers);
    SET v_orderNumber    = (SELECT IFNULL(MAX(orderNumber), 11000) + 1
                            FROM classicmodels.orders);
 
  
    WHILE i <= 10000 DO
 
       
        SET v_salesRep = (
            SELECT emp_num
            FROM tmp_sales_reps
            WHERE id = 1 + MOD(i, (SELECT COUNT(*) FROM tmp_sales_reps))
        );
 
   
        INSERT INTO classicmodels.customers (
            customerNumber,
            customerName,
            contactLastName,
            contactFirstName,
            phone,
            addressLine1,
            addressLine2,
            city,
            state,
            postalCode,
            country,
            salesRepEmployeeNumber,
            creditLimit
        )
        VALUES (
            v_customerNumber,
 
          
            CONCAT(
                ELT(1 + MOD(i,  20),
                    'Alpha','Beta','Gamma','Delta','Sigma','Omega','Nova','Prime',
                    'Elite','Global','Pacific','Atlantic','Summit','Pioneer','Apex',
                    'Vertex','Horizon','Zenith','Stellar','Eagle'),
                ' ',
                ELT(1 + MOD(i * 3, 25),
                    'Trading','Gifts','Models','Collectibles','Imports',
                    'Exports','Distributors','Solutions','Ventures','Industries',
                    'Group','Partners','Associates','Holdings','Enterprises',
                    'Supplies','Wholesale','Retail','Direct','International',
                    'Commerce','Services','Logistics','Depot','Market'),
                ' ',
                ELT(1 + MOD(i * 7, 6), 'Ltd.','Inc.','Co.','Corp.','S.A.','GmbH')
            ),
 
    
            ELT(1 + MOD(i * 11, 40),
                'Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis',
                'Rodriguez','Martinez','Hernandez','Lopez','Gonzalez','Wilson','Anderson',
                'Thomas','Taylor','Moore','Jackson','Martin','Lee','Perez','Thompson','White',
                'Harris','Sanchez','Clark','Ramirez','Lewis','Robinson','Walker','Young',
                'Allen','King','Wright','Scott','Torres','Nguyen','Hill','Flores'),
 
         
            ELT(1 + MOD(i * 13, 30),
                'James','Mary','John','Patricia','Robert','Jennifer','Michael','Linda',
                'William','Barbara','David','Susan','Richard','Jessica','Joseph','Sarah',
                'Thomas','Karen','Charles','Lisa','Christopher','Nancy','Daniel','Betty',
                'Matthew','Margaret','Anthony','Sandra','Mark','Ashley'),
 
         
            CONCAT(
                '+', 1 + MOD(i, 99),
                ' ', 100 + MOD(i * 17, 900),
                ' ', LPAD(MOD(i * 31, 9000000), 7, '0')
            ),
 
  
            CONCAT(
                100 + MOD(i * 19, 9900), ' ',
                ELT(1 + MOD(i * 23, 10),
                    'Main St','Oak Ave','Maple Rd','Pine Blvd','Cedar Ln',
                    'Elm St','Park Ave','Lake Dr','River Rd','Hill St')
            ),
 

            CASE WHEN MOD(i, 3) = 0
                 THEN CONCAT('Suite ', 100 + MOD(i, 900))
                 ELSE NULL
            END,
 
  
            ELT(1 + MOD(i * 29, 50),
                'New York','Los Angeles','Chicago','Houston','Phoenix',
                'Philadelphia','San Antonio','San Diego','Dallas','San Jose',
                'Austin','Jacksonville','Fort Worth','Columbus','Charlotte',
                'Indianapolis','San Francisco','Seattle','Denver','Nashville',
                'Oklahoma City','El Paso','Washington','Boston','Memphis',
                'Louisville','Portland','Las Vegas','Milwaukee','Albuquerque',
                'London','Paris','Madrid','Berlin','Rome',
                'Amsterdam','Brussels','Vienna','Sydney','Melbourne',
                'Toronto','Vancouver','Tokyo','Singapore','Dubai',
                'Mexico City','Buenos Aires','São Paulo','Mumbai','Shanghai'),
 
   
            CASE
                WHEN MOD(i * 43, 20) < 10
                THEN ELT(1 + MOD(i * 37, 10),
                         'CA','TX','NY','FL','IL','PA','OH','GA','NC','MI')
                ELSE NULL
            END,
 
    
            LPAD(10000 + MOD(i * 41, 89999), 5, '0'),
 

            ELT(1 + MOD(i * 43, 20),
                'USA','USA','USA','USA','USA','USA','UK','France','Germany','Spain',
                'Italy','Australia','Canada','Japan','Singapore','Netherlands',
                'Argentina','Brazil','India','China'),
 
     
            v_salesRep,
 
         
            ROUND((5000 + MOD(i * 53, 195000)) / 1000) * 1000
        );
 
   
        SET v_numOrders = 1 + MOD(i * 59, 5);   
        SET j = 1;
 
        WHILE j <= v_numOrders DO
 
            SET v_orderDate    = DATE_ADD('2020-01-01',
                                          INTERVAL MOD(i * j * 67, 1826) DAY);
            SET v_requiredDate = DATE_ADD(v_orderDate,
                                          INTERVAL 7 + MOD(i * j, 21) DAY);
 
    
            SET v_status = ELT(1 + MOD(i * j * 71, 5),
                               'Shipped','Shipped','Shipped',
                               'In Process','Cancelled');
 
         
            SET v_shippedDate =
                CASE v_status
                    WHEN 'Shipped'
                    THEN DATE_ADD(v_orderDate, INTERVAL 1 + MOD(i * j, 6) DAY)
                    ELSE NULL
                END;
 
        
            SET v_comments =
                CASE MOD(i * j, 6)
                    WHEN 0 THEN 'Priority order. Handle with care.'
                    WHEN 3 THEN CONCAT('Customer reference: REF-', i, '-', j)
                    ELSE NULL
                END;
 
            INSERT INTO classicmodels.orders (
                orderNumber,
                orderDate,
                requiredDate,
                shippedDate,
                status,
                comments,
                customerNumber
            )
            VALUES (
                v_orderNumber,
                v_orderDate,
                v_requiredDate,
                v_shippedDate,
                v_status,
                v_comments,
                v_customerNumber
            );
 
            SET v_orderNumber = v_orderNumber + 1;
            SET j = j + 1;
        END WHILE;
 
     
        SET v_customerNumber = v_customerNumber + 1;
        SET i = i + 1;
    END WHILE;
 
   
    DROP TEMPORARY TABLE IF EXISTS tmp_sales_reps;
 

    SELECT
        (SELECT COUNT(*) FROM classicmodels.customers) AS total_customers,
        (SELECT COUNT(*) FROM classicmodels.orders)    AS total_orders;
 
END$$
 
DELIMITER ;
 
-- ============================================================
-- Ejecutar
-- ============================================================
CALL sp_insert_con_cursor();






/**/



    
        

    