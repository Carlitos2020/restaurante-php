USE `restaurante`;
DROP procedure IF EXISTS `deshabilitar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `deshabilitar_plato` (
	IN id INT(11)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 0, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;