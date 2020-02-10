USE `restaurante`;
DROP procedure IF EXISTS `listar_existencias_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_existencias_almacen` ()
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.cantidad_minima as minimo,
	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

    GROUP BY historial_almacen.idinsumo;
    HAVING Total >= 0;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;