-- triggers.sql
-- (Adaptado para OneCompiler: Sin USE)

DELIMITER //

-- 1. Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_id_ingrediente INT;
    DECLARE v_cantidad_necesaria DECIMAL(10,2);
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur_ingredientes CURSOR FOR 
        SELECT id_ingrediente, cantidad_necesaria 
        FROM pizza_ingredientes 
        WHERE id_pizza = NEW.id_pizza;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur_ingredientes;
    
    leer_loop: LOOP
        FETCH cur_ingredientes INTO v_id_ingrediente, v_cantidad_necesaria;
        IF done THEN
            LEAVE leer_loop;
        END IF;
        
        UPDATE ingredientes 
        SET stock_actual = stock_actual - (NEW.cantidad * v_cantidad_necesaria)
        WHERE id_ingrediente = v_id_ingrediente;
        
    END LOOP;
    
    CLOSE cur_ingredientes;
END //

-- 2. Trigger de auditoría que registre en historial_precios cada vez que se modifique el precio_base.
CREATE TRIGGER trg_auditoria_precios
AFTER UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base <> NEW.precio_base THEN
        INSERT INTO historial_precios (id_pizza, precio_anterior, precio_nuevo, fecha_modificacion)
        VALUES (NEW.id_pizza, OLD.precio_base, NEW.precio_base, NOW());
    END IF;
END //

-- 3. Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.
CREATE TRIGGER trg_repartidor_disponible
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
        UPDATE repartidores 
        SET estado = 'Disponible' 
        WHERE id_repartidor = NEW.id_repartidor;
    END IF;
END //

DELIMITER ;

-- ==========================================================
-- PRUEBA DE TRIGGERS (Para que se vea el resultado en pantalla)
-- ==========================================================

-- Demostración del Trigger 2: Historial de Precios
SELECT '--- CAMBIANDO EL PRECIO DE UNA PIZZA PARA ACTIVAR EL TRIGGER ---' AS Acción;
UPDATE pizzas SET precio_base = 28000 WHERE id_pizza = 1;

SELECT '--- RESULTADO: EL TRIGGER GUARDO EL CAMBIO EN EL HISTORIAL ---' AS Resultado;
SELECT * FROM historial_precios;
