CREATE DEFINER=`admin`@`%` PROCEDURE `editar_pedido`(
	IN in_id_pedido INT(11),
	IN in_idPlato INTEGER,
    IN in_num_mesa INTEGER,
    IN in_idMozo INTEGER
)
BEGIN
	/*
		Procedimiento que edita un pedido de una mesa
        Los valores numMesa e idMozo pueden ser nulos (en caso de 
        que el pedido sea para llevar por ejemplo).

        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se edito el pedido correctamente
        * 2 si el plato no existe o está deshabilitado
        * 3 si la mesa no existe o está deshabilitada
        * 4 si el mozo no existe o está deshabilitado
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @existe_plato = true;
    SET @existe_mesa = true;
    SET @existe_mozo = true;
    
    /* Verfica que exista el plato y este habilitado */
    IF  in_idPlato IS null 
		OR NOT EXISTS(
			SELECT * FROM platos 
            WHERE idplato = in_idPlato AND esta_activo = 1
            ) THEN
		SET @existe_plato = false;
		SELECT 2 AS resultado;
    END IF;
    
    /* Verfica que exista la mesa y este habilitada */
    IF in_num_mesa IS NOT NULL 
		AND NOT EXISTS(
			SELECT * FROM mesas 
            WHERE in_num_mesa = num_mesa AND esta_activa = 1
            ) THEN
		SET @existe_mesa = false;
		SELECT 3 AS resultado;
    END IF;
    
    /* Verfica que exista el mozo y este habilitada */
    IF  in_idMozo IS NOT NULL
		AND NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idMozo AND state = 1
            ) THEN
		SET @existe_mozo = false;
		SELECT 4 AS resultado;
    END IF;
    
	IF @existe_plato AND @existe_mesa AND @existe_mozo THEN
    
		/* Aumenta los insumos del almacen no utilizados*/
        UPDATE almacen AS a INNER JOIN platos_insumos AS p ON a.idinsumo = p.idinsumo
        INNER JOIN pedidos AS ped ON ped.idplato = p.idplato
        SET a.cantidad = a.cantidad + p.cantidad
		WHERE (ped.idpedido=in_id_pedido);
		/* modifica el pedido */
        UPDATE pedidos
		SET idplato = in_idPlato, num_mesa = in_num_mesa,idmozo= in_idMozo,updated_at = now()
		WHERE (idpedido = in_id_pedido)&&(estado='PENDIENTE');
		
		/* Resto los insumos del almacen */
        UPDATE almacen AS a INNER JOIN platos_insumos AS p ON a.idinsumo = p.idinsumo
        SET a.cantidad = a.cantidad - p.cantidad
		WHERE (p.idplato = in_idPlato);
        
		SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END