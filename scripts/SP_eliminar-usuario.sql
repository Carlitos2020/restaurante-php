USE `restaurante`;
DROP procedure IF EXISTS `eliminar_usuario`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_usuario` (IN in_id_usuario INTEGER)
/* Procedimiento que elimina una cuenta de usuario, verificando que el
   usuario a eliminar no sea el único usuario de tipo administrador en la bd*/
/* NOTA: SE ASUME QUE EL ROL DE ID 1 ES EL ROL ADMINISTRADOR */
/* NOTA: NO SE ESTÁ VERIFICANDO QUE EL USUARIO A ELIMINAR NO TENGA UNA
   SESION ABIERTA (i.e. que este en la tabla tiempo_real )*/
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;

	SET @ID_ADMINISTRADOR = 1;
    /* Si el usuario a eliminar es admin y solo hay un admin en la bd*/
    IF (SELECT rol_id FROM users WHERE id = in_id_usuario) = @ID_ADMINISTRADOR 
		AND (SELECT COUNT(*) FROM users WHERE rol_id = @ID_ADMINISTRADOR) <= 1
    THEN
		/* NO PUEDO ELIMINARLO */
		SELECT false AS ok, "No se puede eliminar al ultimo usuario administrador" AS result;
    ELSE
		DELETE FROM users WHERE id = in_id_usuario;
        SELECT true AS ok, "Usuario eliminado correctamente" AS result;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

