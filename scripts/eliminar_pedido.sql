REATE DEFINER=`admin`@`%` PROCEDURE `eliminar_pedido`(
IN in_id_pedido INT(11)
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    /* Aumenta los insumos del almacen no utilizados*/
        UPDATE almacen AS a INNER JOIN platos_insumos AS p ON a.idinsumo = p.idinsumo
        INNER JOIN pedidos AS ped ON ped.idplato = p.idplato
        SET a.cantidad = a.cantidad + p.cantidad
		WHERE (ped.idpedido=in_id_pedido);
	/* Elimina el pedido */
    DELETE FROM pedidos WHERE (idpedido=in_id_pedido)&&(estado='PENDIENTE');
    SET AUTOCOMMIT = 1;
END