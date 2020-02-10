USE `restaurante`;
DROP procedure IF EXISTS `reporte_cierre_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `reporte_cierre_caja`(
IN FECHA_INICIO DATE,
IN FECHA_FIN DATE
)
BEGIN
	select date(updated_at),SUM(monto_final_ingresado) AS total
	from historial_caja 
	
	where updated_at  BETWEEN FECHA_INICIO AND  FECHA_FIN
	GROUP BY date(created_at);
END$$

DELIMITER ;

