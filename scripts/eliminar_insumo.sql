USE `restaurante`;
DROP procedure IF EXISTS `eliminar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_insumo`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM insumos WHERE idinsumo=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;