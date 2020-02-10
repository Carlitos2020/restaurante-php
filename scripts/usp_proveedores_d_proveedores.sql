
USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_d_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_d_proveedores` (
	IN in_idproveedor INTEGER
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM proveedores WHERE idproveedor=in_idproveedor;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
