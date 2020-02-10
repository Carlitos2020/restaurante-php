
USE `restaurante`;
DROP procedure IF EXISTS `editar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `editar_plato`(
	IN id INT(11),
	IN nombre VARCHAR(45),
    IN precio_plato DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET nombre_plato = nombre, precio= precio_plato, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;