USE `restaurante`;
DROP procedure IF EXISTS `usp_ver_consumo_de_mesas`;

DELIMITER $$
USE `restaurante`$$

CREATE PROCEDURE `usp_ver_consumo_de_mesas` (
	IN pid_mesa INT
)
BEGIN
	SELECT  
		p.idpedido,
        p.estado,
        pl.nombre_plato,
        pl.precio,
        u.firstname,
        u.surname
    FROM pedidos as p
    INNER JOIN platos as pl ON p.idplato=pl.idplato
    INNER JOIN users as u ON u.id=p.idmozo
    WHERE p.num_mesa=pid_mesa;
    
END$$

DELIMITER ;


call usp_ver_consumo_de_mesas(3);