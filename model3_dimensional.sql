USE modelo03;

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('PaqueteTrabajo', 'U') IS NOT NULL DROP TABLE PaqueteTrabajo;
IF OBJECT_ID('Responsable', 'U') IS NOT NULL DROP TABLE Responsable;
IF OBJECT_ID('Empresa', 'U') IS NOT NULL DROP TABLE Empresa;
IF OBJECT_ID('Localidad', 'U') IS NOT NULL DROP TABLE Localidad;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;
IF OBJECT_ID('Proyecto', 'U') IS NOT NULL DROP TABLE Proyecto;
IF OBJECT_ID('Cliente', 'U') IS NOT NULL DROP TABLE Cliente;

-- Eliminar tablas del MODELO DIMENSIONAL en orden correcto
IF OBJECT_ID('HechoTrabajo', 'U') IS NOT NULL DROP TABLE HechoTrabajo;
IF OBJECT_ID('DimTiempo', 'U') IS NOT NULL DROP TABLE DimTiempo;
IF OBJECT_ID('DimPais', 'U') IS NOT NULL DROP TABLE DimPais;
IF OBJECT_ID('DimLocalidad', 'U') IS NOT NULL DROP TABLE DimLocalidad;
IF OBJECT_ID('DimEmpresa', 'U') IS NOT NULL DROP TABLE DimEmpresa;
IF OBJECT_ID('DimResponsable', 'U') IS NOT NULL DROP TABLE DimResponsable;
IF OBJECT_ID('DimCliente', 'U') IS NOT NULL DROP TABLE DimCliente;
IF OBJECT_ID('DimProyecto', 'U') IS NOT NULL DROP TABLE DimProyecto;

-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    nombreCliente VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE Proyecto (
    idProyecto INT PRIMARY KEY,
    nombreProyecto VARCHAR(100),
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Pais (
    idPais INT PRIMARY KEY,
    nombrePais VARCHAR(100)
);

CREATE TABLE Localidad (
    idLocalidad INT PRIMARY KEY,
    nombreLocalidad VARCHAR(100),
    idPais INT,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

CREATE TABLE Empresa (
    idEmpresa INT PRIMARY KEY,
    nombreEmpresa VARCHAR(100)
);

CREATE TABLE Responsable (
    idResponsable INT PRIMARY KEY,
    nombreResponsable VARCHAR(100),
    idEmpresa INT,
    FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa)
);

CREATE TABLE PaqueteTrabajo (
    idPaquete INT PRIMARY KEY,
    idProyecto INT,
    idResponsable INT,
    idLocalidad INT,
    fecha DATE,
    costos DECIMAL(10,2),
    FOREIGN KEY (idProyecto) REFERENCES Proyecto(idProyecto),
    FOREIGN KEY (idResponsable) REFERENCES Responsable(idResponsable),
    FOREIGN KEY (idLocalidad) REFERENCES Localidad(idLocalidad)
);

-- ===================================================
-- MODELO DIMENSIONAL (Esquema estrella)
-- ===================================================

CREATE TABLE DimProyecto (
    idProyecto INT PRIMARY KEY,
    nombreProyecto VARCHAR(100)
);

CREATE TABLE DimCliente (
    idCliente INT PRIMARY KEY,
    nombreCliente VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE DimResponsable (
    idResponsable INT PRIMARY KEY,
    nombreResponsable VARCHAR(100)
);

CREATE TABLE DimEmpresa (
    idEmpresa INT PRIMARY KEY,
    nombreEmpresa VARCHAR(100)
);

CREATE TABLE DimLocalidad (
    idLocalidad INT PRIMARY KEY,
    nombreLocalidad VARCHAR(100)
);

CREATE TABLE DimPais (
    idPais INT PRIMARY KEY,
    nombrePais VARCHAR(100)
);

CREATE TABLE DimTiempo (
    idTiempo INT PRIMARY KEY,
    dia INT,
    mes INT,
    anio INT
);

CREATE TABLE HechoTrabajo (
    idHecho INT PRIMARY KEY,
    idProyecto INT,
    idCliente INT,
    idResponsable INT,
    idEmpresa INT,
    idLocalidad INT,
    idPais INT,
    idTiempo INT,
    costo DECIMAL(10, 2),
    cantidadPaquetes INT,
    FOREIGN KEY (idProyecto) REFERENCES DimProyecto(idProyecto),
    FOREIGN KEY (idCliente) REFERENCES DimCliente(idCliente),
    FOREIGN KEY (idResponsable) REFERENCES DimResponsable(idResponsable),
    FOREIGN KEY (idEmpresa) REFERENCES DimEmpresa(idEmpresa),
    FOREIGN KEY (idLocalidad) REFERENCES DimLocalidad(idLocalidad),
    FOREIGN KEY (idPais) REFERENCES DimPais(idPais),
    FOREIGN KEY (idTiempo) REFERENCES DimTiempo(idTiempo)
);
