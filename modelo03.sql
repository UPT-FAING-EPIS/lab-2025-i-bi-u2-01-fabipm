-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('PaqueteTrabajo', 'U') IS NOT NULL DROP TABLE PaqueteTrabajo;
IF OBJECT_ID('Responsable', 'U') IS NOT NULL DROP TABLE Responsable;
IF OBJECT_ID('Empresa', 'U') IS NOT NULL DROP TABLE Empresa;
IF OBJECT_ID('Localidad', 'U') IS NOT NULL DROP TABLE Localidad;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;
IF OBJECT_ID('Proyecto', 'U') IS NOT NULL DROP TABLE Proyecto;
IF OBJECT_ID('Cliente', 'U') IS NOT NULL DROP TABLE Cliente;

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
