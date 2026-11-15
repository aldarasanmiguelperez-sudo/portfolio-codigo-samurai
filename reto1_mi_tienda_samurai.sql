-- =====================================================================
--  RETO 1 - SGBD Nivel 3, Unidad 1
--  Base de datos: Tienda online de la Escuela Bojo Bushido
--                 de Tronchavacas de Arriba
--  Autora: Aldara
--  Probado en: SQLite (con DBeaver Community)
-- =====================================================================

-- En SQLite la base de datos es el propio archivo (.db), por eso
-- esta orden va comentada. En MySQL o SQL Server se usaria asi:
-- CREATE DATABASE tienda_samurai;
-- USE tienda_samurai;

-- SQLite trae las claves foraneas desactivadas: las activamos.
PRAGMA foreign_keys = ON;

-- Borramos las tablas si ya existen (para poder ejecutar el script
-- varias veces). Se borran en orden inverso por las relaciones.
DROP TABLE IF EXISTS Detalles_pedido;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;


-- ---------------------------------------------------------------------
-- 1. CLIENTES (el alumnado de la escuela)
-- ---------------------------------------------------------------------
CREATE TABLE Clientes (
    id_cliente      INTEGER       PRIMARY KEY,
    nombre          VARCHAR(50)   NOT NULL,
    apellidos       VARCHAR(100)  NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    telefono        VARCHAR(15),
    fecha_alta      DATE          NOT NULL DEFAULT CURRENT_DATE
);


-- ---------------------------------------------------------------------
-- 2. PRODUCTOS (material que se pide a Japon)
-- ---------------------------------------------------------------------
CREATE TABLE Productos (
    id_producto     INTEGER       PRIMARY KEY,
    nombre          VARCHAR(100)  NOT NULL UNIQUE,
    descripcion     VARCHAR(255),
    precio          DECIMAL(8,2)  NOT NULL CHECK (precio > 0),
    stock           INTEGER       NOT NULL DEFAULT 0 CHECK (stock >= 0)
);


-- ---------------------------------------------------------------------
-- 3. PEDIDOS
--    Relacion 1:N con Clientes: un cliente puede hacer muchos pedidos,
--    pero cada pedido pertenece a un solo cliente.
-- ---------------------------------------------------------------------
CREATE TABLE Pedidos (
    id_pedido       INTEGER       PRIMARY KEY,
    id_cliente      INTEGER       NOT NULL,
    fecha_pedido    DATE          NOT NULL DEFAULT CURRENT_DATE,
    estado          VARCHAR(20)   NOT NULL DEFAULT 'Pendiente'
                    CHECK (estado IN ('Pendiente', 'Enviado', 'Entregado', 'Cancelado')),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);


-- ---------------------------------------------------------------------
-- 4. DETALLES_PEDIDO (tabla "puente")
--    Resuelve la relacion N:N entre Pedidos y Productos:
--    un pedido lleva muchos productos y un producto aparece en
--    muchos pedidos. Cada fila = un producto dentro de un pedido.
-- ---------------------------------------------------------------------
CREATE TABLE Detalles_pedido (
    id_detalle      INTEGER       PRIMARY KEY,
    id_pedido       INTEGER       NOT NULL,
    id_producto     INTEGER       NOT NULL,
    cantidad        INTEGER       NOT NULL CHECK (cantidad >= 1),
    precio_unidad   DECIMAL(8,2)  NOT NULL CHECK (precio_unidad > 0),
    FOREIGN KEY (id_pedido)   REFERENCES Pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    -- El mismo producto no se repite dos veces en el mismo pedido
    UNIQUE (id_pedido, id_producto)
);


-- =====================================================================
--  DATOS DE PRUEBA (para comprobar que todo funciona)
-- =====================================================================

INSERT INTO Clientes (id_cliente, nombre, apellidos, email, telefono) VALUES
    (1, 'Hana',  'Lopez Garcia',   'hana@bojobushido.es',  '600111222'),
    (2, 'Kenji', 'Perez Martinez', 'kenji@bojobushido.es', '600333444'),
    (3, 'Lucia', 'Fernandez Rey',  'lucia@bojobushido.es', NULL);

INSERT INTO Productos (id_producto, nombre, descripcion, precio, stock) VALUES
    (1, 'Kimono blanco',    'Kimono de algodon para entrenamiento', 45.00, 20),
    (2, 'Bokken',           'Espada de madera de roble',            30.00, 15),
    (3, 'Cinturon (obi)',   'Cinturon de colores segun el grado',    8.50, 50),
    (4, 'Bolsa de deporte', 'Bolsa con el logo de la escuela',      25.00, 10);

INSERT INTO Pedidos (id_pedido, id_cliente, fecha_pedido, estado) VALUES
    (1, 1, '2026-11-01', 'Enviado'),
    (2, 2, '2026-11-05', 'Pendiente'),
    (3, 1, '2026-11-08', 'Pendiente');

INSERT INTO Detalles_pedido (id_pedido, id_producto, cantidad, precio_unidad) VALUES
    (1, 1, 1, 45.00),
    (1, 3, 2,  8.50),
    (2, 2, 1, 30.00),
    (3, 4, 1, 25.00);


-- =====================================================================
--  CONSULTA DE COMPROBACION
--  Que ha pedido cada alumno, cuanto y por que importe.
-- =====================================================================
SELECT  c.nombre || ' ' || c.apellidos   AS alumno,
        p.id_pedido,
        p.fecha_pedido,
        pr.nombre                       AS producto,
        d.cantidad,
        d.cantidad * d.precio_unidad    AS importe
FROM Clientes c
INNER JOIN Pedidos p          ON c.id_cliente  = p.id_cliente
INNER JOIN Detalles_pedido d  ON p.id_pedido   = d.id_pedido
INNER JOIN Productos pr       ON d.id_producto = pr.id_producto
ORDER BY p.id_pedido;
