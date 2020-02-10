USE `restaurante`;
DROP procedure IF EXISTS `eliminar_insumo_proveedor`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_insumo_proveedor`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM proveedores_insumos WHERE idinsumo=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;