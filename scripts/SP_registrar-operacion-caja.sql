USE `restaurante`;
DROP procedure IF EXISTS `registrar_operacion_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_operacion_caja`(
	IN in_monto DECIMAL(8,2),
    IN in_descripcion TEXT,
    IN in_idcajero INTEGER
)
BEGIN
	/*
		Procedimiento que registra una operacion de caja en el actual historial
        de caja.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se registró la operacion de la caja correctamente
        * 2 si el monto es 0 y por lo tanto no tiene sentido registrar la operacion
        * 3 si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @esta_cajero_habilitado = true;
    SET @es_monto_valido = true;
    SET @esta_caja_abierta = true;
    
    IF in_monto = 0 THEN
		SET @es_monto_valido = false;
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
    
    IF @es_monto_valido AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        UPDATE caja_actual SET monto_actual = monto_actual + in_monto
        WHERE (idcaja = 1);
        
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, in_monto, in_descripcion, in_idcajero);
        
		SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

