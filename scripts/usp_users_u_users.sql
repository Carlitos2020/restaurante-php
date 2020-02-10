USE `restaurante`;
DROP procedure IF EXISTS `usp_users_u_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_u_users` (
	IN `pid` INT,
	IN `prol_id` INT,
	IN `pusername` VARCHAR(191),
	IN `pfirstname` VARCHAR(191),
	IN `psurname` VARCHAR(191)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			rol_id = prol_id, 
			username = pusername, 
			firstname = pfirstname, 
			surname = psurname,
			updated_at = now()
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
