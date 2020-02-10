DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_roles_s_roless`$$

CREATE PROCEDURE `usp_roles_s_roless`
()
BEGIN
	SELECT * FROM roles;
END $$ DELIMITER ;