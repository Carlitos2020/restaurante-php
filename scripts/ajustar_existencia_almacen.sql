USE `restaurante`;
DROP procedure IF EXISTS `ajustar_existencia_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ajustar_existencia_almacen`(
	IN `in_idinsumo` INT(11), 
    IN `in_cantidad` DECIMAL(8,2),
    IN `in_cantidad_ajustada` DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;

    SET @cantidad_real=in_cantidad_ajustada-in_cantidad;
    START TRANSACTION;
    
	INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad)
        VALUES (true, in_idinsumo, 18, @cantidad_real);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;