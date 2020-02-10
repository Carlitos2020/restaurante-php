USE `restaurante`;
DROP procedure IF EXISTS `eliminar_plato_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `eliminar_plato_insumo`(
IN `in_idplato` INTEGER,
IN `in_idinsumo` INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
   DELETE FROM platos_insumos WHERE idplato=in_idplato && idinsumo=in_idinsumo;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;