USE `restaurante`;
DROP procedure IF EXISTS `usp_users_activar_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_activar_users`(
	IN `pid` INT,
	IN `pstate` TINYINT
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			state = pstate
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
