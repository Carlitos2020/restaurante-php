USE `restaurante`;
DROP procedure IF EXISTS `eliminar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_plato` (
IN id INTEGER
)
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM platos WHERE idplato=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;