USE `restaurante`;
DROP procedure IF EXISTS `registrar_entrada_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_entrada_almacen`(
	IN in_idInsumo INTEGER,
    IN in_idAlmacenero INTEGER,
    IN in_cantidad DECIMAL(8,2),
    IN in_descripcion TEXT
)
BEGIN
	/* 
		Procedimiento que registra una entrada al almacen, agregando una fila a
        historial de almacen y modificando la tabla almacen.
         
		RETORNA
        * 1 si se registro correctamente la entrada
        * 2 si no existe el insumo
        * 3 si no existe el almacenero o esta deshabilitado
        * 4 si la cantidad es nula (menor o igual a 0)
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @existe_insumo = true;
    SET @existe_almacenero = true;
    SET @cantidad_valida = true;
    
    /* Verfica que exista el insumo */
    IF  in_idInsumo IS NULL
		OR NOT EXISTS(
			SELECT * FROM insumos 
            WHERE idinsumo = in_idInsumo
            ) THEN
		SET @existe_insumo = false;
		SELECT 2 AS resultado;
    END IF;
    
    /* Verfica que exista el almacener y este habilitada */
    IF  in_idAlmacenero IS NOT NULL
		AND NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idAlmacenero AND state = 1
            ) THEN
		SET @existe_almacenero = false;
		SELECT 3 AS resultado;
    END IF;
    
    /* Verifica que la cantidad sea valida */
    IF in_cantidad <= 0 THEN
		SET @cantidad_valida = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @existe_insumo AND @existe_almacenero AND @cantidad_valida THEN
		INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad, descripcion)
        VALUES (false, in_idInsumo, in_idAlmacenero, in_cantidad, in_descripcion);
        
        UPDATE almacen SET cantidad = cantidad + in_cantidad
        WHERE (idinsumo = in_idInsumo);
        
        SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

