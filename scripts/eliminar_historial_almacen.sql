USE `restaurante`;
DROP procedure IF EXISTS `eliminar_historial_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_historial_almacen` (IN in_idhistorial_almacen INTEGER)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @idInsumo = 0;
    SET @cantidadHistorial = 0;
    
    SELECT idinsumo, cantidad FROM historial_almacen 
    WHERE idhistorial_almacen = in_idhistorial_almacen
    INTO @idInsumo, @cantidadHistorial;
    
    UPDATE almacen SET cantidad = cantidad - @cantidadHistorial
    WHERE (idinsumo = @idInsumo);
    
	DELETE FROM historial_almacen
    WHERE (idhistorial_almacen = in_idhistorial_almacen);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

