CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_enpreparacion`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='EN PREPARACION' ;
END