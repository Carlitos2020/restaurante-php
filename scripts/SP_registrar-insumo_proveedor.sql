USE `restaurante`;
DROP procedure IF EXISTS `registrar_insumo_proveedor`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_insumo_proveedor` (
	IN in_id_proveedor INTEGER
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    SET A=0;
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    A= SELECT LAST_INSERT_ID()

    INSERT INTO proveedores_insumos(idproveedor, idinsumo)
	VALUES (in_id_proveedor, A);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

