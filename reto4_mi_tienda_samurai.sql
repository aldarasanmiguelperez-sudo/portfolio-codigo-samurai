-- =============================================
-- RETO 4: Procedimientos almacenados en Oracle
-- Tienda samurái (Escuela Bojo Bushido)
-- Autora: Aldara
-- =============================================

-- =============================================
-- PARTE 1: CREACIÓN DE LAS TABLAS
-- En Oracle, cada usuario guarda sus tablas en su propio
-- esquema (su "base de datos"). Aquí trabajamos en el
-- esquema de OneCompiler.
-- =============================================

CREATE TABLE Clientes (
    dni        VARCHAR2(10) PRIMARY KEY,
    nombre     VARCHAR2(30) NOT NULL,
    apellidos  VARCHAR2(50) NOT NULL,
    direccion  VARCHAR2(100)
);

CREATE TABLE Pedidos (
    id_pedido     VARCHAR2(10) PRIMARY KEY,
    dni_cliente   VARCHAR2(10) NOT NULL,
    fecha_pedido  DATE DEFAULT SYSDATE NOT NULL,
    total         NUMBER(8,2) CHECK (total >= 0),
    FOREIGN KEY (dni_cliente) REFERENCES Clientes(dni)
);

-- =============================================
-- PARTE 2: DATOS DE EJEMPLO
-- =============================================

-- Clientes de la tienda samurái
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('34987645A', 'Alberto', 'Kinto Kawasaki', 'Rúa do Paseo 12, Ourense');
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('44512378B', 'Novita', 'Sanz Ferreiro', 'Avenida de Portugal 45, Ourense');
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('39874521C', 'Hana', 'Tanaka Pérez', 'Rúa Santo Domingo 3, Ourense');
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('76543210D', 'Kenji', 'Yamamoto López', 'Rúa Progreso 88, Ourense');
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('35678912E', 'Lucía', 'Gómez Rivas', 'Praza Maior 7, Ourense');
INSERT INTO Clientes (dni, nombre, apellidos, direccion) VALUES ('44889900F', 'Takeshi', 'Mori Castro', 'Rúa da Paz 21, Ourense');

-- Pedidos (Takeshi no tiene pedidos: nos servirá para probar el borrado)
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-001', '34987645A', DATE '2026-11-10', 45.50);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-002', '44512378B', DATE '2026-11-10', 120.00);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-003', '39874521C', DATE '2026-11-12', 89.90);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-004', '34987645A', DATE '2026-11-13', 35.00);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-005', '76543210D', DATE '2026-11-13', 210.75);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-006', '35678912E', DATE '2026-11-15', 64.30);
INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total) VALUES ('PED-007', '44512378B', DATE '2026-11-15', 15.00);

-- Comprobamos que los datos han entrado bien
SELECT * FROM Clientes;
SELECT * FROM Pedidos;

-- =============================================
-- PARTE 3: PROCEDIMIENTOS CRUD
-- =============================================

-- ➕ CREAR: insertar_cliente
-- Recibe los datos de un cliente nuevo y lo guarda en la tabla Clientes.
-- Si el DNI ya existe, no se rompe: avisa con un mensaje de error
-- (excepción DUP_VAL_ON_INDEX = valor duplicado en la clave primaria).

CREATE OR REPLACE PROCEDURE insertar_cliente (
    p_dni        IN VARCHAR2,
    p_nombre     IN VARCHAR2,
    p_apellidos  IN VARCHAR2,
    p_direccion  IN VARCHAR2
) AS
BEGIN
    INSERT INTO Clientes (dni, nombre, apellidos, direccion)
    VALUES (p_dni, p_nombre, p_apellidos, p_direccion);

    DBMS_OUTPUT.PUT_LINE('Cliente añadido: ' || p_nombre);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: ya existe un cliente con el DNI ' || p_dni);
END;
/
-- Prueba 1: un cliente nuevo (debe funcionar ✅)
-- Prueba 2: un DNI que ya existe (debe avisar del error 🚨)
SET SERVEROUTPUT ON;
BEGIN
    insertar_cliente('11223344G', 'Sakura', 'Ito Varela', 'Rúa Nova 5, Ourense');
    insertar_cliente('34987645A', 'Alberto', 'Kinto Kawasaki', 'Rúa do Paseo 12, Ourense');
END;
/

-- ➕ CREAR: insertar_pedido
-- Recibe los datos de un pedido nuevo y lo guarda en la tabla Pedidos.
-- Avisa si el pedido ya existe o si hay cualquier otro error
-- (por ejemplo, que el cliente no exista).

CREATE OR REPLACE PROCEDURE insertar_pedido (
    p_id_pedido    IN VARCHAR2,
    p_dni_cliente  IN VARCHAR2,
    p_fecha        IN DATE,
    p_total        IN NUMBER
) AS
BEGIN
    INSERT INTO Pedidos (id_pedido, dni_cliente, fecha_pedido, total)
    VALUES (p_id_pedido, p_dni_cliente, p_fecha, p_total);

    DBMS_OUTPUT.PUT_LINE('Pedido añadido: ' || p_id_pedido);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: ya existe el pedido ' || p_id_pedido);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al añadir el pedido: ' || SQLERRM);
END;
/

-- Prueba 1: un pedido nuevo de Sakura (debe funcionar ✅)
-- Prueba 2: un pedido que ya existe (debe avisar 🚨)
-- Prueba 3: un cliente que no existe (debe avisar 🚨)
BEGIN
  insertar_pedido('PED-008', '11223344G', DATE '2026-11-16', 75.00);
  insertar_pedido('PED-001', '34987645A', DATE '2026-11-16', 20.00);
  insertar_pedido('PED-009', '00000000Z', DATE '2026-11-16', 50.00);
END;
/

-- 🔍 LEER: buscar_pedidos_por_fecha
-- Recibe una fecha y muestra todos los pedidos de ese día.
-- Usa un bucle FOR para recorrer los resultados fila por fila.
-- Si no encuentra ninguno, avisa con un mensaje.

CREATE OR REPLACE PROCEDURE buscar_pedidos_por_fecha (
    p_fecha IN DATE
) AS
    v_encontrados NUMBER := 0;
BEGIN
    FOR fila IN (SELECT id_pedido, dni_cliente, total
                 FROM Pedidos
                 WHERE fecha_pedido = p_fecha) LOOP
        DBMS_OUTPUT.PUT_LINE(fila.id_pedido || ' - ' || fila.dni_cliente || ' - ' || fila.total || ' €');
        v_encontrados := v_encontrados + 1;
    END LOOP;

    IF v_encontrados = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay pedidos en esa fecha');
    END IF;
END;
/

-- Prueba 1: el día 13 (debe encontrar 2 pedidos ✅)
-- Prueba 2: un día sin pedidos (debe avisar 🚨)

BEGIN
  buscar_pedidos_por_fecha(DATE '2026-11-13');
  buscar_pedidos_por_fecha(DATE '2026-12-25');
END;
/

-- 🔍 LEER: buscar_clientes_por_nombre
-- Recibe un nombre y muestra los clientes que se llaman así.
-- Si no encuentra ninguno, avisa con un mensaje.

CREATE OR REPLACE PROCEDURE buscar_clientes_por_nombre (
    p_nombre IN VARCHAR2
) AS
    v_encontrados NUMBER := 0;
BEGIN
    FOR fila IN (SELECT dni, nombre, apellidos, direccion
                 FROM Clientes
                 WHERE nombre = p_nombre) LOOP
        DBMS_OUTPUT.PUT_LINE(fila.dni || ' - ' || fila.nombre || ' ' || fila.apellidos || ' - ' || fila.direccion);
        v_encontrados := v_encontrados + 1;
    END LOOP;

    IF v_encontrados = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay clientes con ese nombre');
    END IF;
END;
/

-- Prueba 1: un cliente que existe (debe encontrarlo ✅)
-- Prueba 2: un nombre que no existe (debe avisar 🚨)

BEGIN
  buscar_clientes_por_nombre('Hana');
  buscar_clientes_por_nombre('Goku');
END;
/

-- ✏️ ACTUALIZAR: actualizar_direccion
-- Recibe el DNI de un cliente y su nueva dirección, y la cambia.
-- Usa SQL%ROWCOUNT para saber si encontró al cliente:
-- si no ha cambiado ninguna fila, es que el DNI no existe.

CREATE OR REPLACE PROCEDURE actualizar_direccion (
    p_dni              IN VARCHAR2,
    p_nueva_direccion  IN VARCHAR2
) AS
BEGIN
    UPDATE Clientes
    SET   direccion = p_nueva_direccion
    WHERE  dni = p_dni;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: no existe ningún cliente con el DNI ' || p_dni);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dirección actualizada para el DNI ' || p_dni);
    END IF;
END;
/

-- Prueba 1: Kenji se muda (debe funcionar ✅)
-- Prueba 2: un DNI que no existe (debe avisar 🚨)
-- Comprobamos con el buscador que la dirección ha cambiado

BEGIN
  actualizar_direccion('76543210D', 'Rúa do Vilar 15, Ourense');
  actualizar_direccion('00000000Z', 'Rúa Falsa 123, Ourense');
  buscar_clientes_por_nombre('Kenji');
END;
/

-- 🗑️ BORRAR: borrar_cliente
-- Recibe un DNI y borra a ese cliente, pero solo si NO tiene pedidos.
-- Así evitamos dejar pedidos "huérfanos" y respetamos la integridad
-- referencial (la FOREIGN KEY entre Pedidos y Clientes).
-- 1) Cuenta los pedidos del cliente con SELECT COUNT(*) INTO.
-- 2) Si tiene pedidos, no lo borra y avisa.
-- 3) Si no tiene, lo borra; y con SQL%ROWCOUNT comprueba si existía.

CREATE OR REPLACE PROCEDURE borrar_cliente (
    p_dni IN VARCHAR2
) AS
    v_num_pedidos NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_num_pedidos FROM Pedidos WHERE dni_cliente = p_dni;

    IF v_num_pedidos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar: el cliente ' || p_dni || ' tiene ' || v_num_pedidos || ' pedidos');
    ELSE
        DELETE FROM Clientes WHERE dni = p_dni;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: no existe ningún cliente con el DNI ' || p_dni);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cliente borrado: ' || p_dni);
        END IF;
    END IF;
END;
/

-- Prueba 1: Alberto tiene pedidos (no debe borrarlo 🚫)
-- Prueba 2: Takeshi no tiene pedidos (debe borrarlo ✅)
-- Prueba 3: un DNI que no existe (debe avisar 🚨)
-- Comprobamos con el buscador que Takeshi ya no está
BEGIN
  borrar_cliente('34987645A');
  borrar_cliente('44889900F');
  borrar_cliente('00000000Z');
  buscar_clientes_por_nombre('Takeshi');
END;
/
