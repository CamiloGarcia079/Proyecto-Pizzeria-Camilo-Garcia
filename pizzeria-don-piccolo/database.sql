-- database.sql
-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

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
  precio_base DECIMAL(10,2) NOT NULL,
  tipo ENUM('Vegetariana', 'Especial', 'Clásica') NOT NULL
);

-- Tabla de Ingredientes
CREATE TABLE ingredientes (
  id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  stock_actual DECIMAL(10,2) NOT NULL,
  stock_minimo DECIMAL(10,2) NOT NULL,
  unidad_medida VARCHAR(20) NOT NULL,
  costo_unidad DECIMAL(10,2) NOT NULL
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
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Detalle de Pedidos
CREATE TABLE detalle_pedidos (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_pizza INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
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
  costo_envio DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
);

-- Historial de Precios de Pizzas (Auditoría)
CREATE TABLE historial_precios (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_pizza INT NOT NULL,
  precio_anterior DECIMAL(10,2) NOT NULL,
  precio_nuevo DECIMAL(10,2) NOT NULL,
  fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza) ON DELETE CASCADE
);
