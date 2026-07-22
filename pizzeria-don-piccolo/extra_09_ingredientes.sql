-- ====================================================================
-- MODULO EXTRA: INGREDIENTES ADICIONALES (EXTRAS)
-- (Por si el profe te pide que el cliente pueda pedir "extra queso"
--  o "extra peperoni" en su pizza por un costo adicional)
-- ====================================================================

-- 1. Creamos tabla para guardar qué extras se le echaron a qué pizza
CREATE TABLE detalle_ingredientes_extra (
    id_extra INT AUTO_INCREMENT PRIMARY KEY,
    id_detalle INT NOT NULL, -- A qué pizza exacta del pedido se le echó
    id_ingrediente INT NOT NULL, -- Qué se le echó (ej. Queso)
    costo_extra INT NOT NULL, -- Cuánto vale ese extra
    FOREIGN KEY (id_detalle) REFERENCES detalle_pedidos(id_detalle),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

-- 2. Simulamos que a la primera pizza del pedido 1 (que era id_detalle 1) 
--    le pidieron extra de ingrediente 1 (Queso Mozzarella) por 3.000 pesos
INSERT INTO detalle_ingredientes_extra (id_detalle, id_ingrediente, costo_extra) 
VALUES (1, 1, 3000);

-- 3. Consulta para ver las pizzas que llevaron ingredientes extra
SELECT '--- PIZZAS QUE PIDIERON INGREDIENTES EXTRA ---' AS Resultado;

SELECT p.id_pedido, pz.nombre AS Pizza, i.nombre AS Extra_Agregado, e.costo_extra
FROM detalle_ingredientes_extra e
JOIN detalle_pedidos dp ON e.id_detalle = dp.id_detalle
JOIN pedidos p ON dp.id_pedido = p.id_pedido
JOIN pizzas pz ON dp.id_pizza = pz.id_pizza
JOIN ingredientes i ON e.id_ingrediente = i.id_ingrediente;
