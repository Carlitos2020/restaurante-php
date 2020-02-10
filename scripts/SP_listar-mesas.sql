USE `restaurante`;
DROP procedure IF EXISTS `listar_mesas`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_mesas` ()
BEGIN
	SELECT num_mesa, esta_activa FROM mesas;
END$$

DELIMITER ;