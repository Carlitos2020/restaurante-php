USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_s_proveedoress`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_s_proveedoress` ()
BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores;
END$$

DELIMITER ;
