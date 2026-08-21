-- =============================================================================
-- PROYECTO CAPSTONE: Configuración y Limpieza de Estructura de Datos
-- Base de Datos: capstone_project
-- =============================================================================

-- 1. Limpieza de tablas previas
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- 2. Tabla: clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    ciudad VARCHAR(50)
);

-- 3. Tabla: productos
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio NUMERIC(10, 2) CHECK (precio >= 0)
);

-- 4. Tabla: pedidos
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(producto_id) ON DELETE CASCADE,
    cantidad INT CHECK (cantidad > 0),
    monto_total NUMERIC(10, 2), -- Puede contener nulos para probar la limpieza
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INSERCIÓN DE DATOS DE PRUEBA (Incluye valores nulos para prueba de COALESCE)
-- =============================================================================

INSERT INTO clientes (nombre, email, fecha_registro, ciudad) VALUES
('Ana Gómez', 'ana.gomez@email.com', '2025-01-10', 'Madrid'),
('Carlos Ruiz', 'carlos.ruiz@email.com', '2025-01-15', 'Barcelona'),
('Laura Martínez', 'laura.m@email.com', '2025-02-01', 'Valencia'),
('David López', 'david.l@email.com', '2025-02-10', 'Madrid'),
('Elena Torres', 'elena.t@email.com', '2025-03-05', 'Sevilla');

INSERT INTO productos (nombre_producto, categoria, precio) VALUES
('Laptop Pro 15', 'Electrónica', 1200.00),
('Silla Ergonómica', 'Mobiliario', 250.00),
('Smartphone X', 'Electrónica', 800.00),
('Teclado Mecánico', 'Accesorios', 90.00),
('Monitor 4K', 'Electrónica', 350.00),
('Mouse Inalámbrico', 'Accesorios', 25.00),
('Lámpara de Escritorio', 'Mobiliario', 45.00);

-- Algunos registros tienen monto_total NULL intencionalmente
INSERT INTO pedidos (cliente_id, producto_id, cantidad, monto_total, fecha_pedido) VALUES
(1, 1, 1, 1200.00, '2025-01-12 10:30:00'),
(1, 4, 2, NULL,    '2025-01-15 14:20:00'),
(2, 2, 1, 250.00,  '2025-01-20 11:00:00'),
(3, 3, 1, 800.00,  '2025-02-05 16:45:00'),
(3, 5, 2, 700.00,  '2025-02-12 09:15:00'),
(4, 6, 3, 75.00,   '2025-02-18 18:00:00'),
(1, 3, 1, 800.00,  '2025-03-01 12:10:00'),
(2, 4, 1, NULL,    '2025-03-02 15:30:00'),
(5, 7, 2, 90.00,   '2025-03-10 10:00:00');
