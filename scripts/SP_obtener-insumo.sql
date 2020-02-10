
USE `restaurante`;
DROP procedure IF EXISTS `restaurante`.`obtener_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `obtener_insumo`(in in_idinsumo INTEGER)
BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
	FROM insumos
    WHERE idinsumo = in_idinsumo LIMIT 1;
END$$

DELIMITER ;
;