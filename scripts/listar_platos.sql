USE `restaurante`;
DROP procedure IF EXISTS `listar_platos`;

DELIMITER $$
USE `restaurante`$$

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_platos`()
BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at
    FROM platos;
END
DELIMITER ;