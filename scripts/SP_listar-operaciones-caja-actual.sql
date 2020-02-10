USE `restaurante`;
DROP procedure IF EXISTS `listar_operaciones_de_caja_actual`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_operaciones_de_caja_actual` ()
BEGIN
	SELECT idoperaciones_caja, monto, descripcion, created_at 
    FROM operaciones_caja
    WHERE idhistorial_caja = (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1)
    ORDER BY created_at ASC;
END$$

DELIMITER ;

