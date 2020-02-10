USE `restaurante`;
DROP procedure IF EXISTS `ver_estadisticas`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_estadisticas` (
	IN in_fecha VARCHAR(12)
)
BEGIN
	SELECT hora, cantidad
	FROM (
		SELECT hour(created_at) AS hora, count(*) AS cantidad
		FROM historial_pedidos
		where date_format(created_at, '%Y-%b-%d')=in_fecha
		GROUP BY hour(created_at)
	
	) as t
    
	ORDER BY hora;
END$$

DELIMITER ;
