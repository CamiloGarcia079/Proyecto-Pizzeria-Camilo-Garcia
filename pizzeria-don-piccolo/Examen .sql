DROP VIEW IF EXISTS vista_desempeno_repartidor;
DROP TABLE IF EXISTS domicilios;
DROP TABLE IF EXISTS repartidores;

-- ==========================================
-- 1. CREACIÓN DE TABLAS REQUERIDAS
-- ==========================================

-- Tabla de repartidores
CREATE TABLE repartidores (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY, -- Llave primaria
    nombre VARCHAR(100) NOT NULL,                 
    telefono VARCHAR(20),                          
    zona_asignada VARCHAR(50),                     
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' 
);

-- Tabla de domicilios (pedidos enviados)
CREATE TABLE domicilios (
    id_domicilio INT AUTO_INCREMENT PRIMARY KEY,  
    id_pedido INT NOT NULL,                        -- FK a pedidos
    id_repartidor INT NOT NULL,                    -- FK a repartidores
    hora_salida DATETIME NOT NULL,                 
    hora_entrega DATETIME NULL,                    
    estado ENUM('en_ruta', 'entregado', 'cancelado') DEFAULT 'en_ruta', 
    
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- ==========================================
-- 2. DATOS DE PRUEBA
-- ==========================================

-- Insertamos 3 repartidores para probar
INSERT INTO repartidores (nombre, telefono, zona_asignada, estado) VALUES
('Carlos Mendoza', '3001234567', 'Norte', 'activo'),
('Laura Gomez', '3109876543', 'Centro', 'activo'),
('Pedro Martinez', '3205558888', 'Sur', 'inactivo');

-- Insertamos domicilios usando los pedidos 1, 2 y 3 (que seguro ya tienes arriba)
INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, hora_entrega, estado) VALUES
(1, 1, '2026-07-20 18:00:00', '2026-07-20 18:25:00', 'entregado'),
(2, 1, '2026-07-20 19:00:00', '2026-07-20 19:50:00', 'entregado'),
(3, 1, '2026-07-20 20:00:00', NULL, 'en_ruta');

-- Simulamos que el pedido 3 ya se entrego
UPDATE domicilios 
SET hora_entrega = '2026-07-20 20:30:00', estado = 'entregado'
WHERE id_domicilio = 3;

-- ==========================================
-- 3. CONSULTAS DEL EXAMEN
-- ==========================================

-- A. Entregas por repartidor y total acumulado
SELECT 
    r.nombre AS repartidor,
    COUNT(d.id_domicilio) AS total_entregas,
    IFNULL(SUM(p.total), 0) AS total_acumulado_pedidos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE d.estado = 'entregado'
GROUP BY r.id_repartidor, r.nombre;

-- B. Pedidos demorados (mas de 40 minutos)
SELECT 
    d.id_pedido,
    r.nombre AS repartidor,
    d.hora_salida,
    d.hora_entrega,
    TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) AS minutos_demora
FROM domicilios d
JOIN repartidores r ON d.id_repartidor = r.id_repartidor
WHERE d.hora_entrega IS NOT NULL 
  AND TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) > 40;

-- C. Repartidores activos sin entregas asignadas (Uso de LEFT JOIN y NULL)
SELECT 
    r.id_repartidor,
    r.nombre,
    r.telefono,
    r.zona_asignada
FROM repartidores r
LEFT JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE r.estado = 'activo' 
  AND d.id_domicilio IS NULL;

-- ==========================================
-- 4. VISTA RESUMEN
-- ==========================================

-- Creamos la vista solicitada por el gerente
CREATE VIEW vista_desempeno_repartidor AS
SELECT 
    r.nombre AS nombre_repartidor,
    COUNT(d.id_domicilio) AS entregas_totales,
    IFNULL(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 0) AS promedio_minutos_entrega
FROM repartidores r
LEFT JOIN domicilios d ON r.id_repartidor = d.id_repartidor AND d.estado = 'entregado'
GROUP BY r.id_repartidor, r.nombre;

-- Hacemos un SELECT para que el profesor vea la vista funcionando al final de la consola
SELECT * FROM vista_desempeno_repartidor;
