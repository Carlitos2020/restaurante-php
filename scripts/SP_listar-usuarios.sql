USE `restaurante`;
DROP procedure IF EXISTS `listar_usuarios`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_usuarios` ()
BEGIN
	SELECT id, rol_id, username, firstname, 
		   surname, email, state, created_at, updated_at
	FROM users;
END$$

DELIMITER ;