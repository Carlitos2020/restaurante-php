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