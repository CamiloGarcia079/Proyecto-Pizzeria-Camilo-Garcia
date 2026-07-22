-- ====================================================================
-- MODULO 2: CUPONES DE DESCUENTO Y PROMOCIONES
-- (Pega todo esto al final de tu OneCompiler si el profe te pide 
--  manejar descuentos, rebajas o codigos promocionales)
-- ====================================================================

-- 1. Agregamos nuevas columnas a la tabla pedidos que ya existía
-- Usamos ALTER TABLE para no tener que borrar y crear la tabla de nuevo
ALTER TABLE pedidos ADD COLUMN codigo_cupon VARCHAR(20) DEFAULT NULL;
ALTER TABLE pedidos ADD COLUMN descuento_pesos INT DEFAULT 0;

-- 2. Actualizamos algunos pedidos viejos para simular que usaron un cupon
-- Al pedido 1 le restamos 5000 pesos de la promo
UPDATE pedidos SET codigo_cupon = 'PROMO2024', descuento_pesos = 5000 WHERE id_pedido = 1;
-- Al pedido 7 le restamos 10000 pesos por ser cliente fiel
UPDATE pedidos SET codigo_cupon = 'CLIENTE_FIEL', descuento_pesos = 10000 WHERE id_pedido = 7;

-- 3. Consulta para ver cuantas veces se uso cada cupon y cuanto dinero regalamos
-- (Esta es la que le muestras al profe para probar que el modulo funciona)
SELECT '--- REPORTE DE DESCUENTOS APLICADOS ---' AS Resultado;

-- Usamos COUNT para contar usos y SUM para sumar el dinero descontado
SELECT codigo_cupon AS Cupon, COUNT(id_pedido) AS Veces_Usado, SUM(descuento_pesos) AS Total_Dinero_Descontado
FROM pedidos
WHERE codigo_cupon IS NOT NULL
GROUP BY codigo_cupon;
