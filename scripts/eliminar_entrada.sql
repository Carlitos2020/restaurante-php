USE `restaurante`;
DROP procedure IF EXISTS `eliminar_entrada`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_entrada`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM historial_almacen WHERE idhistorial_almacen=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;