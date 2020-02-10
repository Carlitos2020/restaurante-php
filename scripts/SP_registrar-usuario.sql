USE `restaurante`;
DROP procedure IF EXISTS `registrar_usuario`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_usuario`(
    IN in_rol_id INTEGER,
    IN in_username VARCHAR(191),
    IN in_password VARCHAR(191),
    IN in_firstname VARCHAR(191),
    IN in_surname VARCHAR(191),
    IN in_email VARCHAR(191),
    IN in_api_token VARCHAR(80)
)
BEGIN
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    SET @DEFAULT_STATE = 0; /* Valor por defecto de estado para el nuevo usuario*/
    
    /* El procedimiento primero verifica que haya un rol con el id dado de parametro*/
    IF EXISTS(SELECT * FROM roles WHERE in_rol_id = rol_id) THEN
        INSERT INTO users (rol_id, username, password, firstname, surname, email, state, api_token) 
        VALUES (in_rol_id, in_username, in_password, in_firstname, in_surname, in_email, @DEFAULT_STATE, in_api_token);
        
        SELECT true AS ok, "Usuario registrado" AS result;
    ELSE
        SELECT false AS ok, "No existe ese rol" AS result;
    END IF;
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


