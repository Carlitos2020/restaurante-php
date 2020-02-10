USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_s_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_s_proveedores` (
				IN in_idproveedor INTEGER
)
BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores WHERE idproveedor=in_idproveedor;
END$$

DELIMITER ;
