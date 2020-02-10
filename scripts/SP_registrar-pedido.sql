USE `restaurante`;
DROP procedure IF EXISTS `registrar_pedido`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_pedido`(
	IN in_idPlato INTEGER,
    IN in_num_mesa INTEGER,
    IN in_idMozo INTEGER
)
BEGIN
	/*
		Procedimiento que registra un nuevo pedido de una mesa
        Los valores numMesa e idMozo pueden ser nulos (en caso de 
        que el pedido sea para llevar por ejemplo).
        Tambien registra la resta de los insumos que intervienen en 
        la elaboracion del plato en el almacen.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se registro el pedido correctamente
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
    
    /* Verfica que exista la mesa y este habilitada */
    IF  in_idMozo IS NOT NULL
		AND NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idMozo AND state = 1
            ) THEN
		SET @existe_mozo = false;
		SELECT 4 AS resultado;
    END IF;
    
	IF @existe_plato AND @existe_mesa AND @existe_mozo THEN
		/* Registro el pedido */
		INSERT INTO pedidos (idplato, num_mesa, idmozo, estado) 
        VALUES (in_idPlato, in_num_mesa, in_idMozo, 'PENDIENTE');
    
		/* Resto los insumos del almacen */
        UPDATE almacen AS a INNER JOIN platos_insumos AS p ON a.idinsumo = p.idinsumo
        SET a.cantidad = a.cantidad - p.cantidad
		WHERE (p.idplato = in_idPlato);
        
		SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

