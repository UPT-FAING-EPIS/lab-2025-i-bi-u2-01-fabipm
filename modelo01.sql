USE modelo01;

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('Envio', 'U') IS NOT NULL DROP TABLE Envio;
IF OBJECT_ID('Destino', 'U') IS NOT NULL DROP TABLE Destino;
IF OBJECT_ID('ModoTransporte', 'U') IS NOT NULL DROP TABLE ModoTransporte;
IF OBJECT_ID('GrupoCentroCosto', 'U') IS NOT NULL DROP TABLE GrupoCentroCosto;
IF OBJECT_ID('CentroCosto', 'U') IS NOT NULL DROP TABLE CentroCosto;
IF OBJECT_ID('Lote', 'U') IS NOT NULL DROP TABLE Lote;
IF OBJECT_ID('Grupo', 'U') IS NOT NULL DROP TABLE Grupo;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;

-- Eliminar tablas del MODELO DIMENSIONAL en orden correcto
IF OBJECT_ID('HechoEnvio', 'U') IS NOT NULL DROP TABLE HechoEnvio;
IF OBJECT_ID('DimTiempo', 'U') IS NOT NULL DROP TABLE DimTiempo;
IF OBJECT_ID('DimModoTransporte', 'U') IS NOT NULL DROP TABLE DimModoTransporte;
IF OBJECT_ID('DimDestino', 'U') IS NOT NULL DROP TABLE DimDestino;
IF OBJECT_ID('DimLote', 'U') IS NOT NULL DROP TABLE DimLote;
IF OBJECT_ID('DimPais', 'U') IS NOT NULL DROP TABLE DimPais;
IF OBJECT_ID('DimGrupo', 'U') IS NOT NULL DROP TABLE DimGrupo;
IF OBJECT_ID('DimGrupoCentroCosto', 'U') IS NOT NULL DROP TABLE DimGrupoCentroCosto;

-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

CREATE TABLE Pais (
    idPais INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Grupo (
    idGrupo INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Lote (
    idLote INT PRIMARY KEY,
    peso DECIMAL(10,2),
    tarifa DECIMAL(10,2),
    idGrupo INT,
    idPais INT,
    FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

CREATE TABLE CentroCosto (
    idCentroCosto INT PRIMARY KEY,
    descripcion VARCHAR(100)
);

CREATE TABLE GrupoCentroCosto (
    idGrupoCentroCosto INT PRIMARY KEY,
    idGrupo INT,
    idCentroCosto INT,
    FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
    FOREIGN KEY (idCentroCosto) REFERENCES CentroCosto(idCentroCosto)
);

CREATE TABLE ModoTransporte (
    idModoTransporte INT PRIMARY KEY,
    tipo VARCHAR(100)
);

CREATE TABLE Destino (
    idDestino INT PRIMARY KEY,
    nombre VARCHAR(100),
    idPais INT,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

CREATE TABLE Envio (
    idEnvio INT PRIMARY KEY,
    fecha DATE,
    costo DECIMAL(10,2),
    idGrupoCentroCosto INT,
    idLote INT,
    idDestino INT,
    idModoTransporte INT,
    FOREIGN KEY (idGrupoCentroCosto) REFERENCES GrupoCentroCosto(idGrupoCentroCosto),
    FOREIGN KEY (idLote) REFERENCES Lote(idLote),
    FOREIGN KEY (idDestino) REFERENCES Destino(idDestino),
    FOREIGN KEY (idModoTransporte) REFERENCES ModoTransporte(idModoTransporte)
);

-- ===================================================
-- MODELO DIMENSIONAL (Esquema estrella)
-- ===================================================

CREATE TABLE DimGrupoCentroCosto (
    idGrupoCentroCosto INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE DimGrupo (
    idGrupo INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE DimPais (
    idPais INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE DimLote (
    idLote INT PRIMARY KEY,
    peso DECIMAL(10,2),
    tarifa DECIMAL(10,2),
    idGrupo INT,
    idPais INT,
    FOREIGN KEY (idGrupo) REFERENCES DimGrupo(idGrupo),
    FOREIGN KEY (idPais) REFERENCES DimPais(idPais)
);

CREATE TABLE DimDestino (
    idDestino INT PRIMARY KEY,
    nombre VARCHAR(100),
    idPais INT,
    FOREIGN KEY (idPais) REFERENCES DimPais(idPais)
);

CREATE TABLE DimModoTransporte (
    idModoTransporte INT PRIMARY KEY,
    tipo VARCHAR(100)
);

CREATE TABLE DimTiempo (
    idTiempo INT PRIMARY KEY,
    fecha DATE,
    mes INT,
    anio INT
);

CREATE TABLE HechoEnvio (
    idEnvio INT PRIMARY KEY,
    costo DECIMAL(10,2),
    idGrupoCentroCosto INT,
    idGrupo INT,
    idLote INT,
    idDestino INT,
    idModoTransporte INT,
    idTiempo INT,
    FOREIGN KEY (idGrupoCentroCosto) REFERENCES DimGrupoCentroCosto(idGrupoCentroCosto),
    FOREIGN KEY (idGrupo) REFERENCES DimGrupo(idGrupo),
    FOREIGN KEY (idLote) REFERENCES DimLote(idLote),
    FOREIGN KEY (idDestino) REFERENCES DimDestino(idDestino),
    FOREIGN KEY (idModoTransporte) REFERENCES DimModoTransporte(idModoTransporte),
    FOREIGN KEY (idTiempo) REFERENCES DimTiempo(idTiempo)
);
