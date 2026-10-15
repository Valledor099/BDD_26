

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
 
-- 5.
DELIMITER //
CREATE PROCEDURE  calificarUsuarios(IN p_idVenta INT, IN p_idCalificador INT, IN p_idCalificado INT, IN p_puntaje INT, IN p_comentario TEXT)
BEGIN 
	DECLARE idComprador INT;
    DECLARE idVendedor INT;
    
    IF p_puntaje < 1 OR p_puntaje > 100 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificacion es del 1 al 100';
    END IF;
    
    SELECT v.id_comprador, pu.id_vendedor INTO idComprador, idVendedor FROM Venta v 	
    JOIN Publicacion pu ON v.id_publicacion = pu.id_publicacion
    WHERE v.id_venta = p_idVenta;
    
	IF idComprador IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La compra no existe';
    END IF;
    
    IF p_idCalificador NOT IN (idComprador, idVendedor) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario al que se quiere calificar no esta en esta transaccion';
    END IF;
    
    IF p_idCalificado NOT IN (idComprador, idVendedor) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario al que se quiere calificar no esta en esta transaccion';
    END IF;
    
    IF p_idCalificador = p_idCalificado THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un usuario no se puede calificar a si mismo';
    END IF;
    
    IF (SELECT 1 FROM Calificacion
        WHERE id_venta = p_idVenta AND id_calificador = p_idCalificador AND id_usuario_evaluado = p_idCalificado) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una calificacion en esta transaccion para este usuario';
    END IF;
    
    INSERT INTO Calificacion (id_venta, id_calificador, id_usuario_evaluado, puntaje, comentario, fecha_calificacion)
    VALUES (p_idVenta, p_idCalificador, p_idCalificado, p_puntaje, p_comentario, NOW());
END //
DELIMITER ;
 
CALL calificarUsuarios(1, 1, 2, 5, 'Excelente vendedor, todo perfecto');
CALL calificarUsuarios(999, 1, 2, 5, 'aaaaa');
CALL calificarUsuarios(1,5,2,5, 'aaaaaaaa');
CALL calificarUsuarios(1,1,7,5, 'aaaa');
CALL calificarUsuarios(1,1,1,5,'aaa');
 
 
-- 6.
DELIMITER //
CREATE PROCEDURE ganadorSubasta (IN p_idPublicacion INT)
BEGIN
	DECLARE mayorOferta FLOAT;
    
    SET mayorOferta = fn_mayor_oferta(p_idPublicacion);
    
    IF mayorOferta = -1 THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion no existe o no es subasta';
    END IF;
    
    IF mayorOferta = 0 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La subasta no tiene ofertas';
    END IF;
    
    SELECT u.id_usuario, u.nombre AS nombre_usuario, u.apellido AS apellido_usuario, u.email, pr.nombre AS nombre_producto, 
    (SELECT COUNT(DISTINCT o2.id_usuario) FROM Oferta o2 WHERE o2.id_publicacion = p_idPublicacion) AS cantidad_ofertantes, pu.precio AS valor_inicial, o.monto AS valor_ganador FROM Oferta o
	JOIN Usuarios u ON o.id_usuario = u.id_usuario
	JOIN Publicacion pu ON o.id_publicacion = pu.id_publicacion
	JOIN Producto pr ON pu.id_producto = pr.id_producto
	WHERE o.id_publicacion = p_idPublicacion 
	AND o.monto = mayorOferta 
	ORDER BY o.fecha_oferta ASC
	LIMIT 1;
END //
DELIMITER ;
 

CALL ganadorSubasta(5);
CALL ganadorSubasta(1);
 
-- 7.
DELIMITER //
CREATE PROCEDURE crearPregunta (IN p_idPublicacion INT, IN p_idUsuario INT, IN p_pregunta TEXT)
BEGIN
	DECLARE idVendedor INT;
    DECLARE nombreEstado TEXT;
    
    SELECT pu.id_vendedor, e.nombre INTO idVendedor, nombreEstado FROM Publicacion pu 
    JOIN Estado e ON pu.id_estado = e.id_estado
    WHERE pu.id_publicacion = p_idPublicacion;
    
	IF idVendedor IS NULL THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion no existe';
    END IF;
    
    IF nombreEstado != 'Activa' THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicacion no esta activa';
    END IF;
    
	IF p_pregunta IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pregunta no puede estar vacia';
    END IF;
    
    IF p_idUsuario = idVendedor THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dueño de la publicacion no puede hacer prguntas dentro de su misma publicacion';
    END IF;
    
    INSERT INTO Preguntas_Respuestas (id_publicacion, id_usuario, pregunta, respuesta, fecha_pregunta, fecha_respuesta)
    VALUES (p_idPublicacion, p_idUsuario, p_pregunta, NULL, NOW(), NULL);
END //
DELIMITER ;

CALL crearPregunta(5,4, 'Tiene garantia?');
CALL crearPregunta(5,5,'aa');
CALL crearPregunta(1,2,'aa');
 
 
-- 8.
DELIMITER //
CREATE PROCEDURE estadisticasVendedor (IN p_idVendedor INT)
BEGIN 
	DECLARE existeVendedor INT DEFAULT 0;
    
    SELECT COUNT(*) INTO existeVendedor FROM Usuarios
	WHERE id_usuario = p_idVendedor;
    
    IF existeVendedor = 0 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    SELECT p_idVendedor AS id_vendedor,
	(SELECT COUNT(*) FROM Publicacion pu
		JOIN Estado e ON pu.id_estado = e.id_estado
		WHERE pu.id_vendedor = p_idVendedor AND e.nombre = 'Activa') AS publicaciones_activas,
    (SELECT COUNT(*) FROM Publicacion pu
		JOIN Estado e ON pu.id_estado = e.id_estado
		WHERE pu.id_vendedor = p_idVendedor AND e.nombre = 'Finalizada') AS publicaciones_finalizadas,
	(SELECT COUNT(*) FROM Venta v
		JOIN Publicacion pu ON v.id_publicacion = pu.id_publicacion
        WHERE pu.id_vendedor = p_idVendedor) AS ventas_totales,
	(SELECT COALESCE(SUM(v.monto), 0) FROM Venta v
		JOIN Publicacion pu ON v.id_publicacion = pu.id_publicacion
		WHERE pu.id_vendedor = p_idVendedor) AS facturacion_total,
    (SELECT AVG(pu.precio) FROM Publicacion pu
		WHERE pu.id_vendedor = p_idVendedor) AS precio_promedio,
    (SELECT COUNT(*) FROM Preguntas_Respuestas pr 
		JOIN Publicacion pu ON pr.id_publicacion = pu.id_publicacion
        WHERE pu.id_vendedor = p_idVendedor) AS preguntas_recibidas,
	(SELECT AVG(TIMESTAMPDIFF(DAY, pu.fecha_publicacion, v.fecha_venta)) FROM Venta v
		JOIN Publicacion pu ON v.id_publicacion = pu.id_publicacion
		WHERE pu.id_vendedor = p_idVendedor) AS dias_promedio;
END //
DELIMITER ;
 

CALL estadisticasVendedor(3);
 

 
-- 9.
DELIMITER //
CREATE PROCEDURE topVendedores (IN p_fechaInicial DATETIME, IN p_fechaFinal DATETIME)
BEGIN 
	IF p_fechaInicial > p_fechaFinal THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha inicial no puede ser mayo a l fecha final';
    END IF;
    
    SELECT u.id_usuario, u.nombre, u.apellido, u.email, COUNT(v.id_venta) AS cantidad_ventas FROM Venta v 
    JOIN Publicacion pu ON v.id_publicacion = pu.id_publicacion
    JOIN Usuarios u ON pu.id_vendedor = u.id_usuario
    WHERE v.fecha_venta BETWEEN p_fechaInicial AND p_fechaFinal
    GROUP BY u.id_usuario, u.nombre, u.apellido, u.email
    ORDER BY cantidad_ventas DESC
    LIMIT 10;
END //
DELIMITER ;
 
CALL topVendedores ('2026-04-01', '2026-04-30');
 
/*--------------------VIEWS--------------------------*/
/*1*/

CREATE VIEW vw_preguntas_sin_respuesta AS
SELECT pr.id_pregunta,pr.pregunta AS descripcion,p.id_publicacion,prod.nombre AS nombre_producto,u.nombre AS nombre_vendedor FROM Preguntas_Respuestas pr
JOIN Publicacion p ON pr.id_publicacion = p.id_publicacion
JOIN Producto prod ON p.id_producto = prod.id_producto
JOIN Usuarios u ON p.id_vendedor = u.id_usuario
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

/*---------------------------------Eventos-------------------------------*/
/*1*/

DELIMITER //
CREATE EVENT ev_eliminar_publicaciones_pausadas ON SCHEDULE EVERY 1 WEEK STARTS now() DO
BEGIN
    DELETE FROM Publicacion
    WHERE id_estado = 3 AND fecha_publicacion < DATE_SUB(NOW(), INTERVAL 90 DAY);

END //
DELIMITER ;

/*2*/


DELIMITER //
CREATE EVENT ev_observar_publicaciones_sin_pago ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP DO
BEGIN

    UPDATE Publicacion p
    SET p.id_estado = 4
    WHERE p.id_estado = 1 AND p.id_tipo_publicacion = 1
	AND NOT EXISTS (
          SELECT 1
          FROM Publicacion_MedioPago pm
          WHERE pm.id_publicacion = p.id_publicacion);

END //
DELIMITER ;

/*3*/

DELIMITER //
CREATE EVENT ev_notificar_preguntas_sin_responder ON SCHEDULE EVERY 1 DAY STARTS '2026-08-21 10:00:00' DO
BEGIN

    INSERT INTO Notificacion (id_usuario, mensaje, fecha)
    SELECT p.id_vendedor,CONCAT('La publicación sobre ',p.titulo,' tiene ',COUNT(pr.id_pregunta),' preguntas sin responder'),NOW() FROM Publicacion p
    JOIN Preguntas_Respuestas pr ON p.id_publicacion = pr.id_publicacion
    WHERE p.id_estado = 1 AND pr.respuesta IS NULL
    GROUP BY p.id_publicacion, p.id_vendedor, p.titulo;

END //
DELIMITER ;


/*4*/

DELIMITER //
CREATE EVENT ev_estadisticas_diarias ON SCHEDULE EVERY 1 DAY STARTS '2026-08-21 00:00:00' DO
BEGIN

    INSERT INTO Estadistica_Diaria(fecha,cantidad_vendedores,cantidad_compradores,cantidad_productos,cantidad_ventas,facturacion_total)
    SELECT
        CURDATE(),(SELECT COUNT(DISTINCT id_vendedor) FROM Publicacion),(SELECT COUNT(DISTINCT id_comprador)FROM Venta),
        (SELECT COUNT(*) FROM Producto),
        (SELECT COUNT(*) FROM Venta),
        (SELECT COALESCE(SUM(monto), 0) FROM Venta);

END //
DELIMITER ;

/*----------------------Indices---------------------------------------*/

/*1*/
CREATE INDEX idx_producto_nombre ON Producto(nombre);

/*2 No necesitamos realizar un indice ya que en la tabla usuarios establecimos que el email debe ser unique*/

/*3*/
CREATE INDEX idx_publicacion_estado ON Publicacion(id_estado);

/*--------------------Transacciones---------------------------------*/
/*1*/
DELIMITER $$

CREATE PROCEDURE sp_ComprarPublicacion(IN p_id_publicacion INT, IN p_id_comprador INT, IN p_id_medio_pago INT,IN p_id_medio_envio INT,OUT p_resultado VARCHAR(150))
BEGIN
    DECLARE v_estado INT;
    DECLARE v_estado_finalizada INT;
    DECLARE v_precio FLOAT;
    DECLARE v_id_vendedor INT;
    DECLARE v_medio_valido INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_resultado = 'Error: ocurrió un problema al procesar la compra';
    END;

    START TRANSACTION;

    SELECT id_estado, precio, id_vendedor INTO v_estado, v_precio, v_id_vendedor FROM Publicacion
    WHERE id_publicacion = p_id_publicacion FOR UPDATE;

    IF v_estado IS NULL THEN
        ROLLBACK;
        SET p_resultado = 'Error: la publicación no existe';
    ELSE
        SELECT id_estado INTO v_estado_finalizada FROM Estado
        WHERE nombre = 'Finalizada';

        SELECT COUNT(*) INTO v_medio_valido FROM Publicacion_MedioPago
        WHERE id_publicacion = p_id_publicacion AND id_medio_pago = p_id_medio_pago;

        IF v_estado = v_estado_finalizada THEN
            ROLLBACK;
            SET p_resultado = 'Error: la publicación ya fue vendida';

        ELSEIF v_medio_valido = 0 THEN
            ROLLBACK;
            SET p_resultado = 'Error: el medio de pago no está habilitado para esta publicación';

        ELSEIF p_id_comprador = v_id_vendedor THEN
            ROLLBACK;
            SET p_resultado = 'Error: el vendedor no puede comprar su propia publicación';

        ELSE
            INSERT INTO Venta (id_publicacion, id_comprador, id_medio_pago, id_medio_envio, fecha_venta, monto)
            VALUES (p_id_publicacion, p_id_comprador, p_id_medio_pago, p_id_medio_envio, NOW(), v_precio);

            UPDATE Publicacion
            SET id_estado = v_estado_finalizada
            WHERE id_publicacion = p_id_publicacion;

            COMMIT;
            SET p_resultado = 'Compra realizada correctamente';
        END IF;
    END IF;
END$$
DELIMITER ;



/*2*/
DELIMITER $$

CREATE PROCEDURE sp_OfertarSubasta(IN p_id_publicacion INT,IN p_id_usuario INT,IN p_monto DECIMAL(12,2),OUT p_resultado VARCHAR(150))
BEGIN
    DECLARE v_tipo INT;
    DECLARE v_tipo_subasta INT;
    DECLARE v_estado INT;
    DECLARE v_estado_finalizada INT;
    DECLARE v_precio FLOAT;
    DECLARE v_id_vendedor INT;
    DECLARE v_monto_actual DECIMAL(12,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'Error: ocurrió un problema al procesar la oferta';
    END;

    START TRANSACTION;

    SELECT id_tipo_publicacion, id_estado, precio, id_vendedor INTO v_tipo, v_estado, v_precio, v_id_vendedor FROM Publicacion
    WHERE id_publicacion = p_id_publicacion
    FOR UPDATE;

    IF v_estado IS NULL THEN
        ROLLBACK;
        SET p_resultado = 'Error: la publicación no existe';
    ELSE
        SELECT id_tipoPublicacion INTO v_tipo_subasta FROM TipoPublicacion
        WHERE nombre = 'Subasta';

        SELECT id_estado INTO v_estado_finalizada
        FROM Estado WHERE nombre = 'Finalizada';

        SELECT COALESCE(MAX(monto), v_precio) INTO v_monto_actual FROM Oferta
        WHERE id_publicacion = p_id_publicacion
        FOR UPDATE;

        IF v_tipo <> v_tipo_subasta THEN
            ROLLBACK;
            SET p_resultado = 'Error: la publicación no es una subasta';

        ELSEIF v_estado = v_estado_finalizada THEN
            ROLLBACK;
            SET p_resultado = 'Error: la subasta ya está finalizada';

        ELSEIF p_id_usuario = v_id_vendedor THEN
            ROLLBACK;
            SET p_resultado = 'Error: el vendedor no puede ofertar en su propia publicación';

        ELSEIF p_monto <= v_monto_actual THEN
            ROLLBACK;
            SET p_resultado = 'Error: el monto debe superar la oferta actual';

        ELSE
            INSERT INTO Oferta (id_publicacion, id_usuario, monto, fecha_oferta)
            VALUES (p_id_publicacion, p_id_usuario, p_monto, NOW());

            COMMIT;
            SET p_resultado = 'Oferta registrada correctamente';
        END IF;
    END IF;
END$$
DELIMITER ;

/*3*/
DELIMITER $$
CREATE PROCEDURE sp_CalificarVenta(IN p_id_venta INT,IN p_id_calificador INT,IN p_id_usuario_evaluado INT,IN p_puntaje INT,IN p_comentario TEXT,OUT p_resultado VARCHAR(150))
BEGIN
    DECLARE v_existe_venta INT;
    DECLARE v_participo INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'Error: ocurrió un problema al registrar la calificación';
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existe_venta FROM Venta
    WHERE id_venta = p_id_venta FOR UPDATE;

    IF v_existe_venta = 0 THEN
        ROLLBACK;
        SET p_resultado = 'Error: la venta no existe';
    ELSE
        SELECT COUNT(*) INTO v_participo FROM Venta v
        JOIN Publicacion pub ON pub.id_publicacion = v.id_publicacion
        WHERE v.id_venta = p_id_venta AND (v.id_comprador = p_id_calificador OR pub.id_vendedor = p_id_calificador);

        IF p_puntaje < 1 OR p_puntaje > 100 THEN
            ROLLBACK;
            SET p_resultado = 'Error: el puntaje debe estar entre 1 y 100';

        ELSEIF v_participo = 0 THEN
            ROLLBACK;
            SET p_resultado = 'Error: el usuario no participó de esta transacción';

        ELSE
            INSERT INTO Calificacion (id_venta, id_usuario_evaluado, id_calificador, puntaje, comentario, fecha_calificacion)
            VALUES (p_id_venta, p_id_usuario_evaluado, p_id_calificador, p_puntaje, p_comentario, NOW());

            COMMIT;
            SET p_resultado = 'Calificación registrada correctamente';
        END IF;
    END IF;
END$$
DELIMITER ;

/*----------------------------ROLES y ACCESO----------------------*/


CREATE ROLE IF NOT EXISTS 'rol_auditor';
GRANT SELECT ON E_commerce_TP.vw_preguntas_sin_respuesta TO 'rol_auditor';
GRANT SELECT ON E_commerce_TP.vw_top_10_categorias_semana TO 'rol_auditor';
GRANT SELECT ON E_commerce_TP.vw_publicaciones_tendencia_hoy TO 'rol_auditor';
GRANT SELECT ON E_commerce_TP.vw_mejor_vendedor_categoria TO 'rol_auditor';

CREATE ROLE IF NOT EXISTS 'rol_desarrollador';
GRANT SELECT ON E_commerce_TP.* TO 'rol_desarrollador';
GRANT CREATE ROUTINE ON E_commerce_TP.* TO 'rol_desarrollador';
GRANT ALTER ROUTINE ON E_commerce_TP.* TO 'rol_desarrollador';
GRANT EXECUTE ON E_commerce_TP.* TO 'rol_desarrollador';

CREATE ROLE IF NOT EXISTS 'rol_admin';
GRANT ALL PRIVILEGES ON E_commerce_TP.* TO 'rol_admin';

