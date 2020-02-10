USE `restaurante`;
DROP procedure IF EXISTS `reporte_platos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `reporte_platos`(
IN FECHA_INICIO DATE,
IN FECHA_FIN DATE
)
BEGIN
	select p.nombre_plato,SUM(monto) AS total
	from historial_pedidos h 
	INNER JOIN platos p ON h.idplato=p.idplato
	where h.created_at  BETWEEN FECHA_INICIO AND  FECHA_FIN
	GROUP BY p.nombre_plato;
END$$

DELIMITER ;

