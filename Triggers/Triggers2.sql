use stock;

/*1*/
delimiter //
CREATE TRIGGER AI_pedido_producto AFTER INSERT ON pedido_producto FOR EACH ROW
BEGIN
    UPDATE ingresostock_producto
    SET cantidad = cantidad - new.cantidad
    WHERE Producto_codProducto = new.Producto_codProducto;
END //
delimiter ;


/*3*/
delimiter //
CREATE PROCEDURE actualizar_categoria(IN p_codCliente VARCHAR(20))
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(pp.cantidad * pp.precioUnitario)
    INTO total
    FROM pedido_producto pp
    JOIN pedido p ON pp.Pedido_idPedido = p.idPedido
    WHERE p.Cliente_codCliente = p_codCliente
      AND p.fecha >= DATE_SUB(NOW(), INTERVAL 2 YEAR);

	IF total IS NULL THEN
		SET total = 0;
	END IF;

    UPDATE cliente
    SET categoria = CASE
        WHEN total <= 50000 THEN 'bronce'
        WHEN total <= 100000 THEN 'plata'
        ELSE 'oro'
    END
    WHERE codCliente = p_codCliente;
END //


CREATE TRIGGER AI_pedido AFTER INSERT ON pedido FOR EACH ROW
BEGIN
    CALL actualizar_categoria(new.Cliente_codCliente);
END //

delimiter ;


/*5*/
