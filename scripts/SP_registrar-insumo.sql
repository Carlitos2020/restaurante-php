USE `restaurante`;
DROP procedure IF EXISTS `registrar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_insumo` (
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

