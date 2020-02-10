USE `restaurante`;
DROP procedure IF EXISTS `listar_salidas_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_salidas_almacen`()
BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad, h.created_at AS fecha
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad <= 0 AND es_ajuste = 0;
END$$

DELIMITER ;