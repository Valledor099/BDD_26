

/*---------------------------------------Stored Functions--------------------------------------------*/

/*1*/
DELIMITER //

CREATE FUNCTION fn_tiempo_promedio_venta(idVendedor INT) RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedio FLOAT;

    SELECT AVG(TIMESTAMPDIFF(DAY,p.fecha_publicacion,v.fecha_venta)) INTO promedio FROM Publicacion p
    JOIN Venta v ON p.id_publicacion = v.id_publicacion
    WHERE p.id_vendedor = idVendedor;
	
    IF promedio IS NULL THEN
		RETURN 0;
	ELSE
		RETURN promedio;
	END IF;
   
END //

DELIMITER ;

SELECT fn_tiempo_promedio_venta(6);

/*2*/
DELIMITER //

CREATE FUNCTION fn_comision(montoVenta FLOAT, nivel VARCHAR(20)) RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE comision float;

    IF LOWER(nivel) = 'normal' THEN
        SET comision = montoVenta * 0.08;

    ELSEIF LOWER(nivel) = 'platinum' THEN
        SET comision = montoVenta * 0.05;

    ELSEIF LOWER(nivel) = 'gold' THEN
        SET comision = montoVenta * 0.03;

    ELSE
        RETURN -1;
    END IF;

    RETURN comision;
END //

DELIMITER ;

SELECT fn_comision(100000, 'GOLD');

/*3*/

DELIMITER //

CREATE FUNCTION fn_porcentaje_ventas(idVendedor INT) RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE totalPublicaciones INT;
    DECLARE ventasConcretadas INT;

    SELECT COUNT(*) INTO totalPublicaciones FROM Publicacion
    WHERE id_vendedor = idVendedor;

    IF totalPublicaciones = 0 THEN
        RETURN 0;
    END IF;

    SELECT COUNT(*) INTO ventasConcretadas FROM Venta v
    JOIN Publicacion p ON v.id_publicacion = p.id_publicacion
    WHERE p.id_vendedor = idVendedor;

    RETURN (ventasConcretadas / totalPublicaciones) * 100;
END //

DELIMITER ;

SELECT fn_porcentaje_ventas(4);

/*4*/

DELIMITER //

CREATE FUNCTION fn_mayor_oferta(idPublicacion INT) RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE tipo INT;
    DECLARE mayor float;

    SELECT id_tipo_publicacion INTO tipo FROM Publicacion
    WHERE id_publicacion = idPublicacion;

    IF tipo <> 2 THEN
        RETURN -1;
    END IF;

    SELECT MAX(monto) INTO mayor FROM Oferta
    WHERE id_publicacion = idPublicacion;

    IF mayor IS NULL THEN
		RETURN 0;
	ELSE
		RETURN mayor;
	END IF;
    
END //

DELIMITER ;

SELECT fn_mayor_oferta(5);

/*5*/

DELIMITER //

CREATE FUNCTION fn_precio_promedio_categoria(idCategoria INT) RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedio FLOAT;

    SELECT AVG(precio) INTO promedio FROM Publicacion
    WHERE id_categoria = idCategoria;

    IF promedio IS NULL THEN
		RETURN 0;
	ELSE
		RETURN promedio;
	END IF;
    
END //

DELIMITER ;

SELECT fn_precio_promedio_categoria(2);

/*6*/
DELIMITER //

CREATE FUNCTION fn_ultima_compra(idUsuario INT) RETURNS DATETIME DETERMINISTIC
BEGIN
    DECLARE ultimaCompra DATETIME;

    SELECT MAX(fecha_venta) INTO ultimaCompra FROM Venta
    WHERE id_comprador = idUsuario;

    RETURN ultimaCompra;
END //

DELIMITER ;

SELECT fn_ultima_compra(1);

/*------------------Stored Procedures----------------------------*/
-- 1. 
DELIMITER // 
CREATE PROCEDURE listarPublicacionesProducto (IN nombreProducto TEXT) 
BEGIN   
	SELECT id_publicacion, titulo, precio FROM Publicacion
    WHERE titulo LIKE CONCAT ('%' , nombreProducto , '%') OR descripicion LIKE CONCAT ('%' , nombreProducto , '%');
END // 
DELIMITER ;
 
DROP PROCEDURE ListarPublicacionesProducto;
CALL listarPublicacionesProducto('PlayStation 5');
 
-- 2.
DELIMITER  // 
CREATE PROCEDURE Pujar (IN p_idPublicacion INT, IN p_idUsuario INT, IN p_dinero FLOAT)
BEGIN 
    DECLARE estaFinalizada INT DEFAULT 0;
    DECLARE maxOferta FLOAT;
    
   SET maxOferta = fn_mayor_oferta(p_idPublicacion);
    
    IF maxOferta = -1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion no existe o no es una subasta';
    END IF;
    
    SELECT COUNT(*) INTO estaFinalizada FROM Publicacion pu
    JOIN Estado e ON  pu.id_estado = e.id_estado
    WHERE pu.id_publicacion = p_idPublicacion AND e.nombre = 'Finalizada';
    
    IF estaFInalizada = TRUE THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion ya finalizó';
    END IF;
    
    IF p_dinero <= maxOferta THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto ofertado debe ser mayor que el maximo ofertado';
    END IF;
    
    INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
    VALUES (p_idPublicacion, p_idUsuario, p_dinero, NOW());
    
END //
DELIMITER ;
 
DROP PROCEDURE Pujar;
CALL Pujar(9, 1, 999999);
 
-- 3.
DELIMITER //
CREATE PROCEDURE pausarPublicacion (IN p_idPublicacion INT, IN P_idUsuario INT)
BEGIN 
	DECLARE idVendedor INT;
    DECLARE idtipoPublicacion INT;
    DECLARE nombreEstado TEXT;
    DECLARE idEstadoPausado INT;
    
	SELECT pu.id_vendedor, pu.id_tipo_publicacion, e.nombre INTO idVendedor, idtipoPublicacion, nombreEstado FROM Publicacion pu 
    JOIN Estado e ON pu.id_estado = e.id_estado
    WHERE pu.id_publicacion = p_idPUblicacion;
    
    IF idVendedor IS NULL THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion seleccionada no existe';
    END IF;
    
    IF idtipoPublicacion != 1 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se pueden pausar publicaciones de venta directa';
    END IF;
    
    IF nombreEstado = 'Finalizada' THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion ya esta finalizada';
    END IF;
    
    IF nombreEstado = 'Pausada' THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion ya esta pausada';
    END IF;
    
    IF p_idUsuario != idVendedor THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo el vendedor puede pausar la publicacion';
    END IF;
    
    SELECT id_estado INTO idEstadoPausado FROM Estado 
    WHERE nombre = 'Pausada';
    
    UPDATE Publicacion 
    SET id_estado = idEstadoPausado
    WHERE id_publicacion = p_idPublicacion;
END //
DELIMITER ;
 
DROP PROCEDURE pausarPublicacion;
CALL pausarPublicacion (1,1);
 
-- 4.
DELIMITER //
CREATE PROCEDURE actualizarNivelUsuario (IN p_idUsuario INT, OUT p_nuevoNivel TEXT)
BEGIN 
	DECLARE ventas INT;
    DECLARE nombreNivel TEXT;
    DECLARE idNivelNuevo INT;
    
    SELECT cantidad_ventas INTO ventas FROM Usuarios
    WHERE id_usuario = p_idUsuario;
    
    IF ventas  IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuarion no tiene compras o no existe';
    END IF;
    
    IF ventas >= 11 THEN 
	SET nombreNivel = 'Gold';
    
    ELSEIF ventas >= 7 THEN 
    SET nombreNivel = 'Platinum';
    ELSE SET nombreNivel = 'Normal';
    END IF;
    
    SELECT id_nivel_usuario INTO idNivelNuevo FROM Nivel_Usuario 
    WHERE nombre = nombreNivel;
    
    UPDATE Usuarios 
    SET nivel_id = idNivelNuevo
    WHERE id_usuario = p_idUsuario;
    SET p_nuevoNivel = nombreNivel;
 
END //
DELIMITER ;
 
CALL actualizarNivelUsuario(1, @nivel);
SELECT @nivel;

 





/*--------------------VIEWS--------------------------*/
/*1*/

CREATE VIEW vw_preguntas_sin_respuesta AS
SELECT pr.id_pregunta,pr.pregunta AS descripcion, p.id_publicacion,prod.nombre AS nombre_producto, NULL AS usuario_respondio FROM Preguntas_Respuestas pr
JOIN Publicacion p ON pr.id_publicacion = p.id_publicacion
JOIN Producto prod ON p.id_producto = prod.id_producto
WHERE p.id_estado = 1 AND pr.respuesta IS NULL;

SELECT * FROM vw_preguntas_sin_respuesta;

/*2*/

CREATE VIEW vw_top_10_categorias_semana AS SELECT c.id_categoria,c.nombre AS categoria, COUNT(p.id_publicacion) AS cantidad_publicaciones FROM Categoria c
JOIN Publicacion p ON c.id_categoria = p.id_categoria
WHERE YEARWEEK(p.fecha_publicacion, 1) = YEARWEEK(CURDATE(), 1)
GROUP BY c.id_categoria, c.nombre
ORDER BY cantidad_publicaciones DESC
LIMIT 10;

drop view vw_top_10_categorias_semana;

SELECT * FROM vw_top_10_categorias_semana;


/*Lo cambiamos para comprobar*/
UPDATE Publicacion
SET fecha_publicacion = NOW()
WHERE id_publicacion IN (1, 3, 5, 7, 9);

/*3*/

CREATE VIEW vw_publicaciones_tendencia_hoy AS
SELECT p.id_publicacion,p.titulo,prod.nombre AS producto,COUNT(pr.id_pregunta) AS cantidad_preguntas FROM Publicacion p
JOIN Producto prod ON p.id_producto = prod.id_producto
JOIN Preguntas_Respuestas pr ON p.id_publicacion = pr.id_publicacion
WHERE DATE(pr.fecha_pregunta) = CURDATE()
GROUP BY p.id_publicacion,p.titulo,prod.nombre
ORDER BY cantidad_preguntas DESC;

drop view vw_publicaciones_tendencia_hoy;

SELECT * FROM vw_publicaciones_tendencia_hoy;

/*4*/
CREATE VIEW vw_mejor_vendedor_categoria AS
SELECT c.nombre AS categoria, CONCAT(u.nombre, ' ', u.apellido) AS vendedor, u.reputacion FROM Categoria c
JOIN Publicacion p ON c.id_categoria = p.id_categoria
JOIN Usuarios u ON p.id_vendedor = u.id_usuario
WHERE u.reputacion = (SELECT MAX(u2.reputacion) FROM Publicacion p2 
JOIN Usuarios u2 ON p2.id_vendedor = u2.id_usuario WHERE p2.id_categoria = c.id_categoria)
GROUP BY c.id_categoria, c.nombre, u.id_usuario, u.nombre, u.apellido, u.reputacion
ORDER BY u.reputacion DESC;

DROP VIEW vw_mejor_vendedor_categoria;

SELECT * FROM vw_mejor_vendedor_categoria;

/*---------------Triggers-----------------*/
/*1- No lo realizamos ya que creamos una tabla que cuenta con una columna Pregunta 
y otra Respuesta entonces cuando se borra esa fila se borran las dos*/

/*2*/

DELIMITER //
CREATE TRIGGER trg_after_venta_nivel AFTER INSERT ON Venta FOR EACH ROW
BEGIN
    DECLARE v_id_vendedor INT;
    DECLARE v_ventas INT;
    DECLARE v_facturacion FLOAT;
    DECLARE v_nuevo_nivel INT;

    -- Obtener el vendedor de la publicación vendida
    SELECT id_vendedor INTO v_id_vendedor FROM Publicacion 
    WHERE id_publicacion = NEW.id_publicacion;

    -- Actualizar las métricas del vendedor
    UPDATE Usuarios 
    SET cantidad_ventas = cantidad_ventas + 1,
        facturacion_total = facturacion_total + NEW.monto
    WHERE id_usuario = v_id_vendedor;

    -- Consultar las nuevas métricas actualizadas
    SELECT cantidad_ventas, facturacion_total INTO v_ventas, v_facturacion FROM Usuarios 
    WHERE id_usuario = v_id_vendedor;

    -- Lógica para asignar el id_nivel_usuario según las nuevas reglas
    -- Se evalúa desde la condición más alta a la más baja
    IF v_ventas >= 11 OR v_facturacion >= 1000000 THEN
        SET v_nuevo_nivel = 3;
    
    ELSEIF v_ventas >= 6 OR v_facturacion >= 100000 THEN
        SET v_nuevo_nivel = 2;
    
    ELSE
        SET v_nuevo_nivel = 1;
    END IF;

    -- Actualizar el nivel del usuario
    UPDATE Usuarios 
    SET nivel_id = v_nuevo_nivel 
    WHERE id_usuario = v_id_vendedor;
END //
DELIMITER ;


/*QUERY PARA PROBAR*/
-- CONSULTAR EL ESTADO INICIAL DEL VENDEDOR (id_usuario = 1)
SELECT id_usuario, nombre, apellido, cantidad_ventas, facturacion_total, nivel_id FROM Usuarios 
WHERE id_usuario = 1;

-- INSERTAR UNA NUEVA VENTA
INSERT INTO Venta 
(id_publicacion, id_comprador, id_medio_pago, id_medio_envio, fecha_venta, monto)
VALUES 
(1, 2, 1, 1, NOW(), 150000);

-- VERIFICAR
SELECT u.id_usuario, u.nombre, u.apellido, u.cantidad_ventas, u.facturacion_total, u.nivel_id, n.nombre AS nombre_nivel FROM Usuarios u
LEFT JOIN Nivel_Usuario n ON u.nivel_id = n.id_nivel_usuario
WHERE u.id_usuario = 1;

/*3*/

DELIMITER //
CREATE TRIGGER trg_after_calificacion AFTER INSERT ON Calificacion FOR EACH ROW
BEGIN
    DECLARE v_promedio INT;

    -- Calcular el promedio redondeado de los puntajes del usuario
    SELECT ROUND(AVG(puntaje)) INTO v_promedio FROM Calificacion
    WHERE id_usuario_evaluado = NEW.id_usuario_evaluado;

    -- Actualizar el campo 'reputacion' en la tabla Usuarios
    UPDATE Usuarios
    SET reputacion = v_promedio
    WHERE id_usuario = NEW.id_usuario_evaluado;
END //
DELIMITER ;

/*COMPROBACION*/
--  Ver el estado actual de la reputación del Usuario 1
SELECT id_usuario, nombre, apellido, reputacion FROM Usuarios 
WHERE id_usuario = 1;

-- Insertar calificaciones para el Usuario 1
-- Calificación 1: 90 puntos por la Venta 1
INSERT INTO Calificacion (id_venta, id_usuario_evaluado, id_calificador, puntaje, comentario)
VALUES (1, 1, 2, 90, 'Excelente vendedor, llegó todo a tiempo.');

-- Calificación 2: 80 puntos por la Venta 1
INSERT INTO Calificacion (id_venta, id_usuario_evaluado, id_calificador, puntaje, comentario)
VALUES (1, 1, 3, 80, 'Buena atención y producto en buen estado.');

-- Consultar nuevamente la tabla Usuarios para comprobar el cambio en 'reputacion'
SELECT id_usuario, nombre, apellido, reputacion FROM Usuarios 
WHERE id_usuario = 1;

/*4*/

DELIMITER //
CREATE TRIGGER trg_before_oferta BEFORE INSERT ON Oferta FOR EACH ROW
BEGIN
    DECLARE v_id_estado INT;
    DECLARE v_id_vendedor INT;
    DECLARE v_max_monto FLOAT;

    -- 1. Obtener estado y vendedor de la publicación
    SELECT id_estado, id_vendedor INTO v_id_estado, v_id_vendedor FROM Publicacion 
    WHERE id_publicacion = NEW.id_publicacion;

    -- Validar que la publicación esté Activa (id_estado = 1)
    IF v_id_estado != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La publicación no está activa o ya finalizó.';
    END IF;

    -- 2. Validar que el usuario no sea el vendedor
    IF NEW.id_usuario = v_id_vendedor THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No puedes realizar una oferta en tu propia publicación.';
    END IF;

    -- 3. Validar que el monto pujado sea el mayor
	SELECT MAX(monto) INTO v_max_monto FROM Oferta
	WHERE id_publicacion = NEW.id_publicacion;

	IF v_max_monto IS NULL THEN
		SET v_max_monto = 0;
	END IF;

    IF NEW.monto <= v_max_monto THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El monto de la puja debe superar a la oferta máxima actual.';
    END IF;
    
END //
DELIMITER ;

/*PRUEBA*/

-- ====================================================================
-- PRUEBA 1: Error por publicación finalizada
-- ====================================================================
INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
VALUES (4, 3, 550000, NOW());


-- ====================================================================
-- PRUEBA 2: Error por intentar ofertar en una publicación propia
-- ====================================================================
INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
VALUES (5, 5, 900000, NOW());


-- ====================================================================
-- PRUEBA 3: Error por ofertar un monto menor o igual al máximo
-- ====================================================================
INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
VALUES (5, 2, 850000, NOW());


-- ====================================================================
-- PRUEBA 4: ÉXITO - Oferta válida
-- ====================================================================
INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
VALUES (5, 2, 900000, NOW());

-- Verificamos que la oferta válida se haya guardado:
SELECT * FROM Oferta WHERE id_publicacion = 5 ORDER BY monto DESC;

