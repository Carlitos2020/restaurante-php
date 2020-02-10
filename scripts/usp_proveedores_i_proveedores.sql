USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_i_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_i_proveedores` (
	IN in_nombre_proveedor VARCHAR(50),
	IN in_direccion_proveedor VARCHAR(50),
	IN in_descripcion VARCHAR(120)
)
BEGIN
	
    DECLARE in_fecha TIMESTAMP;
	SET in_fecha=now();
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO proveedores (nombre_proveedor, direccion_proveedor,
				descripcion, created_at, updated_at) 
			VALUES (in_nombre_proveedor, in_direccion_proveedor,	in_descripcion, in_fecha, in_fecha);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
