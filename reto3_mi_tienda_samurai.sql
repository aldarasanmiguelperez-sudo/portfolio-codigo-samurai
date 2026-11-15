   -- Reto 3: Tienda online Escuela Bojo Bushido
   -- Autora: Aldara
   -- Probado en SQL Server (OneCompiler)


DROP TABLE IF EXISTS Detalles_pedido;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Clientes;
-- PARTE 1: CREACIÓN DE TABLAS
CREATE TABLE Clientes (dni VARCHAR(10) PRIMARY KEY, nombre NVARCHAR(20) NOT NULL, apellidos NVARCHAR(30) NOT NULL, telefono VARCHAR(12), email VARCHAR(40) UNIQUE);
CREATE TABLE categorias
(id_categoria VARCHAR(3) PRIMARY KEY,
nombre NVARCHAR(10) NOT NULL UNIQUE);
CREATE TABLE Productos
(id_producto VARCHAR(10) PRIMARY KEY,
nombre NVARCHAR(30) NOT NULL UNIQUE,
descripcion NVARCHAR(60) NOT NULL,
precio DECIMAL(8,2) NOT NULL CHECK (precio > 0),
stock INT NOT NULL CHECK (stock >= 0),
id_categoria VARCHAR(3) NOT NULL,
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria));

CREATE TABLE Pedidos
(id_pedido VARCHAR(10) PRIMARY KEY,
dni_cliente VARCHAR(10) NOT NULL,
fecha_pedido DATE NOT NULL DEFAULT GETDATE(),
estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente' , 'Enviado' , 'Entregado')),
FOREIGN KEY (dni_cliente) REFERENCES Clientes(dni));

CREATE TABLE Detalles_pedido
(id_detalle INT PRIMARY KEY,
id_pedido VARCHAR(10) NOT NULL,
id_producto VARCHAR(10) NOT NULL,
cantidad INT NOT NULL CHECK(cantidad >= 1),
precio_unidad DECIMAL(8,2) NOT NULL CHECK(precio_unidad >0),
FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
FOREIGN KEY (id_producto) REFERENCES Productos (id_producto));
-- PARTE 2: INSERCIÓN DE DATOS
INSERT INTO Clientes (dni, nombre, apellidos, telefono, email)
VALUES ('34987645A', 'Alberto', 'Kinto Kawasaki','600123456', 'alberto@samurai.es');

INSERT INTO Clientes (dni, nombre,apellidos, telefono, email)
VALUES ( '37456159Q', 'Novita', 'Nohara Honda', '684120035', 'novitaNH@doraemon.com');


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

-- ========================================================
-- PARTE 3: CONSULTAS BÁSICAS
-- =============================================================

-- Consulta A: ¿Qué productos tenemos disponibles en el almacén?
SELECT nombre, precio, stock
FROM Productos
WHERE stock > 0;

-- ==============================================================
-- Consulta B: ¿Quiénes son nuestros alumnos?
SELECT *
FROM Clientes
ORDER BY apellidos;
--=====================================================
-- Consulta C: ¿qué pedidos se hicieron el 13 de noviembre de 2026?
SELECT *
FROM Pedidos
WHERE fecha_pedido = '2026-11-13';
-- =====================================================
-- PARTE 4: FUNCIÓN EN T-SQL
-- Pregunta: ¿Cuántas veces se ha pedido cada producto?
-- La función recibe un id_producto y devuelve cuántas
-- veces aparece en los detalles de pedido.
-- =====================================================
GO
CREATE FUNCTION dbo.VecesPedido (@id_producto VARCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @veces INT;

    SELECT @veces = COUNT(*)
    FROM Detalles_pedido
    WHERE id_producto = @id_producto;

    RETURN @veces;
END;
GO
-- Prueba: ¿cuántas veces se ha pedido el Bokken?
SELECT dbo.VecesPedido('BOK-001') AS veces_bokken;
-- Uso de la función: veces que se ha pedido cada producto
SELECT nombre,
       dbo.VecesPedido(id_producto) AS veces_pedido
FROM Productos
ORDER BY veces_pedido DESC;
