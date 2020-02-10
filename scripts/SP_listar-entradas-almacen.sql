USE `restaurante`;
DROP procedure IF EXISTS `listar_entradas_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_entradas_almacen` ()
BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad 
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad >= 0 AND es_ajuste = 0;
END$$

DELIMITER ;
