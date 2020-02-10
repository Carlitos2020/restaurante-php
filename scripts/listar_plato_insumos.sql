USE `restaurante`;
DROP procedure IF EXISTS `listar_plato_insumos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_plato_insumos`(
IN id_plato INT(11)
)
BEGIN
	SELECT
		a.idinsumo,
        b.idplato,
        b.nombre_plato,
		i.nombre_insumo,
		cantidad
	FROM platos_insumos a
	INNER JOIN platos b 
		ON a.idplato=b.idplato
	INNER JOIN insumos i
		ON a.idinsumo=i.idinsumo
    WHERE b.idplato=id_plato;
END$$

DELIMITER ;