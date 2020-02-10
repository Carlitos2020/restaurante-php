USE `restaurante`;
DROP procedure IF EXISTS `registrar_pago_de_mesa`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_pago_de_mesa`(
	IN in_num_mesa INTEGER,
    IN in_idcajero INTEGER
)
BEGIN
	/*
		Procedimiento que registra el pago de una mesa. El procedimiento
        registra una nueva operación de caja, elimina los pedidos de la tabla
        pedidos e inserta los pedidos pagados en la tabla historial_pedidos
        
        EL PROCEDIMIENTO RETORNA:
        * 1 Si el pago se registró correctamente
        * 2 Si la mesa no contiene ningun pedido y por lo tanto no ha nada que pagar
        * 3 Si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
    
    SET autocommit = 0;
    START TRANSACTION;
    
	SET @esta_cajero_habilitado = true;
    SET @existen_pedidos = true;
    SET @esta_caja_abierta = true;
    
    IF !EXISTS(SELECT * FROM pedidos WHERE num_mesa = in_num_mesa) THEN
		SET @existen_pedidos = false;
		SELECT 2 AS resultado;
    END IF;
    
    IF  in_idcajero IS NULL
		OR NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idcajero AND state = 1
            ) THEN
		SET @esta_cajero_habilitado = false;
		SELECT 3 AS resultado;
    END IF;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		SET @esta_caja_abierta = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @existen_pedidos AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		/* Primero calculo el monto del consumo */
        SET @monto_consumo = 0.0;
        
        SELECT SUM(pl.precio) 
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa
        INTO @monto_consumo;
        
        SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        /* Registro el pago del consumo de la mesa en operaciones_caja y actualizo el monto de la caja*/
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, @monto_consumo, 
				CONCAT("Pago por consumo de la mesa ", in_num_mesa), in_idcajero);
		UPDATE caja_actual SET monto_actual = monto_actual + @monto_consumo
        WHERE (idcaja = 1);
        
        /* Guardo los pedidos en el historial de pedidos*/
        INSERT INTO historial_pedidos (idplato, idmozo, monto)
        SELECT pe.idplato, pe.idmozo, pl.precio
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa;
        
        /* Elimino los pedidos de esa mesa */
        DELETE FROM pedidos 
        WHERE (num_mesa = in_num_mesa);
    
		SELECT 1 as resultado;
    END IF;
    SET autocommit = 1;
END$$

DELIMITER ;

