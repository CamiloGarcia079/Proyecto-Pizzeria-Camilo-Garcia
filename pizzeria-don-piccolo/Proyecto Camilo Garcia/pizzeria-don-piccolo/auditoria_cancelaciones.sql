-- ====================================================================
-- MODULO EXTRA: AUDITORIA DE CANCELACIONES (TRIGGER)
-- (Por si pide llevar un registro estricto de cuando un pedido se cancela)
-- ====================================================================

-- 1. Tabla para guardar las cancelaciones
CREATE TABLE pedidos_cancelados (
    id_cancelacion INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_cancelacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- 2. Trigger que actúa como alarma cuando se cancela un pedido
DELIMITER //
CREATE TRIGGER trg_pedido_cancelado
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    -- Si el estado nuevo es Cancelado, lo guardamos en la tabla
    IF NEW.estado = 'Cancelado' AND OLD.estado <> 'Cancelado' THEN
        INSERT INTO pedidos_cancelados (id_pedido) VALUES (NEW.id_pedido);
    END IF;
END //
DELIMITER ;

-- 3. Cancelamos el pedido numero 3 a proposito para activar el Trigger
UPDATE pedidos SET estado = 'Cancelado' WHERE id_pedido = 3;

-- 4. Vemos el registro de cancelaciones
SELECT '--- REGISTRO HISTORICO DE CANCELACIONES ---' AS Resultado;
SELECT * FROM pedidos_cancelados;
