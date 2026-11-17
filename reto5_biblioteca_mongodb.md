# Reto 5: Importación y exportación de datos en MongoDB

Autora: Aldara
Curso: Sistemas Gestores de Bases de Datos, Nivel 4 (Código Samurái)

## Herramientas utilizadas

- MongoDB Community Server (base de datos en mi ordenador, localhost:27017)
- MongoDB Compass y su consola mongosh (para las consultas)
- MongoDB Database Tools (mongoimport y mongoexport, que se descargan aparte)
- Archivo de partida: libros.json (20 libros)

## Paso 1: Importar los datos

En la ventana de comandos de Windows (cmd), dentro de la carpeta bin
de las Database Tools, donde también puse el archivo libros.json:

    mongoimport --db biblioteca --collection libros --file libros.json --jsonArray

- --db biblioteca: crea (o usa) la base de datos "biblioteca".
- --collection libros: guarda los datos en la colección "libros".
- --jsonArray: indica que el archivo es una lista de documentos entre [ ].

Resultado: 20 documentos importados y 0 fallos.

## Paso 2: Libros publicados antes de 1950

En la consola mongosh de Compass, primero entro en la base de datos:

    use biblioteca

    db.libros.find({ anioPublicacion: { $lt: 1950 } })

- $lt significa "menor que" (less than).

Resultado: 14 libros, desde La Divina Comedia (1320) hasta 1984 (1949).

## Paso 3: Libros del género Fantasía

    db.libros.find({ genero: "Fantasia" })

Importante: en el archivo libros.json los datos están escritos SIN tildes
("Fantasia"). Si se busca "Fantasía" con tilde, como pone en la ayuda del
reto, no aparece ningún resultado.

Resultado: 3 libros (El Hobbit, Harry Potter y la piedra filosofal,
El señor de los anillos).

## Paso 4: Libros escritos por J.R.R. Tolkien

    db.libros.find({ autores: "J.R.R. Tolkien" })

El campo "autores" es una lista. MongoDB busca dentro de la lista y
encuentra el autor aunque el libro tenga varios.

Resultado: 2 libros (El Hobbit y El señor de los anillos).

## Paso 5: Contar cuántos libros hay de cada género

    db.libros.aggregate([ { $group: { _id: "$genero", total: { $sum: 1 } } } ])

- $group agrupa los libros por género (como GROUP BY en SQL).
- $sum: 1 suma 1 por cada libro del grupo (como COUNT en SQL).

Resultado: 13 géneros. Por ejemplo: Fantasia 3, Novela 3, Modernista 2,
Ciencia ficcion 2 y Terror 2. La suma de todos los totales da 20.

## Paso 6: Exportar los libros de Fantasía a otro JSON

En la ventana de comandos de Windows:

    mongoexport --db biblioteca --collection libros --query "{\"genero\": \"Fantasia\"}" --out libros_fantasia.json

Cambios respecto a la ayuda del reto:
- "Fantasia" sin tilde, igual que en los datos.
- En Windows, la consulta va entre comillas dobles y las comillas de
  dentro llevan una barra \ delante. Las comillas simples ' ' de la
  ayuda no funcionan en la ventana de comandos de Windows.
- En la ayuda pone "–jsonArray" con un guion largo; hay que escribir
  dos guiones normales: --jsonArray.

Resultado: 3 documentos exportados al archivo libros_fantasia.json.
Cada libro aparece en una línea, con su _id generado por MongoDB.

## Lo que he aprendido

- MongoDB guarda documentos (fichas) en colecciones, en lugar de filas en tablas.
- mongoimport y mongoexport se usan desde la ventana de comandos,
  no desde dentro de MongoDB.
- Hay que fijarse muy bien en cómo están escritos los datos
  (tildes, mayúsculas) porque la búsqueda tiene que ser exacta.