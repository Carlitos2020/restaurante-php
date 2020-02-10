CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_platos_no_necesitanprepacion`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PENDIENTE' && platos.necesita_preparacion=0;
END