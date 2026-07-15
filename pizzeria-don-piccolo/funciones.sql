-- funciones.sql
-- (Adaptado para OneCompiler: Sin USE)

DELIMITER //

-- 1. Función para calcular el total de un pedido
-- Suma precios de pizzas + costo de envío + IVA (19%)
CREATE FUNCTION calcular_total_pedido(p_id_pedido INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_subtotal_pizzas INT DEFAULT 0;
    DECLARE v_costo_envio INT DEFAULT 0;
    DECLARE v_total INT;
    
    -- Calcular subtotal de las pizzas
    SELECT IFNULL(SUM(cantidad * precio_unitario), 0) INTO v_subtotal_pizzas
    FROM detalle_pedidos
    WHERE id_pedido = p_id_pedido;
    
    -- Obtener costo de envío
    SELECT IFNULL(costo_envio, 0) INTO v_costo_envio
    FROM domicilios
    WHERE id_pedido = p_id_pedido;
    
    -- Calcular total con IVA del 19% (se redondea al peso más cercano)
    SET v_total = ROUND((v_subtotal_pizzas + v_costo_envio) * 1.19);
    
    RETURN v_total;
END //

-- 2. Función para calcular la ganancia neta diaria
CREATE FUNCTION calcular_ganancia_neta_diaria(p_fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_ventas INT DEFAULT 0;
    DECLARE v_costos INT DEFAULT 0;
    
    -- Total de ventas del día (solo pedidos entregados)
    SELECT IFNULL(SUM(total), 0) INTO v_ventas
    FROM pedidos
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'Entregado';
    
    -- Costo de los ingredientes usados ese día
    SELECT IFNULL(SUM(dp.cantidad * pi.cantidad_necesaria * i.costo_unidad), 0) INTO v_costos
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
    JOIN pizza_ingredientes pi ON dp.id_pizza = pi.id_pizza
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE DATE(p.fecha_hora) = p_fecha AND p.estado = 'Entregado';
    
    RETURN v_ventas - v_costos;
END //

-- 3. Procedimiento para cambiar automáticamente el estado del pedido a “Entregado”
CREATE PROCEDURE registrar_entrega_domicilio(
    IN p_id_domicilio INT,
    IN p_hora_entrega DATETIME
)
BEGIN
    DECLARE v_id_pedido INT;
    
    UPDATE domicilios 
    SET hora_entrega = p_hora_entrega 
    WHERE id_domicilio = p_id_domicilio;
    
    SELECT id_pedido INTO v_id_pedido 
    FROM domicilios 
    WHERE id_domicilio = p_id_domicilio;
    
    UPDATE pedidos 
    SET estado = 'Entregado' 
    WHERE id_pedido = v_id_pedido;
    
END //

DELIMITER ;

-- ==========================================================
-- PRUEBA DE FUNCIONES Y PROCEDIMIENTOS
-- ==========================================================

SELECT '--- RESULTADO FUNCION: CALCULAR TOTAL DEL PEDIDO 1 (Con IVA) ---' AS Resultado;
SELECT calcular_total_pedido(1) AS Total_Pedido_Con_IVA;

SELECT '--- EJECUTANDO PROCEDIMIENTO: REGISTRAR ENTREGA DEL DOMICILIO 1 ---' AS Acción;
CALL registrar_entrega_domicilio(1, '2024-01-15 10:45:00');

SELECT '--- RESULTADO: EL ESTADO DEL PEDIDO AHORA ES ENTREGADO ---' AS Resultado;
SELECT id_pedido, estado FROM pedidos WHERE id_pedido = 1;
