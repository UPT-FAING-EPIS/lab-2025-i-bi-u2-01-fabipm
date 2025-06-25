-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('Envio', 'U') IS NOT NULL DROP TABLE Envio;
IF OBJECT_ID('Destino', 'U') IS NOT NULL DROP TABLE Destino;
IF OBJECT_ID('ModoTransporte', 'U') IS NOT NULL DROP TABLE ModoTransporte;
IF OBJECT_ID('GrupoCentroCosto', 'U') IS NOT NULL DROP TABLE GrupoCentroCosto;
IF OBJECT_ID('CentroCosto', 'U') IS NOT NULL DROP TABLE CentroCosto;
IF OBJECT_ID('Lote', 'U') IS NOT NULL DROP TABLE Lote;
IF OBJECT_ID('Grupo', 'U') IS NOT NULL DROP TABLE Grupo;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;

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
