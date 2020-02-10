USE `restaurante`;
DROP procedure IF EXISTS `usp_insumos_proveedores_s_insumos_proveedoress`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_insumos_proveedores_s_insumos_proveedoress` (
				IN in_idproveedor INTEGER
)
BEGIN
	
	SELECT insumos.nombre_insumo , insumos.cantidad_minima
		FROM proveedores INNER JOIN  proveedores_insumos 
        ON proveedores.idproveedor = proveedores_insumos.idproveedor
        INNER JOIN insumos ON insumos.idinsumo=proveedores_insumos.idinsumo
        WHERE proveedores.idproveedor=in_idproveedor;
END$$

DELIMITER ;
