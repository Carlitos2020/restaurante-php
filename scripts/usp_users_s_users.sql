USE `restaurante`;
DROP procedure IF EXISTS `usp_users_s_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_s_users`(
	IN `pid` INT
)
BEGIN

    SELECT 
    username,
    firstname,
    surname,
    rol_id
    FROM users WHERE id = pid;
    
END$$

DELIMITER ;
