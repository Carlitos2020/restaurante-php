USE `restaurante`;
DROP procedure IF EXISTS `obtener_plato`;

DELIMITER $$
USE `restaurante`$$

CREATE DEFINER=`admin`@`%` PROCEDURE `obtener_plato`(
	in in_id_plato INTEGER
)
BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at,updated_at
    FROM platos
    WHERE idplato=in_id_plato LIMIT 1;
END

DELIMITER ;