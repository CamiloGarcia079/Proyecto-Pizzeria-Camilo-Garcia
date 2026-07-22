-- consultas.sql
-- (Adaptado para OneCompiler: Sin USE)

-- 1. Clientes con pedidos entre dos fechas (BETWEEN).
SELECT DISTINCT c.nombre, c.telefono, p.fecha_hora, p.total
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha_hora BETWEEN '2024-01-01 00:00:00' AND '2024-01-31 23:59:59';

-- 2. Pizzas más vendidas (GROUP BY y COUNT).
SELECT pz.nombre, COUNT(dp.id_pizza) AS veces_pedida, SUM(dp.cantidad) AS total_unidades_vendidas
FROM detalle_pedidos dp
JOIN pizzas pz ON dp.id_pizza = pz.id_pizza
GROUP BY dp.id_pizza, pz.nombre
ORDER BY total_unidades_vendidas DESC;

-- 3. Pedidos por repartidor (JOIN).
SELECT r.nombre AS repartidor, r.zona_asignada, p.id_pedido, p.fecha_hora, p.estado
FROM domicilios d
JOIN repartidores r ON d.id_repartidor = r.id_repartidor
JOIN pedidos p ON d.id_pedido = p.id_pedido;

-- 4. Promedio de entrega por zona (AVG y JOIN).
SELECT r.zona_asignada, 
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos_entrega
FROM domicilios d
JOIN repartidores r ON d.id_repartidor = r.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona_asignada;

-- 5. Clientes que gastaron más de un monto (HAVING).
SELECT c.nombre, SUM(p.total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING SUM(p.total) > 50000;

-- 6. Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
SELECT * 
FROM pizzas 
WHERE nombre LIKE '%Queso%';

-- 7. Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
SELECT nombre, telefono 
FROM clientes 
WHERE id_cliente IN (
    SELECT id_cliente 
    FROM pedidos 
    GROUP BY id_cliente 
    HAVING COUNT(id_pedido) > 5
);
