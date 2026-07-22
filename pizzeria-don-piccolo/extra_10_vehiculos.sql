-- ====================================================================
-- MODULO EXTRA: VEHICULOS DE REPARTIDORES
-- (Por si el profe te pide llevar un control de si el repartidor
--  va en moto, bicicleta, o el registro de la placa de su vehículo)
-- ====================================================================

-- 1. Creamos la tabla de Vehículos
CREATE TABLE vehiculos_repartidores (
    placa VARCHAR(15) PRIMARY KEY, -- La placa es unica
    id_repartidor INT UNIQUE NOT NULL, -- Un repartidor solo tiene asignado un vehiculo
    tipo_vehiculo ENUM('Motocicleta', 'Bicicleta', 'Automovil') NOT NULL,
    marca VARCHAR(50),
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- 2. Insertamos el vehículo de Carlos (Motocicleta) y de Luis (Bicicleta)
INSERT INTO vehiculos_repartidores (placa, id_repartidor, tipo_vehiculo, marca) VALUES
('XYZ-123', 1, 'Motocicleta', 'Yamaha'),
('SIN-PLACA', 2, 'Bicicleta', 'Shimano');

-- 3. Consulta para ver los repartidores y en qué se movilizan
SELECT '--- VEHICULOS DE LOS REPARTIDORES ---' AS Resultado;

SELECT r.nombre, v.tipo_vehiculo, v.marca, v.placa
FROM repartidores r
LEFT JOIN vehiculos_repartidores v ON r.id_repartidor = v.id_repartidor;
