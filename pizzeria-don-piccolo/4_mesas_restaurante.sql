-- ====================================================================
-- MODULO 4: MESAS DEL RESTAURANTE (COMER EN EL LOCAL)
-- (Pega todo esto si el profesor te dice: "Su pizzeria es solo a domicilio,
--  agréguele soporte para clientes que comen en el local fisico en mesas")
-- ====================================================================

-- 1. Creamos la tabla de Mesas físicas del restaurante
CREATE TABLE mesas (
    numero_mesa INT PRIMARY KEY, -- El numero de la mesa es la llave primaria
    capacidad_personas INT NOT NULL,
    estado ENUM('Libre', 'Ocupada') DEFAULT 'Libre'
);

-- 2. Modificamos la tabla de pedidos para que soporte pedidos en mesa
-- Agregamos si es Domicilio o En Mesa
ALTER TABLE pedidos ADD COLUMN tipo_pedido ENUM('Domicilio', 'En Mesa') DEFAULT 'Domicilio';
-- Agregamos en qué mesa están sentados (si es domicilio esto queda nulo)
ALTER TABLE pedidos ADD COLUMN numero_mesa INT DEFAULT NULL;
ALTER TABLE pedidos ADD FOREIGN KEY (numero_mesa) REFERENCES mesas(numero_mesa);

-- 3. Insertamos unas mesas de prueba
INSERT INTO mesas (numero_mesa, capacidad_personas, estado) VALUES
(1, 2, 'Libre'),
(2, 4, 'Ocupada'),
(3, 6, 'Libre');

-- 4. Insertamos un nuevo pedido, pero esta vez simulando que están sentados en la Mesa 2
INSERT INTO pedidos (id_cliente, fecha_hora, metodo_pago, estado, total, tipo_pedido, numero_mesa) 
VALUES (1, NOW(), 'Efectivo', 'Pendiente', 30000, 'En Mesa', 2);

-- 5. Consulta para ver el estado de las mesas del local
-- (Esta es la que le muestras al profe para probar que el modulo funciona)
SELECT '--- ESTADO ACTUAL DE LAS MESAS EN EL LOCAL ---' AS Resultado;

-- Usamos LEFT JOIN para ver las mesas aunque no tengan pedidos
SELECT m.numero_mesa, m.estado, p.id_pedido, c.nombre AS Cliente_Comiendo
FROM mesas m
LEFT JOIN pedidos p ON m.numero_mesa = p.numero_mesa
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE m.estado = 'Ocupada';
