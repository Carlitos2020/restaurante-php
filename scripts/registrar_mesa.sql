USE `restaurante`;
DROP procedure IF EXISTS `registrar_mesa`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_mesa`(
	in in_numero_mesa INTEGER  
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO mesas (num_mesa, esta_activo) 
			VALUES (in_numero_mesa,1);
            
	SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
