USE `restaurante`;
DROP procedure IF EXISTS `ver_insumos`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_insumos` ()
BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
		FROM insumos;
END$$

DELIMITER ;
