USE `restaurante`;
DROP procedure IF EXISTS `habilitar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `habilitar_plato`(
	IN id INT(11)	
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 1, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;