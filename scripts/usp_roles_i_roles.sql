DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_roles_i_roles`$$

CREATE PROCEDURE `usp_roles_i_roles`
(
	IN pname varchar(45)
)
BEGIN
	BEGIN TRY
		INSERT INTO roles(nombre_rol) values (pname);
		select rol_id FROM roles where nombre_rol=pname;
	END TRY
END $$ DELIMITER ;

