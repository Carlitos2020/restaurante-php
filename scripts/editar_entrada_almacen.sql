USE `restaurante`;
DROP procedure IF EXISTS `editar_entrada_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `editar_entrada_almacen`(
	IN `in_idhistorial_almacen` INT(11), 
    IN `in_cantidad` DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE historial_almacen 
		SET cantidad = in_cantidad
		WHERE (idhistorial_almacen = in_idhistorial_almacen);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;