-- ======================================================================================
-- Eliminacion De Tablas
-- ======================================================================================
DROP TABLE Lenguaje CASCADE CONSTRAINTS;
DROP TABLE Clasificacion CASCADE CONSTRAINTS;
DROP TABLE Actor CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Puesto CASCADE CONSTRAINTS;
DROP TABLE Estado CASCADE CONSTRAINTS;
DROP TABLE Pais CASCADE CONSTRAINTS;
DROP TABLE Ciudad CASCADE CONSTRAINTS;
DROP TABLE Direccion CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Tienda CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Pelicula CASCADE CONSTRAINTS;
DROP TABLE Categoria_Pelicula CASCADE CONSTRAINTS;
DROP TABLE Pelicula_Actor CASCADE CONSTRAINTS;
DROP TABLE Lenguaje_Pelicula CASCADE CONSTRAINTS;
DROP TABLE Alquiler CASCADE CONSTRAINTS;
DROP TABLE Pelicula_Alquiler CASCADE CONSTRAINTS;
DROP TABLE Inventario CASCADE CONSTRAINTS;

-- ======================================================================================
-- Creando Tabla Lenguaje
-- ======================================================================================
CREATE TABLE Lenguaje(
    idLenguaje INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    descripcion VARCHAR2(40) NOT NULL
);

ALTER TABLE Lenguaje 
    ADD CONSTRAINT PK_Lenguaje
        PRIMARY KEY(idLenguaje);

-- ======================================================================================
-- Creando Tabla Clasificacion
-- ======================================================================================
CREATE TABLE Clasificacion(
    idClasificacion INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    descripcion VARCHAR2(4) NOT NULL
);

ALTER TABLE Clasificacion 
    ADD CONSTRAINT PK_Clasificacion
        PRIMARY KEY(idClasificacion);

-- ======================================================================================
-- Creando Tabla Actor
-- ======================================================================================
CREATE TABLE Actor(
    idActor INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(30) NOT NULL,
    apellido VARCHAR2(30) NOT NULL
);

ALTER TABLE Actor 
    ADD CONSTRAINT PK_Actor
        PRIMARY KEY(idActor);
-- ======================================================================================
-- Creando Tabla Categoria
-- ======================================================================================
CREATE TABLE Categoria(
    idCategoria INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    descripcion VARCHAR2(40) NOT NULL
);

ALTER TABLE Categoria 
    ADD CONSTRAINT PK_Categoria
        PRIMARY KEY(idCategoria);

-- ======================================================================================
-- Creando Tabla Puesto
-- ======================================================================================
CREATE TABLE Puesto(
    idPuesto INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    descripcion VARCHAR2(30) NOT NULL
);

ALTER TABLE Puesto 
    ADD CONSTRAINT PK_Puesto
        PRIMARY KEY(idPuesto);

-- ======================================================================================
-- Creando Tabla Estado
-- ======================================================================================
CREATE TABLE Estado(
    idEstado INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    estado VARCHAR2(3) NOT NULL
);

ALTER TABLE Estado 
    ADD CONSTRAINT PK_Estado
        PRIMARY KEY(idEstado);

-- ======================================================================================
-- Creando Tabla Pais
-- ======================================================================================
CREATE TABLE Pais(
    idPais INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    pais VARCHAR2(40) NOT NULL
);

ALTER TABLE Pais 
    ADD CONSTRAINT PK_Pais
        PRIMARY KEY(idPais);

-- ======================================================================================
-- Creando Tabla Ciudad
-- ======================================================================================
CREATE TABLE Ciudad(
    idCiudad INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    ciudad VARCHAR2(40) NOT NULL,
    idPais  INTEGER NOT NULL
);

ALTER TABLE Ciudad 
    ADD CONSTRAINT PK_Ciudad
        PRIMARY KEY(idCiudad);

ALTER TABLE Ciudad
    ADD CONSTRAINT FK_Pais_Ciudad
        FOREIGN KEY (idPais)
            REFERENCES Pais(idPais) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Direccion
-- ======================================================================================
CREATE TABLE Direccion(
    idDireccion INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    direccion VARCHAR2(100) NOT NULL,
    codigoPostal INTEGER NOT NULL,
    idCiudad  INTEGER NOT NULL
);

ALTER TABLE Direccion 
    ADD CONSTRAINT PK_Direccion
        PRIMARY KEY(idDireccion);

ALTER TABLE Direccion
    ADD CONSTRAINT FK_Ciudad_Direccion
        FOREIGN KEY (idCiudad)
            REFERENCES Ciudad(idCiudad) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Cliente
-- ======================================================================================
CREATE TABLE Cliente(
    idCliente INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(40) NOT NULL,
    apellido VARCHAR2(40) NOT NULL,
    correoElectronico VARCHAR2(80) NOT NULL,
    fechaRegistro TIMESTAMP,  
    idEstado INTEGER NOT NULL,
    idDireccion INTEGER NOT NULL
);

ALTER TABLE Cliente 
    ADD CONSTRAINT PK_Cliente
        PRIMARY KEY(idCliente);

ALTER TABLE Cliente
    ADD CONSTRAINT FK_Estado_Cliente
        FOREIGN KEY (idEstado)
            REFERENCES Estado(idEstado) ON DELETE CASCADE;

ALTER TABLE Cliente
    ADD CONSTRAINT FK_Direccion_Cliente
        FOREIGN KEY (idDireccion)
            REFERENCES Direccion(idDireccion) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Tienda
-- ======================================================================================
CREATE TABLE Tienda(
    idTienda INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(30) NOT NULL,
    idDireccion INTEGER NOT NULL
);

ALTER TABLE Tienda 
    ADD CONSTRAINT PK_Tienda
        PRIMARY KEY(idTienda);

ALTER TABLE Tienda
    ADD CONSTRAINT FK_Direccion_Tienda
        FOREIGN KEY (idDireccion)
            REFERENCES Direccion(idDireccion) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Empleado
-- ======================================================================================
CREATE TABLE Empleado(
    idEmpleado INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(40) NOT NULL,
    apellido VARCHAR2(40) NOT NULL,
    correoElectronico VARCHAR2(80) NOT NULL,
    usuario VARCHAR2(200) NOT NULL,
    contrasena VARCHAR2(200) NOT NULL,  
    idTienda INTEGER NOT NULL,
    idEstado INTEGER NOT NULL,
    idPuesto INTEGER NOT NULL,
    idDireccion INTEGER NOT NULL
);

ALTER TABLE Empleado 
    ADD CONSTRAINT PK_Empleado
        PRIMARY KEY(idEmpleado);

ALTER TABLE Empleado
    ADD CONSTRAINT FK_Estado_Empleado
        FOREIGN KEY (idEstado)
            REFERENCES Estado(idEstado) ON DELETE CASCADE;

ALTER TABLE Empleado
    ADD CONSTRAINT FK_Tienda_Empleado
        FOREIGN KEY (idTienda)
            REFERENCES Tienda(idTienda) ON DELETE CASCADE;

ALTER TABLE Empleado
    ADD CONSTRAINT FK_Puesto_Empleado
        FOREIGN KEY (idPuesto)
            REFERENCES Puesto(idPuesto) ON DELETE CASCADE;

ALTER TABLE Empleado
    ADD CONSTRAINT FK_Direccion_Empleado
        FOREIGN KEY (idDireccion)
            REFERENCES Direccion(idDireccion) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Pelicula
-- ======================================================================================
CREATE TABLE Pelicula(
    idPelicula INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    titulo VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(2000) NOT NULL,
    anoLanzamiento INTEGER NOT NULL,
    duracion INTEGER,
    costoAlquiler NUMBER(10,2) NOT NULL,  
    costoDano NUMBER(10,2) NOT NULL,  
    tiempoAlquiler INTEGER NOT NULL,  
    idClasificacion INTEGER NOT NULL
);

ALTER TABLE Pelicula 
    ADD CONSTRAINT PK_Pelicula
        PRIMARY KEY(idPelicula);

ALTER TABLE Pelicula
    ADD CONSTRAINT FK_Clasificacion_Pelicula
        FOREIGN KEY (idClasificacion)
            REFERENCES Clasificacion(idClasificacion) ON DELETE CASCADE;
-- ======================================================================================
-- Creando Tabla Categoria_Pelicula
-- ======================================================================================
CREATE TABLE Categoria_Pelicula(
    idCategoria INTEGER NOT NULL,
    idPelicula  INTEGER NOT NULL
);

ALTER TABLE Categoria_Pelicula 
    ADD CONSTRAINT PK_Categoria_Pelicula
        PRIMARY KEY(idCategoria,idPelicula);

ALTER TABLE Categoria_Pelicula
    ADD CONSTRAINT FK_Categoria_Pelicula_Categoria
        FOREIGN KEY (idCategoria)
            REFERENCES Categoria(idCategoria) ON DELETE CASCADE;

ALTER TABLE Categoria_Pelicula
    ADD CONSTRAINT FK_Clasificacion_Pelicula_Pelicula
        FOREIGN KEY (idPelicula)
            REFERENCES Pelicula(idPelicula) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Pelicula_Actor
-- ======================================================================================
CREATE TABLE Pelicula_Actor(
    idActor INTEGER NOT NULL,
    idPelicula  INTEGER NOT NULL
);

ALTER TABLE Pelicula_Actor 
    ADD CONSTRAINT PK_Pelicula_Actor
        PRIMARY KEY(idActor,idPelicula);

ALTER TABLE Pelicula_Actor
    ADD CONSTRAINT FK_Pelicula_Actor_Actor
        FOREIGN KEY (idActor)
            REFERENCES Actor(idActor) ON DELETE CASCADE;

ALTER TABLE Pelicula_Actor
    ADD CONSTRAINT FK_Pelicula_Actor_Pelicula
        FOREIGN KEY (idPelicula)
            REFERENCES Pelicula(idPelicula) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Lenguaje_Pelicula
-- ======================================================================================
CREATE TABLE Lenguaje_Pelicula(
    idLenguaje INTEGER NOT NULL,
    idPelicula  INTEGER NOT NULL
);

ALTER TABLE Lenguaje_Pelicula 
    ADD CONSTRAINT PK_Lenguaje_Pelicula
        PRIMARY KEY(idLenguaje,idPelicula);

ALTER TABLE Lenguaje_Pelicula
    ADD CONSTRAINT FK_Lenguaje_Pelicula_Lenguaje
        FOREIGN KEY (idLenguaje)
            REFERENCES Lenguaje(idLenguaje) ON DELETE CASCADE;

ALTER TABLE Lenguaje_Pelicula
    ADD CONSTRAINT FK_Lenguaje_Pelicula_Pelicula
        FOREIGN KEY (idPelicula)
            REFERENCES Pelicula(idPelicula) ON DELETE CASCADE;
-- ======================================================================================
-- Creando Tabla Alquiler
-- ======================================================================================
CREATE TABLE Alquiler(
    idAlquiler INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    monto   NUMBER(10,2) NOT NULL,
    fechaPago   TIMESTAMP NOT NULL,
    fechaRenta  TIMESTAMP NOT NULL,
    fechaDevolucion TIMESTAMP NOT NULL,
    idTienda    INTEGER NOT NULL,
    idCliente   INTEGER NOT NULL
);

ALTER TABLE Alquiler 
    ADD CONSTRAINT PK_Alquiler
        PRIMARY KEY(idAlquiler);

ALTER TABLE Alquiler
    ADD CONSTRAINT FK_Alquiler_Tienda
        FOREIGN KEY (idTienda)
            REFERENCES Tienda(idTienda) ON DELETE CASCADE;

ALTER TABLE Alquiler
    ADD CONSTRAINT FK_Alquiler_Cliente
        FOREIGN KEY (idCliente)
            REFERENCES Cliente(idCliente) ON DELETE CASCADE;

-- ======================================================================================
-- Creando Tabla Pelicula_Alquiler
-- ======================================================================================
CREATE TABLE Pelicula_Alquiler(
    idAlquiler INTEGER NOT NULL,
    idPelicula  INTEGER NOT NULL
);

ALTER TABLE Pelicula_Alquiler 
    ADD CONSTRAINT PK_Pelicula_Alquiler
        PRIMARY KEY(idAlquiler,idPelicula);

ALTER TABLE Pelicula_Alquiler
    ADD CONSTRAINT FK_Pelicula_Alquiler_Alquiler
        FOREIGN KEY (idAlquiler)
            REFERENCES Alquiler(idAlquiler) ON DELETE CASCADE;

ALTER TABLE Pelicula_Alquiler
    ADD CONSTRAINT FK_Pelicula_Alquiler_Pelicula
        FOREIGN KEY (idPelicula)
            REFERENCES Pelicula(idPelicula) ON DELETE CASCADE;

 -- ======================================================================================
-- Creando Tabla Inventario
-- ======================================================================================
CREATE TABLE Inventario(
    idTienda INTEGER NOT NULL,
    idPelicula  INTEGER NOT NULL
);

ALTER TABLE Inventario 
    ADD CONSTRAINT PK_Inventario
        PRIMARY KEY(idTienda,idPelicula);

ALTER TABLE Inventario
    ADD CONSTRAINT FK_Inventario_Tienda
        FOREIGN KEY (idTienda)
            REFERENCES Tienda(idTienda) ON DELETE CASCADE;

ALTER TABLE Inventario
    ADD CONSTRAINT FK_Inventario_Pelicula
        FOREIGN KEY (idPelicula)
            REFERENCES Pelicula(idPelicula) ON DELETE CASCADE;           