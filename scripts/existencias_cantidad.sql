SELECT 
	insumos.idinsumo as Id,
    insumos.nombre_insumo as Insumo, 
    SUM(cantidad) as Total 
FROM historial_almacen 
INNER JOIN insumos on historial_almacen.idinsumo=insumos.idinsumo
GROUP BY historial_almacen.idinsumo;