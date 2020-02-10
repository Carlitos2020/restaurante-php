USE `restaurante`;
DROP procedure IF EXISTS `registrar_platos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_platos`(
	in in_nombre_plato VARCHAR(45),
	in in_precio_plato decimal(6,2)  
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO platos (nombre_plato, precio, esta_activo) 
			VALUES (in_nombre_plato, in_precio_plato,1);
            
	SET AUTOCOMMIT = 1;
END$$

DELIMITER ;
