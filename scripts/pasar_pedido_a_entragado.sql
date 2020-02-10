USE `restaurante`;
DROP procedure IF EXISTS `pasar_pedido_a_entregado`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `pasar_pedido_a_entregado` (
	IN in_idPedido INTEGER
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE pedidos 
    SET estado = 'ENTREGADO', updated_at = now()
    WHERE (idpedido = in_idPedido);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

