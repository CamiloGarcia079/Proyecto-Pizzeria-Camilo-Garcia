-- ====================================================================
-- MODULO 3: PUNTOS DE FIDELIDAD (RECOMPENSAS)
-- (Pega todo esto al final si te piden que los clientes acumulen 
--  puntos cada vez que hacen un pedido)
-- ====================================================================

-- 1. Le agregamos una columna de puntos a los clientes
ALTER TABLE clientes ADD COLUMN puntos_acumulados INT DEFAULT 0;

-- 2. Creamos un Trigger muy sencillo: 
-- Cada vez que se guarde un nuevo pedido, le regalamos 100 puntos al cliente
DELIMITER //
CREATE TRIGGER trg_acumular_puntos
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    -- Hacemos un UPDATE sumando 100 al cliente que acaba de comprar (NEW.id_cliente)
    UPDATE clientes 
    SET puntos_acumulados = puntos_acumulados + 100
    WHERE id_cliente = NEW.id_cliente;
END //
DELIMITER ;

-- 3. Hacemos un pedido de prueba para que la alarma (Trigger) se active sola
INSERT INTO pedidos (id_cliente, fecha_hora, metodo_pago, estado, total) 
VALUES (2, NOW(), 'Efectivo', 'Pendiente', 45000);

-- 4. Mostramos los clientes y sus puntos para comprobar que el trigger sirvio
-- (Esta es la que le muestras al profe)
SELECT '--- PUNTOS ACUMULADOS DE LOS CLIENTES ---' AS Resultado;

SELECT nombre AS Cliente, puntos_acumulados AS Puntos
FROM clientes;
