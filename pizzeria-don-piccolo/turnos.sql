-- ====================================================================
-- MODULO EXTRA: TURNOS DE EMPLEADOS
-- (Por si pide registrar a qué hora entran y salen a trabajar)
-- ====================================================================

-- 1. Creamos la tabla de turnos
CREATE TABLE turnos_empleados (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    id_repartidor INT NOT NULL,
    fecha DATE NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME, -- Se deja nulo hasta que el turno acabe
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- 2. Simulamos que el repartidor 1 acaba de entrar a trabajar hoy
INSERT INTO turnos_empleados (id_repartidor, fecha, hora_entrada) 
VALUES (1, CURRENT_DATE, '08:00:00');

-- 3. Consulta para ver quiénes están trabajando en este momento
SELECT '--- REPARTIDORES EN TURNO ACTUALMENTE ---' AS Resultado;

SELECT r.nombre, t.fecha, t.hora_entrada
FROM turnos_empleados t
JOIN repartidores r ON t.id_repartidor = r.id_repartidor
WHERE t.hora_salida IS NULL;
