USE `restaurante`;
DROP procedure IF EXISTS `reporte_ventas`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `reporte_ventas`(
IN FECHA_INICIO DATE,
IN FECHA_FIN DATE
)
BEGIN
	SELECT DATE_FORMAT(created_at, '%Y-%m-%d') AS fecha, SUM(monto_final_ingresado) AS "monto_total"
	FROM historial_caja
	where created_at  BETWEEN FECHA_INICIO AND  FECHA_FIN
	GROUP BY (fecha);
END$$

DELIMITER ;