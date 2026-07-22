-- ====================================================================
-- MODULO EXTRA: PAGOS DIVIDIDOS O MÚLTIPLES
-- (Por si el profe te pide que un cliente pueda pagar mitad en 
--  efectivo y mitad en tarjeta/Nequi en un mismo pedido)
-- ====================================================================

-- 1. Creamos una tabla para llevar el registro de pagos de cada pedido
CREATE TABLE pagos_pedidos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Nequi', 'Daviplata') NOT NULL,
    monto INT NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- 2. Insertamos pagos simulando que el Pedido 7 se pagó dividido (25.000 y 30.000)
INSERT INTO pagos_pedidos (id_pedido, metodo_pago, monto) VALUES 
(7, 'Efectivo', 25000),
(7, 'Nequi', 30000);

-- 3. Consulta para ver cómo se ha pagado cada pedido
SELECT '--- REGISTRO DE PAGOS (DIVIDIDOS Y TOTALES) ---' AS Resultado;

SELECT p.id_pedido, c.nombre AS cliente, pp.metodo_pago, pp.monto
FROM pagos_pedidos pp
JOIN pedidos p ON pp.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.id_pedido;
