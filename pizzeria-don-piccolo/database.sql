-- database.sql
-- (Adaptado para OneCompiler: Sin CREATE DATABASE ni USE, y con datos de prueba)

-- Tabla de Clientes
CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  correo_electronico VARCHAR(100) NOT NULL
);

-- Tabla de Pizzas
CREATE TABLE pizzas (
  id_pizza INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tamano ENUM('Pequeña', 'Mediana', 'Familiar') NOT NULL,
  precio_base INT NOT NULL,
  tipo ENUM('Vegetariana', 'Especial', 'Clásica') NOT NULL
);

-- Tabla de Ingredientes
CREATE TABLE ingredientes (
  id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  stock_actual DECIMAL(10,2) NOT NULL,
  stock_minimo DECIMAL(10,2) NOT NULL,
  unidad_medida VARCHAR(20) NOT NULL,
  costo_unidad INT NOT NULL
);

-- Relación Pizzas - Ingredientes (Muchos a Muchos)
CREATE TABLE pizza_ingredientes (
  id_pizza INT,
  id_ingrediente INT,
  cantidad_necesaria DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_pizza, id_ingrediente),
  FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE,
  FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente) ON DELETE CASCADE
);

-- Tabla de Pedidos
CREATE TABLE pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  metodo_pago ENUM('Efectivo', 'Tarjeta', 'App') NOT NULL,
  estado ENUM('Pendiente', 'En Preparación', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
  total INT NOT NULL DEFAULT 0,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Detalle de Pedidos
CREATE TABLE detalle_pedidos (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_pizza INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario INT NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)
);

-- Tabla de Repartidores
CREATE TABLE repartidores (
  id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  zona_asignada VARCHAR(50) NOT NULL,
  estado ENUM('Disponible', 'No Disponible') NOT NULL DEFAULT 'Disponible'
);

-- Tabla de Domicilios
CREATE TABLE domicilios (
  id_domicilio INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT UNIQUE NOT NULL,
  id_repartidor INT NOT NULL,
  hora_salida DATETIME NULL,
  hora_entrega DATETIME NULL,
  distancia_km DECIMAL(5,2) NOT NULL,
  costo_envio INT NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- Historial de Precios de Pizzas (Auditoría)
CREATE TABLE historial_precios (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_pizza INT NOT NULL,
  precio_anterior INT NOT NULL,
  precio_nuevo INT NOT NULL,
  fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE
);

-- ==========================================================
-- DATOS DE PRUEBA (Requerido para que las consultas y vistas funcionen)
-- ==========================================================
INSERT INTO clientes (nombre, telefono, direccion, correo_electronico) VALUES 
('Camilo Garcia', '3001234567', 'Calle 1 # 2-3', 'camilo@mail.com'),
('Ana Gomez', '3109876543', 'Carrera 4 # 5-6', 'ana@mail.com');

INSERT INTO pizzas (nombre, tamano, precio_base, tipo) VALUES 
('Pizza Hawaiana', 'Mediana', 25000, 'Clásica'),
('Pizza Pepperoni y Queso', 'Familiar', 35000, 'Especial'),
('Pizza Vegetariana', 'Pequeña', 20000, 'Vegetariana');

INSERT INTO ingredientes (nombre, stock_actual, stock_minimo, unidad_medida, costo_unidad) VALUES 
('Queso Mozzarella', 10, 20, 'Kg', 15000), 
('Jamón', 50, 10, 'Kg', 12000),
('Piña', 30, 5, 'Kg', 5000);

INSERT INTO pedidos (id_cliente, fecha_hora, metodo_pago, estado, total) VALUES 
(1, '2024-01-15 10:00:00', 'Efectivo', 'Entregado', 25000),
(1, '2024-01-16 11:00:00', 'Tarjeta', 'Entregado', 35000),
(1, '2024-01-17 12:00:00', 'App', 'Entregado', 20000),
(1, '2024-01-18 13:00:00', 'Efectivo', 'Entregado', 25000),
(1, '2024-01-19 14:00:00', 'Tarjeta', 'Entregado', 35000),
(1, '2024-01-20 15:00:00', 'App', 'Entregado', 20000), 
(2, '2024-01-15 20:00:00', 'Tarjeta', 'Entregado', 55000); 

INSERT INTO detalle_pedidos (id_pedido, id_pizza, cantidad, precio_unitario) VALUES 
(1, 1, 1, 25000),
(2, 2, 1, 35000),
(7, 2, 1, 35000),
(7, 3, 1, 20000);

INSERT INTO repartidores (nombre, zona_asignada, estado) VALUES 
('Carlos Repartidor', 'Norte', 'Disponible'),
('Luis Domicilios', 'Sur', 'Disponible');

INSERT INTO domicilios (id_pedido, id_repartidor, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES 
(1, 1, '2024-01-15 10:10:00', '2024-01-15 10:40:00', 5.5, 3000),
(2, 2, '2024-01-16 11:15:00', '2024-01-16 11:35:00', 3.0, 2000);
