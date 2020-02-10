USE `restaurante`;
DROP procedure IF EXISTS `listar_pedidos_de_mesa`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_pedidos_de_mesa` (
	IN in_num_mesa INT
)
BEGIN
	IF in_num_mesa IS NULL THEN
		SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE num_mesa IS NULL;
        
    ELSE
		SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE num_mesa = in_num_mesa;
    END IF;
	
END$$

DELIMITER ;

