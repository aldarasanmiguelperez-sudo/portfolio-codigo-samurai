   -- Reto 1: Tienda online Escuela Bojo Bushido
   -- Autora: Aldara
   -- Probado en SQLite con DBeaver

PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS Detalles_pedido;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Clientes;

CREATE TABLE Clientes (dni VARCHAR(10) PRIMARY KEY, nombre VARCHAR(20) NOT NULL, apellidos VARCHAR(30) NOT NULL, telefono VARCHAR(12), email VARCHAR(40) UNIQUE);
CREATE TABLE categorias
(id_categoria VARCHAR(3) PRIMARY KEY,
nombre VARCHAR(10) NOT NULL UNIQUE);
CREATE TABLE Productos
(id_producto VARCHAR(10) PRIMARY KEY,
nombre VARCHAR(30) NOT NULL UNIQUE,
descripcion VARCHAR(60) NOT NULL,
precio DECIMAL(8,2) NOT NULL CHECK (precio > 0),
stock INTEGER NOT NULL CHECK (stock >= 0),
id_categoria VARCHAR(3) NOT NULL,
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria));

CREATE TABLE Pedidos
(id_pedido VARCHAR(10) PRIMARY KEY,
dni_cliente VARCHAR(10) NOT NULL,
fecha_pedido DATE NOT NULL,
estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente' , 'Enviado' , 'Entregado')),
FOREIGN KEY (dni_cliente) REFERENCES Clientes(dni));

CREATE TABLE Detalles_pedido
(id_detalle INTEGER PRIMARY KEY,
id_pedido VARCHAR(10) NOT NULL,
id_producto VARCHAR(10) NOT NULL,
cantidad INTEGER NOT NULL CHECK(cantidad >= 1),
precio_unidad DECIMAL(8,2) NOT NULL CHECK(precio_unidad >0),
FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
FOREIGN KEY (id_producto) REFERENCES Productos (id_producto));

INSERT INTO Clientes (dni, nombre, apellidos, telefono, email)
VALUES ('34987645A', 'Alberto', 'Kinto Kawasaki','600123456', 'alberto@samurai.es');

INSERT INTO Clientes (dni, nombre,apellidos, telefono, email)
VALUES ( '37456159Q', 'Novita', 'Nohara Honda', '684120035', 'novitaNH@doraemon.com');

SELECT * FROM Clientes;
INSERT INTO categorias (id_categoria, nombre) VALUES
('ROP', 'Ropa'),
('ARM', 'Armas'),
('ACC', 'Accesorios');
INSERT INTO Productos (id_producto, nombre, descripcion, precio, stock,id_categoria)
VALUES ('KIM-001', 'Kimono blanco', 'Kimono de algodón para entrenar', 45.50, 20, 'ROP');

INSERT INTO Productos (id_producto, nombre, descripcion, precio, stock,id_categoria)
VALUES ('CIN-001', 'Cinturón blanco', 'Cinturón de algodón blanco', 10, 50,'ROP');

INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, estado)
VALUES ('PED-001', '34987645A', '2026-11-11','Pendiente');

INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, estado)
VALUES ('PED-002', '37456159Q','2026-11-11','Pendiente');
SELECT * FROM Pedidos;

INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, estado)
VALUES ('PED-003','37456159Q','2026-11-11','Pendiente');

INSERT INTO Detalles_pedido (id_detalle, id_pedido, id_producto, cantidad, precio_unidad)
VALUES (1, 'PED-001', 'KIM-001', 1, 45.50);
INSERT INTO Detalles_pedido (id_detalle, id_pedido, id_producto, cantidad, precio_unidad)
VALUES (2, 'PED-002', 'CIN-001', 2, 10);
-- ===== MÁS DATOS DE PRUEBA =====
INSERT INTO Clientes (dni, nombre, apellidos, telefono, email) VALUES
('45123678B', 'Hana',   'Suzuki López',   '611222333', 'hana@samurai.es'),
('52987412C', 'Kenji',  'Pérez Tanaka',   '622333444', 'kenji@samurai.es'),
('61478523D', 'Lucía',  'Rey Sato',       '633444555', 'lucia@samurai.es'),
('70258963E', 'Takeshi','Fernández Mori', '644555666', 'takeshi@samurai.es');

INSERT INTO Productos (id_producto, nombre, descripcion, precio, stock, id_categoria) VALUES
('HAK-001', 'Hakama negro',      'Pantalón tradicional de entrenamiento', 59.90, 10, 'ROP'),
('BOK-001', 'Bokken de roble',   'Espada de madera de roble',             30.00, 15, 'ARM'),
('SHI-001', 'Shinai',            'Espada de bambú para kendo',            42.00,  8, 'ARM'),
('TAN-001', 'Tanto de madera',   'Cuchillo de madera para prácticas',     12.50, 25, 'ARM'),
('GUA-001', 'Guantes de combate','Guantes acolchados',                    22.00, 30, 'ACC'),
('BOL-001', 'Bolsa de deporte',  'Bolsa con el logo de la escuela',       25.00, 12, 'ACC'),
('PRO-001', 'Protector bucal',   'Protector bucal moldeable',              6.50, 40, 'ACC');

INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, estado) VALUES
('PED-004', '45123678B', '2026-11-12', 'Enviado'),
('PED-005', '45123678B', '2026-11-13', 'Pendiente'),
('PED-006', '52987412C', '2026-11-13', 'Entregado'),
('PED-007', '34987645A', '2026-11-14', 'Pendiente'),
('PED-008', '52987412C', '2026-11-15', 'Pendiente');

INSERT INTO Detalles_pedido (id_detalle, id_pedido, id_producto, cantidad, precio_unidad) VALUES
(3,  'PED-003', 'BOK-001', 1, 30.00),
(4,  'PED-003', 'PRO-001', 2,  6.50),
(5,  'PED-004', 'KIM-001', 1, 45.50),
(6,  'PED-004', 'CIN-001', 1, 10.00),
(7,  'PED-004', 'GUA-001', 1, 22.00),
(8,  'PED-005', 'BOK-001', 1, 30.00),
(9,  'PED-006', 'SHI-001', 1, 42.00),
(10, 'PED-006', 'HAK-001', 1, 59.90),
(11, 'PED-006', 'BOK-001', 2, 30.00),
(12, 'PED-007', 'GUA-001', 1, 22.00),
(13, 'PED-007', 'PRO-001', 1,  6.50),
(14, 'PED-008', 'TAN-001', 3, 12.50),
(15, 'PED-008', 'BOK-001', 1, 30.00);

-- =====================================================
-- CONSULTA 1: Total de ventas por categoría de producto
-- Pregunta: ¿Cuánto dinero hemos ganado con cada categoría?
-- =====================================================
SELECT cat.nombre AS categoria,
       SUM(d.cantidad * d.precio_unidad) AS total_ventas
FROM categorias cat
JOIN Productos pr       ON cat.id_categoria = pr. id_categoria
JOIN Detalles_pedido d  ON pr.id_producto = d. id_producto
GROUP BY cat.id_categoria, cat.nombre
ORDER BY total_ventas DESC;

-- =====================================================
-- CONSULTA 2: Promedio de gasto por cliente
-- Pregunta: ¿Cuánto se gasta de media cada alumno en cada pedido?
-- Se hace en dos pasos:
--   Paso A: calcular el total (ticket) de cada pedido con SUM
--   Paso B: calcular la media de los tickets de cada alumno con AVG
-- =====================================================
-- Paso A: el total (ticket) de cada pedido
SELECT p.id_pedido,
       p.dni_cliente,
       SUM(d.cantidad * d.precio_unidad) AS total_pedido
FROM Pedidos p
JOIN Detalles_pedido d  ON p.id_pedido = d.id_pedido
GROUP BY p.id_pedido, p.dni_cliente;
-- ==========================================================
-- Paso B: La media de los tickets de cada alumno con AVG
SELECT c.nombre,
       c.apellidos,
       ROUND(AVG(t.total_pedido), 2) AS gasto_medio
FROM Clientes c
JOIN (
      SELECT p.id_pedido,
             p.dni_cliente,
             SUM(d.cantidad * d.precio_unidad) AS total_pedido
      FROM Pedidos p
      JOIN Detalles_pedido d ON p.id_pedido = d.id_pedido
      GROUP BY p.id_pedido, p.dni_cliente
     ) t  ON c.dni = t.dni_cliente 
GROUP BY c.dni, c.nombre, c.apellidos
ORDER BY gasto_medio DESC;
-- =====================================================
-- CONSULTA 3: Productos más vendidos
-- Pregunta: ¿Qué productos se venden más?
-- =====================================================
SELECT pr.nombre,
       COUNT(d.id_detalle) AS veces_pedido
FROM Productos pr
JOIN Detalles_pedido d  ON pr.id_producto  = d.id_producto
GROUP BY pr.id_producto, pr.nombre
ORDER BY veces_pedido DESC;

-- =====================================================
-- CONSULTA 4: Clientes sin pedidos
-- Pregunta: ¿ Quién no ha realizado ningún pedido?
-- =====================================================
SELECT c.nombre,
       c.apellidos
FROM Clientes c
LEFT JOIN Pedidos p  ON c.dni = p.dni_cliente
WHERE p.id_pedido IS NULL;