USE `restaurante`;
DROP procedure IF EXISTS `ver_existencia_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_existencia_almacen` (
	IN in_idinsumo INTEGER
)
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

        
    WHERE insumos.idinsumo=in_idinsumo;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;