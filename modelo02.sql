-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('Reserva', 'U') IS NOT NULL DROP TABLE Reserva;
IF OBJECT_ID('Viaje', 'U') IS NOT NULL DROP TABLE Viaje;
IF OBJECT_ID('Destino', 'U') IS NOT NULL DROP TABLE Destino;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;
IF OBJECT_ID('AgenciaViajes', 'U') IS NOT NULL DROP TABLE AgenciaViajes;
IF OBJECT_ID('Operador', 'U') IS NOT NULL DROP TABLE Operador;
IF OBJECT_ID('Cliente', 'U') IS NOT NULL DROP TABLE Cliente;
IF OBJECT_ID('TipoCliente', 'U') IS NOT NULL DROP TABLE TipoCliente;

CREATE TABLE TipoCliente (
    id_tipo_cliente INT PRIMARY KEY,
    tipo VARCHAR(50)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(1000),
    direccion VARCHAR(150),
    id_tipo_cliente INT,
    FOREIGN KEY (id_tipo_cliente) REFERENCES TipoCliente(id_tipo_cliente)
);

CREATE TABLE Operador (
    id_operador INT PRIMARY KEY,
    nombre_operador VARCHAR(100)
);

CREATE TABLE AgenciaViajes (
    id_agencia INT PRIMARY KEY,
    nombre_agencia VARCHAR(100),
    id_operador INT,
    FOREIGN KEY (id_operador) REFERENCES Operador(id_operador)
);

CREATE TABLE Pais (
    id_pais INT PRIMARY KEY,
    nombre_pais VARCHAR(100)
);

CREATE TABLE Destino (
    id_destino INT PRIMARY KEY,
    nombre_destino VARCHAR(100),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

CREATE TABLE Viaje (
    id_viaje INT PRIMARY KEY,
    descripcion VARCHAR(150),
    id_destino INT,
    FOREIGN KEY (id_destino) REFERENCES Destino(id_destino)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_viaje INT,
    id_agencia INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_viaje) REFERENCES Viaje(id_viaje),
    FOREIGN KEY (id_agencia) REFERENCES AgenciaViajes(id_agencia)
);
