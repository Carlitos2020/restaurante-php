USE `restaurante`;
DROP procedure IF EXISTS `cerrar_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `cerrar_caja`(
	IN in_monto_final_real DECIMAL(8,1)
)
BEGIN
	/*
		Procedimiento que cierra la caja actual. Actualiza el campo idactualhistorial_caja
        de la tabla caja_actual a nulo y actualiza la tabla historial_caja, los campos
        monto_final_calculado y monto_final_ingresado
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se cerró la caja correctamente
        * 2 si no estaba la caja abierta y por lo tanto no se pudo cerrar la caja
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NOT NULL THEN
		
        SET @idHistorialCaja = 0;
        SET @monto_final_calculado = 0;
        
        SELECT idactual_historial_caja, monto_actual
        FROM caja_actual 
        WHERE (idcaja = 1)
        INTO @idHistorialCaja, @monto_final_calculado;
        
        UPDATE caja_actual SET monto_actual = 0, idactual_historial_caja = NULL 
        WHERE (idcaja = 1);
        
        UPDATE historial_caja 
        SET monto_final_calculado = @monto_final_calculado, monto_final_ingresado = in_monto_final_real
        WHERE (idhistorial_caja = @idHistorialCaja);
		
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

