-- vistas.sql
USE pizzeria_don_piccolo;

-- 1. Vista de resumen de pedidos por cliente
-- Muestra el nombre del cliente, cantidad de pedidos y total gastado.
CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT 
    c.nombre AS nombre_cliente, 
    COUNT(p.id_pedido) AS cantidad_pedidos, 
    SUM(p.total) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre;

-- 2. Vista de desempeño de repartidores
-- Muestra el número de entregas, tiempo promedio (en minutos), y zona.
CREATE OR REPLACE VIEW vista_desempeno_repartidores AS
SELECT 
    r.nombre AS nombre_repartidor, 
    r.zona_asignada, 
    COUNT(d.id_domicilio) AS numero_entregas, 
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id_repartidor, r.nombre, r.zona_asignada;

-- 3. Vista de stock de ingredientes por debajo del mínimo permitido.
CREATE OR REPLACE VIEW vista_stock_bajo AS
SELECT 
    id_ingrediente, 
    nombre, 
    stock_actual, 
    stock_minimo, 
    unidad_medida
FROM ingredientes
WHERE stock_actual < stock_minimo;
