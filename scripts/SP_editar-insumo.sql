USE `restaurante`;
DROP procedure IF EXISTS `editar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `editar_insumo` (
	IN in_id_insumo INT(11),
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE insumos 
		SET nombre_insumo = in_nombre_insumo, cantidad_minima = in_cantidad_minima, updated_at = now()
		WHERE (idinsumo = in_id_insumo);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


    