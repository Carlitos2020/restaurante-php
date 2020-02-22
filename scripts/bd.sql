CREATE DATABASE  IF NOT EXISTS `restaurante` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `restaurante`;
-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 14, 2019 at 09:32 PM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurante`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `abrir_caja` (IN `in_monto_inicial` DECIMAL(8,2))  BEGIN
	/*
		Procedimiento que abre la caja del restaurante con un monto inicial.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se abrio la caja correctamente
        * 2 si la caja ya estaba abierta, y por lo tanto no se puede abrir una nueva caja
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		INSERT INTO historial_caja (monto_inicial) VALUES (in_monto_inicial);
		SET @idHistorialCaja = LAST_INSERT_ID();
		
		UPDATE caja_actual 
		SET idactual_historial_caja = @idHistorialCaja, monto_actual = in_monto_inicial
		WHERE (idcaja = 1);
        
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ajustar_existencia_almacen` (IN `in_idinsumo` INT(11), IN `in_cantidad` DECIMAL(8,2), IN `in_cantidad_ajustada` DECIMAL(8,2))  BEGIN
	SET AUTOCOMMIT = 0;

    SET @cantidad_real=in_cantidad_ajustada-in_cantidad;
    START TRANSACTION;
    
	INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad)
        VALUES (true, in_idinsumo, 18, @cantidad_real);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cerrar_caja` (IN `in_monto_final_real` DECIMAL(8,2))  BEGIN
	/*
		Procedimiento que cierra la caja actual. Actualiza el campo idactualhistorial_caja
        de la tabla caja_actual a nulo y actualiza la tabla historial_caja, los campos
        monto_final_calculado y monto_final_ingresado
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se cerró la caja correctamente
        * 2 si no estaba la caja abierta y por lo tanto no se pudo cerrar la caja
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NOT NULL THEN
		
        SET @idHistorialCaja = 0;
        SET @monto_final_calculado = 0;
        
        SELECT idactual_historial_caja, monto_actual
        FROM caja_actual 
        WHERE (idcaja = 1)
        INTO @idHistorialCaja, @monto_final_calculado;
        
        UPDATE caja_actual SET monto_actual = 0, idactual_historial_caja = NULL 
        WHERE (idcaja = 1);
        
        UPDATE historial_caja 
        SET monto_final_calculado = @monto_final_calculado, monto_final_ingresado = in_monto_final_real
        WHERE (idhistorial_caja = @idHistorialCaja);
		
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `desactivar_usuario` (IN `in_id_usuario` INTEGER)  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;

	SET @ID_ADMINISTRADOR = 1;
    
    IF EXISTS(SELECT * FROM users WHERE id = in_id_usuario) THEN
		IF (SELECT rol_id FROM users WHERE id = in_id_usuario) != @ID_ADMINISTRADOR THEN
			UPDATE users SET state = 0 
			WHERE (id = in_id_usuario);
			
			SELECT true AS ok, "Usuario desactivado correctamente" AS result;
		ELSE
			SELECT false AS ok, "El usuario es de tipo admministrador. No se pudo desactivar su cuenta" AS result;
		END IF;
	ELSE
		SELECT false AS ok, "El usuario no existe en la base de datos" AS result;
	END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deshabilitar_plato` (IN `id` INT(11))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 0, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editar_entrada_almacen` (IN `in_idhistorial_almacen` INT(11), IN `in_cantidad` DECIMAL(8,2))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE historial_almacen 
		SET cantidad = in_cantidad
		WHERE (idhistorial_almacen = in_idhistorial_almacen);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editar_insumo` (IN `in_id_insumo` INT(11), IN `in_nombre_insumo` VARCHAR(45), IN `in_cantidad_minima` DECIMAL(8,2))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE insumos 
		SET nombre_insumo = in_nombre_insumo, cantidad_minima = in_cantidad_minima, updated_at = now()
		WHERE (idinsumo = in_id_insumo);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editar_pedido` (IN `in_id_pedido` INT(11), IN `in_idPlato` INTEGER, IN `in_num_mesa` INTEGER, IN `in_idMozo` INTEGER)  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editar_plato` (IN `id` INT(11), IN `nombre` VARCHAR(45), IN `precio_plato` DECIMAL(8,2))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET nombre_plato = nombre, precio= precio_plato, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_insumo` (IN `id` INTEGER)  BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM almacen WHERE idinsumo=id;
    DELETE FROM insumos WHERE idinsumo=id;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_pedido` (IN `in_id_pedido` INT(11))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_plato` (IN `id` INTEGER)  BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM platos WHERE idplato=id;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_usuario` (IN `in_id_usuario` INTEGER)  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;

	SET @ID_ADMINISTRADOR = 1;
    /* Si el usuario a eliminar es admin y solo hay un admin en la bd*/
    IF (SELECT rol_id FROM users WHERE id = in_id_usuario) = @ID_ADMINISTRADOR 
		AND (SELECT COUNT(*) FROM users WHERE rol_id = @ID_ADMINISTRADOR) <= 1
    THEN
		/* NO PUEDO ELIMINARLO */
		SELECT false AS ok, "No se puede eliminar al ultimo usuario administrador" AS result;
    ELSE
		DELETE FROM users WHERE id = in_id_usuario;
        SELECT true AS ok, "Usuario eliminado correctamente" AS result;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `habilitar_plato` (IN `id` INT(11))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 1, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_entradas_almacen` ()  BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad, h.created_at AS fecha
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad >= 0 AND es_ajuste = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_existencias_almacen` ()  BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

    GROUP BY historial_almacen.idinsumo;
    
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_mesas` ()  BEGIN
	SELECT num_mesa, esta_activa FROM mesas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_pedidos_de_mesa` (IN `in_num_mesa` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_pedidos_enpreparacion` ()  BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='EN PREPARACION' ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_pedidos_listos` ()  BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PREPARADO';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_pedidos_platos_necesitanprepacion` ()  BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PENDIENTE' && platos.necesita_preparacion=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_pedidos_platos_no_necesitanprepacion` ()  BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PENDIENTE' && platos.necesita_preparacion=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_platos` ()  BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at
    FROM platos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_plato_insumos` (IN `id_plato` INT(11))  BEGIN
	SELECT
		a.idinsumo,
        b.idplato,
        b.nombre_plato,
		i.nombre_insumo,
		cantidad
	FROM platos_insumos a
	INNER JOIN platos b 
		ON a.idplato=b.idplato
	INNER JOIN insumos i
		ON a.idinsumo=i.idinsumo
    WHERE b.idplato=id_plato;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_salidas_almacen` ()  BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad, h.created_at AS fecha
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad <= 0 AND es_ajuste = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_usuarios` ()  BEGIN
	SELECT id, roles.rol_id AS rol_id, nombre_rol, username, firstname, 
		   surname, email, state, created_at, updated_at
	FROM users LEFT JOIN roles ON users.rol_id = roles.rol_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_estado_caja` ()  BEGIN
	SELECT monto_actual, (idactual_historial_caja IS NOT NULL) AS esta_abierta
    FROM caja_actual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_insumo` (IN `in_idinsumo` INTEGER)  BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
	FROM insumos
    WHERE idinsumo = in_idinsumo LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_pedido` (IN `in_id_pedido` INTEGER)  BEGIN
SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE idpedido=in_id_pedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_plato` (IN `in_id_plato` INTEGER)  BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at,updated_at
    FROM platos
    WHERE idplato=in_id_plato LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pasar_pedido_a_listo` (IN `id` INT(11))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE pedidos 
    SET estado='PREPARADO', updated_at = now()
    WHERE (idpedido=id);
    
    SET AUTOCOMMIT = 1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pasar_pedido_a_preparacion` (IN `id` INT(11))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE pedidos
		SET estado = 'EN PREPARACION', updated_at = now()
		WHERE (idpedido = id);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_entrada_almacen` (IN `in_idInsumo` INTEGER, IN `in_idAlmacenero` INTEGER, IN `in_cantidad` DECIMAL(8,2), IN `in_descripcion` TEXT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_insumo` (IN `in_nombre_insumo` VARCHAR(45), IN `in_cantidad_minima` DECIMAL(8,2))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    
    SET @last_id_insumos = LAST_INSERT_ID();

	INSERT INTO almacen (idinsumo, cantidad) 
			VALUES (@last_id_insumos, 0.0);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_insumo_proveedor` (IN `in_id_proveedor` INTEGER, IN `in_nombre_insumo` VARCHAR(45), IN `in_cantidad_minima` DECIMAL(8,2))  BEGIN
	DECLARE last_insert integer;
	SET AUTOCOMMIT = 0;
    
    START TRANSACTION;
    
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    SET last_insert = LAST_INSERT_ID();

    INSERT INTO proveedores_insumos(idproveedor, idinsumo)
	VALUES (in_id_proveedor, last_insert);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_mesa` (IN `in_numero_mesa` INTEGER)  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO mesas (num_mesa, esta_activa) 
			VALUES (in_numero_mesa,1);
            
	SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_operacion_caja` (IN `in_monto` DECIMAL(8,2), IN `in_descripcion` TEXT, IN `in_idcajero` INTEGER)  BEGIN
	/*
		Procedimiento que registra una operacion de caja en el actual historial
        de caja.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se registró la operacion de la caja correctamente
        * 2 si el monto es 0 y por lo tanto no tiene sentido registrar la operacion
        * 3 si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @esta_cajero_habilitado = true;
    SET @es_monto_valido = true;
    SET @esta_caja_abierta = true;
    
    IF in_monto = 0 THEN
		SET @es_monto_valido = false;
		SELECT 2 AS resultado;
    END IF;
    
    IF  in_idcajero IS NULL
		OR NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idcajero AND state = 1
            ) THEN
		SET @esta_cajero_habilitado = false;
		SELECT 3 AS resultado;
    END IF;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		SET @esta_caja_abierta = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @es_monto_valido AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        UPDATE caja_actual SET monto_actual = monto_actual + in_monto
        WHERE (idcaja = 1);
        
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, in_monto, in_descripcion, in_idcajero);
        
		SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_pago_de_mesa` (IN `in_num_mesa` INTEGER, IN `in_idcajero` INTEGER)  BEGIN
	/*
		Procedimiento que registra el pago de una mesa. El procedimiento
        registra una nueva operación de caja, elimina los pedidos de la tabla
        pedidos e inserta los pedidos pagados en la tabla historial_pedidos
        
        EL PROCEDIMIENTO RETORNA:
        * 1 Si el pago se registró correctamente
        * 2 Si la mesa no contiene ningun pedido y por lo tanto no ha nada que pagar
        * 3 Si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
    
    SET autocommit = 0;
    START TRANSACTION;
    
	SET @esta_cajero_habilitado = true;
    SET @existen_pedidos = true;
    SET @esta_caja_abierta = true;
    
    IF !EXISTS(SELECT * FROM pedidos WHERE num_mesa = in_num_mesa) THEN
		SET @existen_pedidos = false;
		SELECT 2 AS resultado;
    END IF;
    
    IF  in_idcajero IS NULL
		OR NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idcajero AND state = 1
            ) THEN
		SET @esta_cajero_habilitado = false;
		SELECT 3 AS resultado;
    END IF;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		SET @esta_caja_abierta = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @existen_pedidos AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		/* Primero calculo el monto del consumo */
        SET @monto_consumo = 0.0;
        
        SELECT SUM(pl.precio) 
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa
        INTO @monto_consumo;
        
        SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        /* Registro el pago del consumo de la mesa en operaciones_caja y actualizo el monto de la caja*/
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, @monto_consumo, 
				CONCAT("Pago por consumo de la mesa ", in_num_mesa), in_idcajero);
		UPDATE caja_actual SET monto_actual = monto_actual + @monto_consumo
        WHERE (idcaja = 1);
        
        /* Guardo los pedidos en el historial de pedidos*/
        INSERT INTO historial_pedidos (idplato, idmozo, monto)
        SELECT pe.idplato, pe.idmozo, pl.precio
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa;
        
        /* Elimino los pedidos de esa mesa */
        DELETE FROM pedidos 
        WHERE (num_mesa = in_num_mesa);
    
		SELECT 1 as resultado;
    END IF;
    SET autocommit = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_pedido` (IN `in_idPlato` INTEGER, IN `in_num_mesa` INTEGER, IN `in_idMozo` INTEGER)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_platos` (IN `in_nombre_plato` VARCHAR(45), IN `in_precio_plato` DECIMAL(6,2))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO platos (nombre_plato, precio, esta_activo) 
			VALUES (in_nombre_plato, in_precio_plato,1);
            
	SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_salida_almacen` (IN `in_idInsumo` INTEGER, IN `in_idAlmacenero` INTEGER, IN `in_cantidad` DECIMAL(8,2), IN `in_descripcion` TEXT)  BEGIN
    /* 
        Procedimiento que registra una salide del almacen, agregando una fila a
        historial de almacen y modificando la tabla almacen.
         
        RETORNA
        * 1 si se registro correctamente la entrada
        * 2 si no existe el insumo
        * 3 si no existe el almacenero o esta deshabilitado
        * 4 si la cantidad es nula (menor o igual a 0)
        * 5 si la cantidad existente del insumo no es suficiente
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @existe_insumo = true;
    SET @existe_almacenero = true;
    SET @cantidad_valida = true;
    SET @cantidadSuficiente = true;
    
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
    IF in_cantidad >= 0 THEN
        SET @cantidad_valida = false;
        SELECT 4 AS resultado;
    END IF;    
    
     IF  in_cantidad IS NOT NULL
        AND NOT EXISTS(
            SELECT * FROM almacen 
            WHERE (idinsumo = in_idInsumo)&&(cantidad + in_cantidad>=0)
            ) THEN
        SET @cantidadSuficiente  = false;
        SELECT 5 AS resultado;
    END IF;
    
    IF @existe_insumo AND @existe_almacenero AND @cantidad_valida AND @cantidadSuficiente THEN
        INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad, descripcion)
        VALUES (false, in_idInsumo, in_idAlmacenero, in_cantidad, in_descripcion);
        
        UPDATE almacen SET cantidad = cantidad + in_cantidad
        WHERE (idinsumo = in_idInsumo);
        
        SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_usuario` (IN `in_rol_id` INTEGER, IN `in_username` VARCHAR(191), IN `in_password` VARCHAR(191), IN `in_firstname` VARCHAR(191), IN `in_surname` VARCHAR(191), IN `in_email` VARCHAR(191), IN `in_api_token` VARCHAR(80))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
	SET @DEFAULT_STATE = 0; /* Valor por defecto de estado para el nuevo usuario*/
    
    /* El procedimiento primero verifica que haya un rol con el id dado de parametro*/
    IF EXISTS(SELECT * FROM roles WHERE in_rol_id = rol_id) THEN
		INSERT INTO users (rol_id, username, password, firstname, surname, email, state, api_token) 
		VALUES (in_rol_id, in_username, in_password, in_firstname, in_surname, in_email, @DEFAULT_STATE, in_api_token);
        
        SELECT true AS ok, "Usuario registrado" AS result;
	ELSE
		SELECT false AS ok, "No existe ese rol" AS result;
    END IF;
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insumos_proveedores_s_insumos_proveedoress` (IN `in_idproveedor` INTEGER)  BEGIN
	
	SELECT insumos.idinsumo, insumos.nombre_insumo , insumos.cantidad_minima
		FROM proveedores INNER JOIN  proveedores_insumos 
        ON proveedores.idproveedor = proveedores_insumos.idproveedor
        INNER JOIN insumos ON insumos.idinsumo=proveedores_insumos.idinsumo
        WHERE proveedores.idproveedor=in_idproveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_proveedores_d_proveedores` (IN `in_idproveedor` INTEGER)  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM proveedores WHERE idproveedor=in_idproveedor;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_proveedores_i_proveedores` (IN `in_nombre_proveedor` VARCHAR(50), IN `in_direccion_proveedor` VARCHAR(50), IN `in_descripcion` VARCHAR(120))  BEGIN
	
    DECLARE in_fecha TIMESTAMP;
	SET in_fecha=now();
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO proveedores (nombre_proveedor, direccion_proveedor,
				descripcion, created_at, updated_at) 
			VALUES (in_nombre_proveedor, in_direccion_proveedor,	in_descripcion, in_fecha, in_fecha);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_proveedores_s_proveedores` (IN `in_idproveedor` INTEGER)  BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores WHERE idproveedor=in_idproveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_proveedores_s_proveedoress` ()  BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_proveedores_u_proveedores` (IN `in_idproveedor` INTEGER, IN `in_nombre_proveedor` VARCHAR(50), IN `in_direccion_proveedor` VARCHAR(50), IN `in_descripcion` VARCHAR(120))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE proveedores 
		SET nombre_proveedor = in_nombre_proveedor, direccion_proveedor = in_direccion_proveedor, descripcion=in_descripcion, updated_at = now()
		WHERE (idproveedor = in_idproveedor);
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_roles_i_roles` (IN `pname` VARCHAR(45))  BEGIN
	INSERT INTO roles(nombre_rol) values (pname);
    select rol_id FROM roles where nombre_rol=pname;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_roles_s_roless` ()  BEGIN
	SELECT * FROM roles;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_users_activar_users` (IN `pid` INT)  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			state = 1
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_users_s_users` (IN `pid` INT)  BEGIN

    SELECT 
    username,
    firstname,
    surname,
    rol_id
    FROM users WHERE id = pid;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_users_u_users` (IN `pid` INT, IN `prol_id` INT, IN `pusername` VARCHAR(191), IN `pfirstname` VARCHAR(191), IN `psurname` VARCHAR(191))  BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			rol_id = prol_id, 
			username = pusername, 
			firstname = pfirstname, 
			surname = psurname,
			updated_at = now()
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ver_entrada_almacen` (IN `in_idhist` INTEGER)  BEGIN
	SELECT  
		idhistorial_almacen, 
		i.idinsumo AS idinsumo, 
		i.nombre_insumo	AS nombre_insumo, 
		cantidad 
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE idhistorial_almacen=in_idhist AND cantidad >= 0 AND es_ajuste = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ver_existencia_almacen` (IN `in_idinsumo` INTEGER)  BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

        
    WHERE insumos.idinsumo=in_idinsumo;
    
    SET AUTOCOMMIT = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ver_insumos` ()  BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
		FROM insumos;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `almacen`
--

CREATE TABLE `almacen` (
  `idinsumo` int(11) NOT NULL,
  `cantidad` decimal(8,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `almacen`
--

INSERT INTO `almacen` (`idinsumo`, `cantidad`, `created_at`, `updated_at`) VALUES
(1, '40.00', '2019-10-30 01:18:32', '2019-10-30 01:18:32'),
(2, '15.00', '2019-10-30 01:20:15', '2019-10-30 01:20:15'),
(5, '0.00', '2019-10-30 01:20:15', '2019-10-30 01:20:15'),
(10, '20.00', '2019-10-30 01:20:48', '2019-10-30 01:20:48'),
(11, '20.00', '2019-10-30 01:20:48', '2019-10-30 01:20:48'),
(12, '20.00', '2019-10-30 01:20:49', '2019-10-30 01:20:49'),
(13, '20.00', '2019-10-30 00:51:15', '2019-10-30 00:51:15'),
(14, '0.00', '2019-10-30 15:15:36', '2019-10-30 15:15:36'),
(15, '0.00', '2019-10-31 21:25:44', '2019-10-31 21:25:44'),
(16, '0.00', '2019-10-31 21:25:45', '2019-10-31 21:25:45'),
(37, '0.00', '2019-11-10 14:10:53', '2019-11-10 14:10:53');

-- --------------------------------------------------------

--
-- Table structure for table `caja_actual`
--

CREATE TABLE `caja_actual` (
  `idcaja` int(11) NOT NULL,
  `monto_actual` decimal(8,2) DEFAULT NULL,
  `idactual_historial_caja` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `caja_actual`
--

INSERT INTO `caja_actual` (`idcaja`, `monto_actual`, `idactual_historial_caja`) VALUES
(1, '400.00', 12);

-- --------------------------------------------------------

--
-- Table structure for table `historial_almacen`
--

CREATE TABLE `historial_almacen` (
  `idhistorial_almacen` int(11) NOT NULL,
  `es_ajuste` tinyint(4) NOT NULL DEFAULT 0,
  `idinsumo` int(11) NOT NULL,
  `idalmacenero` int(11) NOT NULL,
  `cantidad` decimal(8,2) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `historial_almacen`
--

INSERT INTO `historial_almacen` (`idhistorial_almacen`, `es_ajuste`, `idinsumo`, `idalmacenero`, `cantidad`, `descripcion`, `created_at`) VALUES
(1, 0, 1, 18, '6.00', 'entrada random', '2019-10-29 22:19:00'),
(2, 0, 1, 18, '6.00', 'entrada random', '2019-10-29 22:23:17'),
(3, 0, 1, 18, '6.00', 'entrada random', '2019-10-29 22:24:57'),
(4, 0, 2, 18, '5.00', 'entrada random', '2019-10-29 22:25:53'),
(5, 0, 1, 18, '6.00', 'entrada random', '2019-10-29 22:26:30'),
(6, 0, 5, 18, '10.00', 'entrada random', '2019-10-29 22:28:04'),
(7, 0, 1, 18, '6.00', 'entrada random', '2019-10-30 11:20:44'),
(8, 0, 1, 18, '10.00', 'entrada random', '2019-10-30 11:22:15'),
(9, 0, 25, 18, '30.00', NULL, '2019-11-07 23:20:23'),
(10, 0, 17, 18, '10.00', NULL, '2019-11-07 23:21:12');

-- --------------------------------------------------------

--
-- Table structure for table `historial_caja`
--

CREATE TABLE `historial_caja` (
  `idhistorial_caja` int(11) NOT NULL,
  `monto_inicial` decimal(8,2) NOT NULL,
  `monto_final_calculado` decimal(8,2) DEFAULT NULL,
  `monto_final_ingresado` decimal(8,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `historial_caja`
--

INSERT INTO `historial_caja` (`idhistorial_caja`, `monto_inicial`, `monto_final_calculado`, `monto_final_ingresado`, `created_at`, `updated_at`) VALUES
(2, '200.00', '200.00', '100.00', '2019-11-09 15:29:45', '2019-11-09 15:29:45'),
(3, '300.00', '300.00', '100.00', '2019-11-09 15:47:04', '2019-11-09 15:47:04'),
(4, '390.00', '390.00', '200.00', '2019-11-09 15:49:01', '2019-11-09 15:49:01'),
(5, '100.00', '100.00', '200.00', '2019-11-09 16:20:59', '2019-11-09 16:20:59'),
(6, '100.00', '100.00', '200.00', '2019-11-09 16:30:06', '2019-11-09 16:30:06'),
(7, '50.00', '50.00', '90.00', '2019-11-10 15:40:45', '2019-11-10 15:40:45'),
(8, '200.00', '200.00', '0.00', '2019-11-10 15:52:00', '2019-11-10 15:52:00'),
(9, '900.00', '1500.00', '1500.00', '2019-11-10 16:01:17', '2019-11-10 16:01:17'),
(10, '200.00', '300.00', '200.00', '2019-11-10 18:58:31', '2019-11-10 18:58:31'),
(11, '100.00', '318.70', '300.00', '2019-11-10 19:17:46', '2019-11-10 19:17:46'),
(12, '400.00', NULL, NULL, '2019-11-13 20:21:24', '2019-11-13 20:21:24');

-- --------------------------------------------------------

--
-- Table structure for table `historial_pedidos`
--

CREATE TABLE `historial_pedidos` (
  `idhistorial_pedido` int(11) NOT NULL,
  `idplato` int(11) NOT NULL,
  `idmozo` int(11) DEFAULT NULL,
  `monto` decimal(6,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `historial_pedidos`
--

INSERT INTO `historial_pedidos` (`idhistorial_pedido`, `idplato`, `idmozo`, `monto`, `created_at`) VALUES
(1, 8, 18, '7.00', '2019-11-13 20:11:44'),
(2, 12, 18, '7.50', '2019-11-13 20:11:44'),
(3, 21, 18, '22.50', '2019-11-13 20:11:44'),
(4, 4, 18, '15.00', '2019-11-13 20:15:26'),
(5, 7, 18, '3.70', '2019-11-13 20:15:26');

-- --------------------------------------------------------

--
-- Table structure for table `insumos`
--

CREATE TABLE `insumos` (
  `idinsumo` int(11) NOT NULL,
  `nombre_insumo` varchar(45) NOT NULL,
  `cantidad_minima` decimal(8,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `insumos`
--

INSERT INTO `insumos` (`idinsumo`, `nombre_insumo`, `cantidad_minima`, `created_at`, `updated_at`) VALUES
(1, 'Carne de puerco', '10.00', '2019-10-04 14:16:12', '2019-11-08 01:30:42'),
(2, 'Gaseosa Incakola 1L', '5.00', '2019-10-04 14:52:29', '2019-10-12 14:54:07'),
(5, 'Gaseosa coca cola 1L', '5.00', '2019-10-10 05:22:13', '2019-10-10 05:24:00'),
(10, 'Papa amarilla', '15.00', '2019-10-17 20:25:08', '2019-11-08 01:32:12'),
(11, 'Semola', '2.50', '2019-10-24 06:12:14', '2019-10-24 06:12:14'),
(12, 'Harina', '2.00', '2019-10-24 21:47:09', '2019-10-24 21:47:09'),
(13, 'Coka cola', '2.00', '2019-10-30 00:51:15', '2019-10-30 00:51:15'),
(14, 'Pescado Salmon', '3.00', '2019-10-30 15:15:36', '2019-10-30 15:15:36'),
(15, 'Arroz', '2.00', '2019-10-31 21:25:44', '2019-10-31 21:25:44'),
(16, 'Arroz', '2.00', '2019-10-31 21:25:45', '2019-10-31 21:25:45'),
(17, 'sal', '1.00', '2019-11-01 06:07:08', '2019-11-01 06:07:08'),
(18, 'Gallina', '4.00', '2019-11-01 06:13:08', '2019-11-01 06:13:08'),
(25, 'Pavita', '5.00', '2019-11-01 08:10:58', '2019-11-01 08:10:58'),
(27, 'Carne de res', '2.50', '2019-11-01 08:19:23', '2019-11-07 05:52:30'),
(33, 'Gas', '1.00', '2019-11-07 05:56:36', '2019-11-07 05:56:36'),
(37, 'pollo con papa', '33.00', '2019-11-10 14:10:53', '2019-11-10 14:10:53');

-- --------------------------------------------------------

--
-- Table structure for table `mesas`
--

CREATE TABLE `mesas` (
  `num_mesa` int(11) NOT NULL,
  `esta_activa` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mesas`
--

INSERT INTO `mesas` (`num_mesa`, `esta_activa`, `created_at`, `updated_at`) VALUES
(1, 1, '2019-10-30 01:29:55', '2019-10-30 01:29:55'),
(2, 1, '2019-10-30 01:29:55', '2019-10-30 01:29:55'),
(3, 1, '2019-10-30 01:29:56', '2019-10-30 01:29:56'),
(4, 0, '2019-10-30 01:29:56', '2019-10-30 01:29:56'),
(5, 1, '2019-11-02 05:06:37', '2019-11-02 05:06:37'),
(6, 1, '2019-11-02 05:19:42', '2019-11-02 05:19:42'),
(7, 1, '2019-11-02 05:20:54', '2019-11-02 05:20:54');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `operaciones_caja`
--

CREATE TABLE `operaciones_caja` (
  `idoperaciones_caja` int(11) NOT NULL,
  `idhistorial_caja` int(11) NOT NULL,
  `monto` decimal(8,2) NOT NULL,
  `descripcion` text NOT NULL,
  `idcajero` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `operaciones_caja`
--

INSERT INTO `operaciones_caja` (`idoperaciones_caja`, `idhistorial_caja`, `monto`, `descripcion`, `idcajero`, `created_at`) VALUES
(1, 9, '100.00', 'cjdsckdsjk', 18, '2019-11-10 13:56:26'),
(2, 9, '500.00', 'cjdsckdsjk', 18, '2019-11-10 13:57:05'),
(3, 10, '100.00', 'bhscbdsj', 18, '2019-11-10 14:00:46'),
(4, 11, '100.00', 'Esta es una prueba', 18, '2019-11-10 14:17:51'),
(5, 11, '100.00', 'Una descripcion', 18, '2019-11-12 20:10:41'),
(6, 11, '37.00', 'Pago por consumo de la mesa 6', 18, '2019-11-13 15:11:44'),
(7, 11, '18.70', 'Pago por consumo de la mesa 5', 18, '2019-11-13 15:15:26');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pedidos`
--

CREATE TABLE `pedidos` (
  `idpedido` int(11) NOT NULL,
  `idplato` int(11) NOT NULL,
  `num_mesa` int(11) DEFAULT NULL,
  `idmozo` int(11) DEFAULT NULL,
  `estado` enum('PENDIENTE','EN PREPARACION','PREPARADO','ENTREGADO') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pedidos`
--

INSERT INTO `pedidos` (`idpedido`, `idplato`, `num_mesa`, `idmozo`, `estado`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 18, 'PREPARADO', '2019-10-30 01:39:37', '2019-11-07 22:47:30'),
(2, 4, 1, 18, 'PENDIENTE', '2019-10-30 01:41:56', '2019-11-13 00:25:45'),
(10, 1, NULL, 18, 'PREPARADO', '2019-10-30 02:36:40', '2019-11-04 22:33:59'),
(11, 1, 2, 18, 'ENTREGADO', '2019-10-30 02:38:38', '2019-11-04 22:34:07'),
(12, 1, 1, 18, 'PREPARADO', '2019-10-30 15:09:42', '2019-11-04 22:31:09'),
(15, 1, NULL, 18, 'PREPARADO', '2019-10-30 15:55:41', '2019-11-04 22:34:17'),
(17, 4, 1, 18, 'PREPARADO', '2019-11-03 02:42:21', '2019-11-04 20:40:46'),
(18, 4, 2, 18, 'PREPARADO', '2019-11-03 02:43:24', '2019-11-04 20:41:55'),
(19, 4, 3, 18, 'PREPARADO', '2019-11-03 02:43:24', '2019-11-04 22:21:29'),
(20, 2, 1, 18, 'PREPARADO', '2019-11-07 03:34:23', '2019-11-10 14:42:14'),
(23, 4, 3, 18, 'PREPARADO', '2019-11-07 09:46:25', '2019-11-08 01:27:07'),
(24, 1, 3, 18, 'EN PREPARACION', '2019-11-07 22:58:33', '2019-11-07 23:32:47'),
(25, 7, 3, 18, 'PREPARADO', '2019-11-07 23:31:52', '2019-11-08 01:27:25'),
(26, 1, 1, 18, 'PREPARADO', '2019-11-08 01:34:06', '2019-11-08 01:35:02'),
(28, 19, 2, 18, 'EN PREPARACION', '2019-11-10 14:39:55', '2019-11-10 15:06:59'),
(30, 8, 2, 18, 'PENDIENTE', '2019-11-12 22:05:09', '2019-11-12 22:05:09'),
(31, 3, 3, 18, 'PENDIENTE', '2019-11-13 01:14:36', '2019-11-13 01:14:36'),
(32, 1, 3, 18, 'PENDIENTE', '2019-11-13 01:20:21', '2019-11-13 01:20:21'),
(35, 7, 1, 18, 'PENDIENTE', '2019-11-13 01:43:55', '2019-11-13 01:43:55'),
(37, 8, 1, 18, 'PENDIENTE', '2019-11-13 01:58:51', '2019-11-13 01:58:51'),
(38, 4, 1, 18, 'PENDIENTE', '2019-11-13 01:59:12', '2019-11-13 01:59:12'),
(39, 21, 1, 18, 'PENDIENTE', '2019-11-13 02:00:42', '2019-11-13 02:00:42'),
(41, 8, 1, 18, 'PENDIENTE', '2019-11-13 14:14:45', '2019-11-13 14:14:45'),
(42, 7, 1, 18, 'PENDIENTE', '2019-11-13 14:16:34', '2019-11-13 14:16:34'),
(43, 6, 7, 18, 'PENDIENTE', '2019-11-14 04:04:54', '2019-11-14 04:05:05');

-- --------------------------------------------------------

--
-- Table structure for table `platos`
--

CREATE TABLE `platos` (
  `idplato` int(11) NOT NULL,
  `nombre_plato` varchar(45) NOT NULL,
  `precio` decimal(6,2) NOT NULL,
  `esta_activo` tinyint(4) NOT NULL DEFAULT 1,
  `necesita_preparacion` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `platos`
--

INSERT INTO `platos` (`idplato`, `nombre_plato`, `precio`, `esta_activo`, `necesita_preparacion`, `created_at`, `updated_at`) VALUES
(1, 'Lomo saltado', '10.00', 0, 1, '2019-10-10 07:19:32', '2019-11-13 02:06:05'),
(2, 'Arroz con pato', '10.00', 1, 1, '2019-10-10 07:52:28', '2019-11-07 23:31:16'),
(3, 'Aji de pollo', '7.50', 1, 1, '2019-10-10 07:52:28', '2019-11-07 23:31:19'),
(4, 'ceviche', '15.00', 1, 0, '2019-10-10 08:06:22', '2019-11-07 23:31:22'),
(6, 'Papa a la huancaina', '4.50', 1, 1, '2019-10-13 05:14:34', '2019-11-07 23:31:28'),
(7, 'Crema de rocoto', '3.70', 1, 0, '2019-10-13 05:59:45', '2019-11-07 23:31:28'),
(8, 'Ajiaco', '7.00', 1, 1, '2019-10-13 13:56:10', '2019-11-07 23:31:29'),
(12, 'Pollo al horno con pallares', '7.50', 1, 1, '2019-10-14 01:38:19', '2019-11-07 23:31:29'),
(19, 'Tallarines al Alfredo', '15.00', 1, 1, '2019-10-25 06:22:43', '2019-10-25 06:22:43'),
(21, 'Plato prueba 2', '22.50', 1, 1, '2019-11-10 14:12:30', '2019-11-10 14:15:24');

-- --------------------------------------------------------

--
-- Table structure for table `platos_insumos`
--

CREATE TABLE `platos_insumos` (
  `idplato` int(11) NOT NULL,
  `idinsumo` int(11) NOT NULL,
  `cantidad` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `platos_insumos`
--

INSERT INTO `platos_insumos` (`idplato`, `idinsumo`, `cantidad`) VALUES
(1, 1, '2.00'),
(1, 2, '5.00'),
(1, 5, '10.00');

-- --------------------------------------------------------

--
-- Table structure for table `procedimientos`
--

CREATE TABLE `procedimientos` (
  `idprocedimiento` int(11) NOT NULL,
  `nombre_procedimiento` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `proveedores`
--

CREATE TABLE `proveedores` (
  `idproveedor` int(11) NOT NULL,
  `nombre_proveedor` varchar(45) NOT NULL,
  `direccion_proveedor` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `proveedores`
--

INSERT INTO `proveedores` (`idproveedor`, `nombre_proveedor`, `direccion_proveedor`, `descripcion`, `created_at`, `updated_at`) VALUES
(10, 'Verduras Metro', 'Mercado mayorista', 'Lorem ipsum dolor sit amet cajhsajshja', '2019-10-10 20:27:45', '2019-10-10 21:27:18'),
(11, 'Z-GAS', 'Av. Los olivos Lt15', 'Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año', '2019-10-13 15:47:28', '2019-10-13 15:47:28'),
(12, 'Pollos San Fernando', 'Av. El sol 1234', 'Xuhhogd4uoi', '2019-10-25 00:42:33', '2019-10-25 00:42:33');

-- --------------------------------------------------------

--
-- Table structure for table `proveedores_insumos`
--

CREATE TABLE `proveedores_insumos` (
  `idproveedor` int(11) NOT NULL,
  `idinsumo` int(11) NOT NULL,
  `precio_por_unidad` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `proveedores_insumos`
--

INSERT INTO `proveedores_insumos` (`idproveedor`, `idinsumo`, `precio_por_unidad`) VALUES
(10, 10, '2.00'),
(10, 17, '0.00'),
(11, 33, '0.00'),
(12, 18, '0.00'),
(12, 25, '0.00'),
(12, 27, '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `rol_id` int(11) NOT NULL,
  `nombre_rol` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`rol_id`, `nombre_rol`) VALUES
(1, 'ADMINISTRADOR'),
(5, 'ALMACENERO'),
(4, 'CAJERO'),
(3, 'COCINERO'),
(2, 'MOZO');

-- --------------------------------------------------------

--
-- Table structure for table `tiempo_real`
--

CREATE TABLE `tiempo_real` (
  `idtiempo_real` int(11) NOT NULL,
  `idprocedimiento` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `token` varchar(45) NOT NULL,
  `esta_modificado` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `rol_id` int(11) NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `surname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` tinyint(4) NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `rol_id`, `username`, `password`, `api_token`, `firstname`, `surname`, `email`, `state`, `remember_token`, `created_at`, `updated_at`) VALUES
(18, 1, 'admin', '$2y$10$rJGVQ552ip85vG6wO6jvse2JwsBduNib0LHku/8BN.mQbo7gaaI5m', '41148c6b51e072e21b0140204622335e5735fce25f97fb4a2ef5a162eaafbbc9', 'admin', 'admin', 'admin@admin.com', 1, NULL, NULL, '2019-11-13 07:06:00'),
(19, 3, 'cocinero', '$2y$10$8dA26lv3YkFQNHvoutvpV.pUxeEtebEybQS783gsi9/qlK0/SlYrG', '0526a990ea6e5e9125de8e102c7b48566f499d7005cf60d172868be7a0643c23', 'cocinero', 'cocinero', 'cocinero@cocinero.com', 1, NULL, NULL, '2019-11-10 20:06:03'),
(20, 4, 'cajero', '$2y$10$JdRfRR9uTa9JAMo9qPwc6e.li3hdRUr3VRtoO62k2SafdYuezf.Wm', 'b612b5852263db7385d04b14778670522addf0fea193a7061aafd34225abcd11', 'cajero', 'cajero', 'cajero@cajero.com', 1, NULL, NULL, '2019-11-13 19:17:08'),
(21, 2, 'mozo', '$2y$10$qiOg60Oh1MXWeHLKdTYEG.Vrbyrr8CoXtT0mpsfxdjcTajO80ceLG', 'c2d361ac4bda27d8fcb3981df0686ad0fd3467098f2361db205e77d86d710b16', 'mozo', 'mozo', 'mozo@mozo.com', 1, NULL, NULL, '2019-11-14 08:58:12'),
(22, 5, 'almacenero', '$2y$10$ZEQOhnK8ZqSiVy3xI6TyIusJb5EYOtLNC9aEqcreDwiR8QeQ08Fdy', '65aa82cbb168695fd2ab4152a7c286a65c115783ee8e9d78ba4487bc9e5002c1', 'almacenero', 'almacenero', 'almacenero@almacenero.com', 1, NULL, NULL, '2019-11-14 09:06:40');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`idinsumo`);

--
-- Indexes for table `caja_actual`
--
ALTER TABLE `caja_actual`
  ADD PRIMARY KEY (`idcaja`),
  ADD KEY `fk_historial_caja_actual` (`idactual_historial_caja`);

--
-- Indexes for table `historial_almacen`
--
ALTER TABLE `historial_almacen`
  ADD PRIMARY KEY (`idhistorial_almacen`);

--
-- Indexes for table `historial_caja`
--
ALTER TABLE `historial_caja`
  ADD PRIMARY KEY (`idhistorial_caja`);

--
-- Indexes for table `historial_pedidos`
--
ALTER TABLE `historial_pedidos`
  ADD PRIMARY KEY (`idhistorial_pedido`);

--
-- Indexes for table `insumos`
--
ALTER TABLE `insumos`
  ADD PRIMARY KEY (`idinsumo`);

--
-- Indexes for table `mesas`
--
ALTER TABLE `mesas`
  ADD PRIMARY KEY (`num_mesa`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operaciones_caja`
--
ALTER TABLE `operaciones_caja`
  ADD PRIMARY KEY (`idoperaciones_caja`),
  ADD KEY `operaciones_caja_ibfk_1` (`idhistorial_caja`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`idpedido`),
  ADD KEY `fk_pedidos_mesas1_idx` (`num_mesa`),
  ADD KEY `fk_pedidos_platos1_idx` (`idplato`);

--
-- Indexes for table `platos`
--
ALTER TABLE `platos`
  ADD PRIMARY KEY (`idplato`);

--
-- Indexes for table `platos_insumos`
--
ALTER TABLE `platos_insumos`
  ADD PRIMARY KEY (`idplato`,`idinsumo`),
  ADD KEY `fk_platos_has_insumos_insumos1_idx` (`idinsumo`),
  ADD KEY `fk_platos_has_insumos_platos1_idx` (`idplato`);

--
-- Indexes for table `procedimientos`
--
ALTER TABLE `procedimientos`
  ADD PRIMARY KEY (`idprocedimiento`),
  ADD UNIQUE KEY `nombre_procedimiento_UNIQUE` (`nombre_procedimiento`);

--
-- Indexes for table `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`idproveedor`);

--
-- Indexes for table `proveedores_insumos`
--
ALTER TABLE `proveedores_insumos`
  ADD PRIMARY KEY (`idproveedor`,`idinsumo`),
  ADD KEY `fk_insumos_has_proveedores_proveedores1_idx` (`idproveedor`),
  ADD KEY `fk_insumos_has_proveedores_insumos1_idx` (`idinsumo`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`rol_id`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indexes for table `tiempo_real`
--
ALTER TABLE `tiempo_real`
  ADD PRIMARY KEY (`idtiempo_real`),
  ADD UNIQUE KEY `token_UNIQUE` (`token`),
  ADD KEY `fk_tiempo_real_procedimientos1_idx` (`idprocedimiento`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_api_token_unique` (`api_token`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `caja_actual`
--
ALTER TABLE `caja_actual`
  MODIFY `idcaja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `historial_almacen`
--
ALTER TABLE `historial_almacen`
  MODIFY `idhistorial_almacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `historial_caja`
--
ALTER TABLE `historial_caja`
  MODIFY `idhistorial_caja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `historial_pedidos`
--
ALTER TABLE `historial_pedidos`
  MODIFY `idhistorial_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `insumos`
--
ALTER TABLE `insumos`
  MODIFY `idinsumo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `operaciones_caja`
--
ALTER TABLE `operaciones_caja`
  MODIFY `idoperaciones_caja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `idpedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `platos`
--
ALTER TABLE `platos`
  MODIFY `idplato` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `idproveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `rol_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `almacen`
--
ALTER TABLE `almacen`
  ADD CONSTRAINT `fk_almacen_Insumos1` FOREIGN KEY (`idinsumo`) REFERENCES `insumos` (`idinsumo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `caja_actual`
--
ALTER TABLE `caja_actual`
  ADD CONSTRAINT `caja_actual_ibfk_1` FOREIGN KEY (`idactual_historial_caja`) REFERENCES `historial_caja` (`idhistorial_caja`);

--
-- Constraints for table `operaciones_caja`
--
ALTER TABLE `operaciones_caja`
  ADD CONSTRAINT `operaciones_caja_ibfk_1` FOREIGN KEY (`idhistorial_caja`) REFERENCES `historial_caja` (`idhistorial_caja`);

--
-- Constraints for table `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_mesas1` FOREIGN KEY (`num_mesa`) REFERENCES `mesas` (`num_mesa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pedidos_platos1` FOREIGN KEY (`idplato`) REFERENCES `platos` (`idplato`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `platos_insumos`
--
ALTER TABLE `platos_insumos`
  ADD CONSTRAINT `fk_platos_has_insumos_insumos1` FOREIGN KEY (`idinsumo`) REFERENCES `insumos` (`idinsumo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_platos_has_insumos_platos1` FOREIGN KEY (`idplato`) REFERENCES `platos` (`idplato`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `proveedores_insumos`
--
ALTER TABLE `proveedores_insumos`
  ADD CONSTRAINT `fk_insumos_has_proveedores_insumos1` FOREIGN KEY (`idinsumo`) REFERENCES `insumos` (`idinsumo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_insumos_has_proveedores_proveedores1` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tiempo_real`
--
ALTER TABLE `tiempo_real`
  ADD CONSTRAINT `fk_tiempo_real_procedimientos1` FOREIGN KEY (`idprocedimiento`) REFERENCES `procedimientos` (`idprocedimiento`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

USE `restaurante`;
DROP procedure IF EXISTS `editar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `editar_insumo` (
	IN in_id_insumo INT(11),
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE insumos 
		SET nombre_insumo = in_nombre_insumo, cantidad_minima = in_cantidad_minima, updated_at = now()
		WHERE (idinsumo = in_id_insumo);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


USE `restaurante`;
DROP procedure IF EXISTS `restaurante`.`obtener_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `obtener_insumo`(in in_idinsumo INTEGER)
BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
	FROM insumos
    WHERE idinsumo = in_idinsumo LIMIT 1;
END$$

DELIMITER ;
;



USE `restaurante`;
DROP procedure IF EXISTS `registrar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_insumo` (
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


USE `restaurante`;
DROP procedure IF EXISTS `ver_insumos`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_insumos` ()
BEGIN
	SELECT idinsumo, nombre_insumo, cantidad_minima, updated_at, created_at
		FROM insumos;
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_roles_i_roles`$$

CREATE PROCEDURE `usp_roles_i_roles`
(
	IN pname varchar(45)
)
BEGIN 
		INSERT INTO roles(nombre_rol) values (pname);
		select rol_id FROM roles where nombre_rol=pname;
END $$ DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_roles_s_roless`$$

CREATE PROCEDURE `usp_roles_s_roless`
()
BEGIN
	SELECT * FROM roles;
END $$ DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `obtener_plato`;

DELIMITER $$
USE `restaurante`$$

CREATE DEFINER=`admin`@`%` PROCEDURE `obtener_plato`(
	in in_id_plato INTEGER
)
BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at,updated_at
    FROM platos
    WHERE idplato=in_id_plato LIMIT 1;
END

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_platos`;

DELIMITER $$
USE `restaurante`$$

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_platos`()
BEGIN
	SELECT idplato,nombre_plato,precio,esta_activo,necesita_preparacion,created_at
    FROM platos;
END
DELIMITER ;


USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_d_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_d_proveedores` (
	IN in_idproveedor INTEGER
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM proveedores WHERE idproveedor=in_idproveedor;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_s_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_s_proveedores` (
				IN in_idproveedor INTEGER
)
BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores WHERE idproveedor=in_idproveedor;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_s_proveedoress`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_s_proveedoress` ()
BEGIN
	SELECT idproveedor, nombre_proveedor, direccion_proveedor, descripcion, updated_at, created_at
		FROM proveedores;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_i_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_i_proveedores` (
	IN in_nombre_proveedor VARCHAR(50),
	IN in_direccion_proveedor VARCHAR(50),
	IN in_descripcion VARCHAR(120)
)
BEGIN
	
    DECLARE in_fecha TIMESTAMP;
	SET in_fecha=now();
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO proveedores (nombre_proveedor, direccion_proveedor,
				descripcion, created_at, updated_at) 
			VALUES (in_nombre_proveedor, in_direccion_proveedor,	in_descripcion, in_fecha, in_fecha);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_proveedores_u_proveedores`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_proveedores_u_proveedores` (
	IN in_idproveedor INTEGER,
	IN in_nombre_proveedor VARCHAR(50),
	IN in_direccion_proveedor VARCHAR(50),
	IN in_descripcion VARCHAR(120)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE proveedores 
		SET nombre_proveedor = in_nombre_proveedor, direccion_proveedor = in_direccion_proveedor, descripcion=in_descripcion, updated_at = now()
		WHERE (idproveedor = in_idproveedor);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `eliminar_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_insumo`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM insumos WHERE idinsumo=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_plato_insumos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_plato_insumos`(
IN id_plato INT(11)
)
BEGIN
	SELECT
		a.idinsumo,
        b.idplato,
        b.nombre_plato,
		i.nombre_insumo,
		cantidad
	FROM platos_insumos a
	INNER JOIN platos b 
		ON a.idplato=b.idplato
	INNER JOIN insumos i
		ON a.idinsumo=i.idinsumo
    WHERE b.idplato=id_plato;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `eliminar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_plato` (
IN id INTEGER
)
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM platos WHERE idplato=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_platos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_platos`(
	in in_nombre_plato VARCHAR(45),
	in in_precio_plato decimal(6,2)  
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO platos (nombre_plato, precio, esta_activo) 
			VALUES (in_nombre_plato, in_precio_plato,1);
            
	SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

SE `restaurante`;
DROP procedure IF EXISTS `eliminar_usuario`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_usuario` (IN in_id_usuario INTEGER)
/* Procedimiento que elimina una cuenta de usuario, verificando que el
   usuario a eliminar no sea el único usuario de tipo administrador en la bd*/
/* NOTA: SE ASUME QUE EL ROL DE ID 1 ES EL ROL ADMINISTRADOR */
/* NOTA: NO SE ESTÁ VERIFICANDO QUE EL USUARIO A ELIMINAR NO TENGA UNA
   SESION ABIERTA (i.e. que este en la tabla tiempo_real )*/
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;

	SET @ID_ADMINISTRADOR = 1;
    /* Si el usuario a eliminar es admin y solo hay un admin en la bd*/
    IF (SELECT rol_id FROM users WHERE id = in_id_usuario) = @ID_ADMINISTRADOR 
		AND (SELECT COUNT(*) FROM users WHERE rol_id = @ID_ADMINISTRADOR) <= 1
    THEN
		/* NO PUEDO ELIMINARLO */
		SELECT false AS ok, "No se puede eliminar al ultimo usuario administrador" AS result;
    ELSE
		DELETE FROM users WHERE id = in_id_usuario;
        SELECT true AS ok, "Usuario eliminado correctamente" AS result;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_usuarios`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_usuarios` ()
BEGIN
	SELECT id, rol_id, username, firstname, 
		   surname, email, state, created_at, updated_at
	FROM users;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `desactivar_usuario`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `desactivar_usuario`(IN in_id_usuario INTEGER)
/* Procedimiento que desactiva una cuenta de usuario de rol no administrador */
/* NOTA: SE ASUME QUE EL ROL DE ID 1 ES EL ROL ADMINISTRADOR */
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;

	SET @ID_ADMINISTRADOR = 1;

	/* Primero se verifica que ese usuario exista */
	IF EXISTS(SELECT * FROM users WHERE id = in_id_usuario) THEN
		IF (SELECT rol_id FROM users WHERE id = in_id_usuario) != @ID_ADMINISTRADOR THEN
			UPDATE users SET state = 0 
			WHERE (id = in_id_usuario);
			
			SELECT true AS ok, "Usuario desactivado correctamente" AS result;
		ELSE
			SELECT false AS ok, "El usuario es de tipo admministrador. No se pudo desactivar su cuenta" AS result;
		END IF;
	ELSE
		SELECT false AS ok, "El usuario no existe en la base de datos" AS result;
	END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_usuario`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_usuario`(
    IN in_rol_id INTEGER,
    IN in_username VARCHAR(191),
    IN in_password VARCHAR(191),
    IN in_firstname VARCHAR(191),
    IN in_surname VARCHAR(191),
    IN in_email VARCHAR(191),
    IN in_api_token VARCHAR(80)
)
BEGIN
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    SET @DEFAULT_STATE = 0; /* Valor por defecto de estado para el nuevo usuario*/
    
    /* El procedimiento primero verifica que haya un rol con el id dado de parametro*/
    IF EXISTS(SELECT * FROM roles WHERE in_rol_id = rol_id) THEN
        INSERT INTO users (rol_id, username, password, firstname, surname, email, state, api_token) 
        VALUES (in_rol_id, in_username, in_password, in_firstname, in_surname, in_email, @DEFAULT_STATE, in_api_token);
        
        SELECT true AS ok, "Usuario registrado" AS result;
    ELSE
        SELECT false AS ok, "No existe ese rol" AS result;
    END IF;
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;



USE `restaurante`;
DROP procedure IF EXISTS `editar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `editar_plato`(
	IN id INT(11),
	IN nombre VARCHAR(45),
    IN precio_plato DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET nombre_plato = nombre, precio= precio_plato, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `habilitar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `habilitar_plato`(
	IN id INT(11)	
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 1, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `deshabilitar_plato`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `deshabilitar_plato` (
	IN id INT(11)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE platos 
		SET esta_activo = 0, updated_at = now()
		WHERE (idplato = id);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_users_activar_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_activar_users`(
	IN `pid` INT,
	IN `pstate` TINYINT
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			state = pstate
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_users_s_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_s_users`(
	IN `pid` INT
)
BEGIN

    SELECT 
    username,
    firstname,
    surname,
    rol_id
    FROM users WHERE id = pid;
    
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_users_u_users`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_users_u_users` (
	IN `pid` INT,
	IN `prol_id` INT,
	IN `pusername` VARCHAR(191),
	IN `pfirstname` VARCHAR(191),
	IN `psurname` VARCHAR(191)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE users
		SET 
			rol_id = prol_id, 
			username = pusername, 
			firstname = pfirstname, 
			surname = psurname,
			updated_at = now()
		WHERE 
			id = pid;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_entradas_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_entradas_almacen` ()
BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad 
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad >= 0 AND es_ajuste = 0;
END$$

DELIMITER ;
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


CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_pedido`(
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

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_enpreparacion`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='EN PREPARACION' ;
END

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_listos`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PREPARADO';
END

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_platos_necesitanprepacion`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PENDIENTE' && platos.necesita_preparacion=1;
END

CREATE DEFINER=`admin`@`%` PROCEDURE `listar_pedidos_platos_no_necesitanprepacion`()
BEGIN
	SELECT idpedido, platos.idplato AS idplato, platos.nombre_plato AS nombre_plato
		   , num_mesa, estado
		FROM pedidos INNER JOIN platos ON pedidos.idplato = platos.idplato 
		WHERE estado='PENDIENTE' && platos.necesita_preparacion=0;
END

USE `restaurante`;
DROP procedure IF EXISTS `registrar_mesa`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `registrar_mesa`(
	in in_numero_mesa INTEGER  
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    INSERT INTO mesas (num_mesa, esta_activo) 
			VALUES (in_numero_mesa,1);
            
	SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_insumo_proveedor`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `registrar_insumo_proveedor` (
	IN in_id_proveedor INTEGER
	IN in_nombre_insumo VARCHAR(45),
    IN in_cantidad_minima DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    SET A=0;
    
    INSERT INTO insumos (nombre_insumo, cantidad_minima) 
			VALUES (in_nombre_insumo, in_cantidad_minima);
    A= SELECT LAST_INSERT_ID()

    INSERT INTO proveedores_insumos(idproveedor, idinsumo)
	VALUES (in_id_proveedor, A);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `usp_insumos_proveedores_s_insumos_proveedoress`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `usp_insumos_proveedores_s_insumos_proveedoress` (
				IN in_idproveedor INTEGER
)
BEGIN
	
	SELECT insumos.nombre_insumo , insumos.cantidad_minima
		FROM proveedores INNER JOIN  proveedores_insumos 
        ON proveedores.idproveedor = proveedores_insumos.idproveedor
        INNER JOIN insumos ON insumos.idinsumo=proveedores_insumos.idinsumo
        WHERE proveedores.idproveedor=in_idproveedor;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `abrir_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `abrir_caja`(
	IN in_monto_inicial DECIMAL(8, 2)
)
BEGIN
	/*
		Procedimiento que abre la caja del restaurante con un monto inicial.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se abrio la caja correctamente
        * 2 si la caja ya estaba abierta, y por lo tanto no se puede abrir una nueva caja
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		INSERT INTO historial_caja (monto_inicial) VALUES (in_monto_inicial);
		SET @idHistorialCaja = LAST_INSERT_ID();
		
		UPDATE caja_actual 
		SET idactual_historial_caja = @idHistorialCaja, monto_actual = in_monto_inicial
		WHERE (idcaja = 1);
        
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `cerrar_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `cerrar_caja`(
	IN in_monto_final_real DECIMAL(8,1)
)
BEGIN
	/*
		Procedimiento que cierra la caja actual. Actualiza el campo idactualhistorial_caja
        de la tabla caja_actual a nulo y actualiza la tabla historial_caja, los campos
        monto_final_calculado y monto_final_ingresado
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se cerró la caja correctamente
        * 2 si no estaba la caja abierta y por lo tanto no se pudo cerrar la caja
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NOT NULL THEN
		
        SET @idHistorialCaja = 0;
        SET @monto_final_calculado = 0;
        
        SELECT idactual_historial_caja, monto_actual
        FROM caja_actual 
        WHERE (idcaja = 1)
        INTO @idHistorialCaja, @monto_final_calculado;
        
        UPDATE caja_actual SET monto_actual = 0, idactual_historial_caja = NULL 
        WHERE (idcaja = 1);
        
        UPDATE historial_caja 
        SET monto_final_calculado = @monto_final_calculado, monto_final_ingresado = in_monto_final_real
        WHERE (idhistorial_caja = @idHistorialCaja);
		
        SELECT 1 AS resultado;
	ELSE
		SELECT 2 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `obtener_estado_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `obtener_estado_caja` ()
BEGIN
	SELECT monto_actual, (idactual_historial_caja IS NOT NULL) AS esta_abierta
    FROM caja_actual;
END$$

DELIMITER ;

SELECT 
	insumos.idinsumo as Id,
    insumos.nombre_insumo as Insumo, 
    SUM(cantidad) as Total 
FROM historial_almacen 
INNER JOIN insumos on historial_almacen.idinsumo=insumos.idinsumo
GROUP BY historial_almacen.idinsumo;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_operacion_caja`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_operacion_caja`(
	IN in_monto DECIMAL(8,2),
    IN in_descripcion TEXT,
    IN in_idcajero INTEGER
)
BEGIN
	/*
		Procedimiento que registra una operacion de caja en el actual historial
        de caja.
        
        EL PROCEDIMIENTO RETORNA:
        * 1 si se registró la operacion de la caja correctamente
        * 2 si el monto es 0 y por lo tanto no tiene sentido registrar la operacion
        * 3 si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @esta_cajero_habilitado = true;
    SET @es_monto_valido = true;
    SET @esta_caja_abierta = true;
    
    IF in_monto = 0 THEN
		SET @es_monto_valido = false;
		SELECT 2 AS resultado;
    END IF;
    
    IF  in_idcajero IS NULL
		OR NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idcajero AND state = 1
            ) THEN
		SET @esta_cajero_habilitado = false;
		SELECT 3 AS resultado;
    END IF;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		SET @esta_caja_abierta = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @es_monto_valido AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        UPDATE caja_actual SET monto_actual = monto_actual + in_monto
        WHERE (idcaja = 1);
        
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, in_monto, in_descripcion, in_idcajero);
        
		SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_mesas`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_mesas` ()
BEGIN
	SELECT num_mesa, esta_activa FROM mesas;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_pago_de_mesa`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_pago_de_mesa`(
	IN in_num_mesa INTEGER,
    IN in_idcajero INTEGER
)
BEGIN
	/*
		Procedimiento que registra el pago de una mesa. El procedimiento
        registra una nueva operación de caja, elimina los pedidos de la tabla
        pedidos e inserta los pedidos pagados en la tabla historial_pedidos
        
        EL PROCEDIMIENTO RETORNA:
        * 1 Si el pago se registró correctamente
        * 2 Si la mesa no contiene ningun pedido y por lo tanto no ha nada que pagar
        * 3 Si el cajero no existe o esta deshabilitado
        * 4 si la caja no está abierta y por lo tanto no se puede registrar una operacion
    */
    
    SET autocommit = 0;
    START TRANSACTION;
    
	SET @esta_cajero_habilitado = true;
    SET @existen_pedidos = true;
    SET @esta_caja_abierta = true;
    
    IF !EXISTS(SELECT * FROM pedidos WHERE num_mesa = in_num_mesa) THEN
		SET @existen_pedidos = false;
		SELECT 2 AS resultado;
    END IF;
    
    IF  in_idcajero IS NULL
		OR NOT EXISTS(
			SELECT * FROM users 
            WHERE id = in_idcajero AND state = 1
            ) THEN
		SET @esta_cajero_habilitado = false;
		SELECT 3 AS resultado;
    END IF;
    
    IF (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1) IS NULL THEN
		SET @esta_caja_abierta = false;
        SELECT 4 AS resultado;
    END IF;
    
    IF @existen_pedidos AND @esta_cajero_habilitado AND @esta_caja_abierta THEN
		/* Primero calculo el monto del consumo */
        SET @monto_consumo = 0.0;
        
        SELECT SUM(pl.precio) 
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa
        INTO @monto_consumo;
        
        SET @idactual_historial_caja = 0;
        SELECT idactual_historial_caja FROM caja_actual 
        WHERE idcaja = 1 INTO @idactual_historial_caja;
        
        /* Registro el pago del consumo de la mesa en operaciones_caja y actualizo el monto de la caja*/
        INSERT INTO operaciones_caja (idhistorial_caja, monto, descripcion, idcajero) 
        VALUES (@idactual_historial_caja, @monto_consumo, 
				CONCAT("Pago por consumo de la mesa ", in_num_mesa), in_idcajero);
		UPDATE caja_actual SET monto_actual = monto_actual + @monto_consumo
        WHERE (idcaja = 1);
        
        /* Guardo los pedidos en el historial de pedidos*/
        INSERT INTO historial_pedidos (idplato, idmozo, monto)
        SELECT pe.idplato, pe.idmozo, pl.precio
        FROM pedidos pe INNER JOIN platos pl ON pe.idplato = pl.idplato 
        WHERE pe.num_mesa = in_num_mesa;
        
        /* Elimino los pedidos de esa mesa */
        DELETE FROM pedidos 
        WHERE (num_mesa = in_num_mesa);
    
		SELECT 1 as resultado;
    END IF;
    SET autocommit = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `ajustar_existencia_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ajustar_existencia_almacen`(
	IN `in_idinsumo` INT(11), 
    IN `in_cantidad` DECIMAL(8,2),
    IN `in_cantidad_ajustada` DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;

    SET @cantidad_real=in_cantidad_ajustada-in_cantidad;
    START TRANSACTION;
    
	INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad)
        VALUES (true, in_idinsumo, 18, @cantidad_real);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `editar_entrada_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `editar_entrada_almacen`(
	IN `in_idhistorial_almacen` INT(11), 
    IN `in_cantidad` DECIMAL(8,2)
)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    UPDATE historial_almacen 
		SET cantidad = in_cantidad
		WHERE (idhistorial_almacen = in_idhistorial_almacen);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `ver_entrada_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_entrada_almacen` (
	IN in_idhist INTEGER
)
BEGIN
	SELECT  
		idhistorial_almacen, 
		i.idinsumo AS idinsumo, 
		i.nombre_insumo	AS nombre_insumo, 
		cantidad 
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE idhistorial_almacen=in_idhist AND cantidad >= 0 AND es_ajuste = 0;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `ver_existencia_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_existencia_almacen` (
	IN in_idinsumo INTEGER
)
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

        
    WHERE insumos.idinsumo=in_idinsumo;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_salidas_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_salidas_almacen`()
BEGIN
	SELECT  idhistorial_almacen, i.idinsumo AS idinsumo, i.nombre_insumo 
			AS nombre_insumo, idalmacenero, cantidad, h.created_at AS fecha
    FROM historial_almacen h INNER JOIN insumos i ON i.idinsumo = h.idinsumo
    WHERE cantidad <= 0 AND es_ajuste = 0;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_salida_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_salida_almacen`(
    IN `in_idInsumo` INTEGER,
    IN `in_idAlmacenero` INTEGER, 
    IN `in_cantidad` DECIMAL(8,2), 
    IN `in_descripcion` TEXT
 )
BEGIN
    /* 
        Procedimiento que registra una salide del almacen, agregando una fila a
        historial de almacen y modificando la tabla almacen.
         
        RETORNA
        * 1 si se registro correctamente la entrada
        * 2 si no existe el insumo
        * 3 si no existe el almacenero o esta deshabilitado
        * 4 si la cantidad es nula (menor o igual a 0)
        * 5 si la cantidad existente del insumo no es suficiente
    */
    
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @existe_insumo = true;
    SET @existe_almacenero = true;
    SET @cantidad_valida = true;
    SET @cantidadSuficiente = true;
    
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
    IF in_cantidad >= 0 THEN
        SET @cantidad_valida = false;
        SELECT 4 AS resultado;
    END IF;    
    
     IF  in_cantidad IS NOT NULL
        AND NOT EXISTS(
            SELECT * FROM almacen 
            WHERE (idinsumo = in_idInsumo)&&(cantidad + in_cantidad>=0)
            ) THEN
        SET @cantidadSuficiente  = false;
        SELECT 5 AS resultado;
    END IF;
    
    IF @existe_insumo AND @existe_almacenero AND @cantidad_valida AND @cantidadSuficiente THEN
        INSERT INTO historial_almacen (es_ajuste, idinsumo, idalmacenero, cantidad, descripcion)
        VALUES (false, in_idInsumo, in_idAlmacenero, in_cantidad, in_descripcion);
        
        UPDATE almacen SET cantidad = cantidad + in_cantidad
        WHERE (idinsumo = in_idInsumo);
        
        SELECT 1 AS resultado;
    END IF;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;


USE `restaurante`;
DROP procedure IF EXISTS `eliminar_entrada`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_entrada`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM historial_almacen WHERE idhistorial_almacen=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `listar_existencias_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_existencias_almacen` ()
	
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;

    SELECT 
	insumos.idinsumo as Id,

	insumos.cantidad_minima as minimo,
	insumos.nombre_insumo as Insumo, 
	SUM(cantidad) as Total 

    FROM historial_almacen 

    INNER JOIN insumos on 	historial_almacen.idinsumo=insumos.idinsumo

    GROUP BY historial_almacen.idinsumo;
    HAVING Total >= 0;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

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

USE `restaurante`;
DROP procedure IF EXISTS `listar_operaciones_de_caja_actual`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `listar_operaciones_de_caja_actual` ()
BEGIN
	SELECT idoperaciones_caja, monto, descripcion, created_at 
    FROM operaciones_caja
    WHERE idhistorial_caja = (SELECT idactual_historial_caja FROM caja_actual WHERE idcaja = 1)
    ORDER BY created_at ASC;
END$$

DELIMITER ;

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
USE `restaurante`;
DROP procedure IF EXISTS `ver_estadisticas`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_estadisticas` (
	IN in_fecha VARCHAR(12)
)
BEGIN
	SELECT hora, cantidad
	FROM (
		SELECT hour(created_at) AS hora, count(*) AS cantidad
		FROM historial_pedidos
		where date_format(created_at, '%Y-%b-%d')=in_fecha
		GROUP BY hour(created_at)
	
	) as t
    
	ORDER BY hora;
END$$

DELIMITER ;
USE `restaurante`;
DROP procedure IF EXISTS `ver_estadisticas`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `ver_estadisticas` (
	IN in_fecha VARCHAR(12)
)
BEGIN
	SELECT hora, cantidad
	FROM (
		SELECT hour(created_at) AS hora, count(*) AS cantidad
		FROM historial_pedidos
		where date_format(created_at, '%Y-%b-%d')=in_fecha
		GROUP BY hour(created_at)
	
	) as t
    
	ORDER BY hora;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `reporte_platos`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `reporte_platos`(
IN FECHA_INICIO DATE,
IN FECHA_FIN DATE
)
BEGIN
	select p.nombre_plato,SUM(monto) AS total
	from historial_pedidos h 
	INNER JOIN platos p ON h.idplato=p.idplato
	where h.created_at  BETWEEN FECHA_INICIO AND  FECHA_FIN
	GROUP BY p.nombre_plato;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `reporte_ventas`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `reporte_ventas`(
IN FECHA_INICIO DATE,
IN FECHA_FIN DATE
)
BEGIN
	SELECT DATE_FORMAT(created_at, '%Y-%m-%d') AS fecha, SUM(monto_final_ingresado) AS "monto_total"
	FROM historial_caja
	where created_at  BETWEEN FECHA_INICIO AND  FECHA_FIN
	GROUP BY (fecha);
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `registrar_plato_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `registrar_plato_insumo`(
IN in_idplato INT(11), 
IN in_idinsumo INT(11),
IN in_cantidad DECIMAL(6,2)
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
   INSERT INTO platos_insumos (idplato,idinsumo,cantidad) 
			VALUES (in_idplato,in_idinsumo,in_idinsumo);
            
	SET AUTOCOMMIT = 1;

END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `eliminar_plato_insumo`;

DELIMITER $$
USE `restaurante`$$
CREATE DEFINER=`dbmasteruser`@`%` PROCEDURE `eliminar_plato_insumo`(
IN `in_idplato` INTEGER,
IN `in_idinsumo` INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
   DELETE FROM platos_insumos WHERE idplato=in_idplato && idinsumo=in_idinsumo;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

USE `restaurante`;
DROP procedure IF EXISTS `eliminar_historial_almacen`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_historial_almacen` (IN in_idhistorial_almacen INTEGER)
BEGIN
	SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    SET @idInsumo = 0;
    SET @cantidadHistorial = 0;
    
    SELECT idinsumo, cantidad FROM historial_almacen 
    WHERE idhistorial_almacen = in_idhistorial_almacen
    INTO @idInsumo, @cantidadHistorial;
    
    UPDATE almacen SET cantidad = cantidad - @cantidadHistorial
    WHERE (idinsumo = @idInsumo);
    
	DELETE FROM historial_almacen
    WHERE (idhistorial_almacen = in_idhistorial_almacen);
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;

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

USE `restaurante`;
DROP procedure IF EXISTS `eliminar_insumo_proveedor`;

DELIMITER $$
USE `restaurante`$$
CREATE PROCEDURE `eliminar_insumo_proveedor`(
IN id INTEGER
)
BEGIN
SET AUTOCOMMIT = 0;
    START TRANSACTION;
    
    DELETE FROM proveedores_insumos WHERE idinsumo=id;
    
    SET AUTOCOMMIT = 1;
END$$

DELIMITER ;