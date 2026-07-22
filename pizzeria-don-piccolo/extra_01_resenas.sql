-- ====================================================================
-- MODULO 1: SISTEMA DE CALIFICACIONES Y RESEÑAS
-- (Pega todo esto al final de tu OneCompiler si el profe te pide 
--  que los clientes puedan calificar los pedidos o al repartidor)
-- ====================================================================

-- 1. Creamos la tabla para guardar las calificaciones
-- Usamos AUTO_INCREMENT para el id y llaves foráneas normales
CREATE TABLE calificaciones (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL, -- El pedido que se esta calificando
    puntuacion_pizza INT NOT NULL, -- Del 1 al 5
    puntuacion_repartidor INT NOT NULL, -- Del 1 al 5
    comentario VARCHAR(255), -- Lo que opina el cliente
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- 2. Insertamos datos de prueba para que la tabla no este vacía
-- Simulamos que los clientes de los primeros pedidos dejan su reseña
INSERT INTO calificaciones (id_pedido, puntuacion_pizza, puntuacion_repartidor, comentario) VALUES
(1, 5, 5, 'Excelente servicio, muy rapido'),
(2, 4, 3, 'La pizza muy rica pero el domiciliario se demoro'),
(7, 5, 4, 'Todo perfecto');

-- 3. Consulta para mostrar la calificacion promedio de cada repartidor
-- (Esta es la que le muestras al profe para probar que el modulo funciona)
SELECT '--- PROMEDIO DE CALIFICACIONES POR REPARTIDOR ---' AS Resultado;

-- Usamos AVG para sacar el promedio y JOIN para unir calificaciones con repartidores
SELECT r.nombre AS Repartidor, AVG(c.puntuacion_repartidor) AS Promedio_Estrellas
FROM calificaciones c
JOIN domicilios d ON c.id_pedido = d.id_pedido
JOIN repartidores r ON d.id_repartidor = r.id_repartidor
GROUP BY r.id_repartidor, r.nombre;
