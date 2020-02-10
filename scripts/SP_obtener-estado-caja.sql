USE `restaurante`;
DROP procedure IF EXISTS `obtener_estado_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `obtener_estado_caja` ()
BEGIN
	SELECT monto_actual, (idactual_historial_caja IS NOT NULL) AS esta_abierta
    FROM caja_actual;
END$$

DELIMITER ;

