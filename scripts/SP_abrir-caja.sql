USE `restaurante`;
DROP procedure IF EXISTS `abrir_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `abrir_caja`(
	IN in_monto_inicial DECIMAL(8, 2)
)
BEGIN
	/*
		Procedimiento que abre la caja del restaurante con un monto inicial.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se abrio la caja correctamente
        * 2 si la caja ya estaba abierta, y por lo tanto no se puede abrir una nueva caja
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		INSERT INTO historial_caja (monto_inicial) VALUES (in_monto_inicial);
		SET @idHistorialCaja = LAST_INSERT_ID();
		
		UPDATE caja_actual 
		SET idactual_historial_caja = @idHistorialCaja, monto_actual = in_monto_inicial
		WHERE (idcaja = 1);
        
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

