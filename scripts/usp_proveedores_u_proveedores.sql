USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_u_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_u_proveedores` (
	IN in_idproveedor INTEGER,
	IN in_nombre_proveedor VARCHAR(50),
	IN in_direccion_proveedor VARCHAR(50),
	IN in_descripcion VARCHAR(120)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE proveedores 
		SET nombre_proveedor = in_nombre_proveedor, direccion_proveedor = in_direccion_proveedor, descripcion=in_descripcion, updated_at = now()
		WHERE (idproveedor = in_idproveedor);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


    