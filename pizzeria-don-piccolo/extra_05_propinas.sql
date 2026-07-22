-- ====================================================================
-- MODULO EXTRA: SISTEMA DE PROPINAS
-- (Por si pide que los clientes puedan dejar propina al repartidor)
-- ====================================================================

-- 1. Agregamos la columna propina a los domicilios
ALTER TABLE domicilios ADD COLUMN propina INT DEFAULT 0;

-- 2. Simulamos que al domicilio 1 le dieron 2000 pesos de propina
UPDATE domicilios SET propina = 2000 WHERE id_domicilio = 1;

-- 3. Consulta para ver cuánto ha ganado en propinas cada repartidor
SELECT '--- TOTAL DE PROPINAS POR REPARTIDOR ---' AS Resultado;

SELECT r.nombre AS Repartidor, SUM(d.propina) AS Total_Propinas
FROM repartidores r 
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
GROUP BY r.id_repartidor, r.nombre;
