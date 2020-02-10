USE `restaurante`;
DROP procedure IF EXISTS `ver_entrada_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_entrada_almacen` (
	IN in_idhist INTEGER
)
BEGIN
	SELECT  
		idhistorial_almacen, 
		i.idinsumo AS idinsumo, 
		i.nombre_insumo	AS nombre_insumo, 
		cantidad 
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE idhistorial_almacen=in_idhist AND cantidad >= 0 AND es_ajuste = 0;
END$$

DELIMITER ;
