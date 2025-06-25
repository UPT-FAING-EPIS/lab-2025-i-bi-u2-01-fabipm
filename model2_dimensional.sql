USE modelo02;

-- Eliminar tablas del MODELO FISICO RELACIONAL en orden correcto para evitar errores de FK
IF OBJECT_ID('Reserva', 'U') IS NOT NULL DROP TABLE Reserva;
IF OBJECT_ID('Viaje', 'U') IS NOT NULL DROP TABLE Viaje;
IF OBJECT_ID('Destino', 'U') IS NOT NULL DROP TABLE Destino;
IF OBJECT_ID('Pais', 'U') IS NOT NULL DROP TABLE Pais;
IF OBJECT_ID('AgenciaViajes', 'U') IS NOT NULL DROP TABLE AgenciaViajes;
IF OBJECT_ID('Operador', 'U') IS NOT NULL DROP TABLE Operador;
IF OBJECT_ID('Cliente', 'U') IS NOT NULL DROP TABLE Cliente;
IF OBJECT_ID('TipoCliente', 'U') IS NOT NULL DROP TABLE TipoCliente;

-- Eliminar tablas del MODELO DIMENSIONAL en orden correcto
IF OBJECT_ID('HechoReserva', 'U') IS NOT NULL DROP TABLE HechoReserva;
IF OBJECT_ID('DimTiempo', 'U') IS NOT NULL DROP TABLE DimTiempo;
IF OBJECT_ID('DimViaje', 'U') IS NOT NULL DROP TABLE DimViaje;
IF OBJECT_ID('DimDestino', 'U') IS NOT NULL DROP TABLE DimDestino;
IF OBJECT_ID('DimPais', 'U') IS NOT NULL DROP TABLE DimPais;
IF OBJECT_ID('DimAgencia', 'U') IS NOT NULL DROP TABLE DimAgencia;
IF OBJECT_ID('DimOperador', 'U') IS NOT NULL DROP TABLE DimOperador;
IF OBJECT_ID('DimCliente', 'U') IS NOT NULL DROP TABLE DimCliente;
IF OBJECT_ID('DimTipoCliente', 'U') IS NOT NULL DROP TABLE DimTipoCliente;

-- ===================================================
-- MODELO FISICO RELACIONAL (Basado en el modelo E/R)
-- ===================================================

CREATE TABLE TipoCliente (
    id_tipo_cliente INT PRIMARY KEY,
    tipo VARCHAR(50)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
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

-- ===================================================
-- MODELO DIMENSIONAL (Esquema estrella)
-- ===================================================

CREATE TABLE DimTipoCliente (
    id_tipo_cliente INT PRIMARY KEY,
    tipo VARCHAR(50)
);

CREATE TABLE DimCliente (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    direccion VARCHAR(150)
);

CREATE TABLE DimOperador (
    id_operador INT PRIMARY KEY,
    nombre_operador VARCHAR(100)
);

CREATE TABLE DimAgencia (
    id_agencia INT PRIMARY KEY,
    nombre_agencia VARCHAR(100)
);

CREATE TABLE DimPais (
    id_pais INT PRIMARY KEY,
    nombre_pais VARCHAR(100)
);

CREATE TABLE DimDestino (
    id_destino INT PRIMARY KEY,
    nombre_destino VARCHAR(100)
);

CREATE TABLE DimViaje (
    id_viaje INT PRIMARY KEY,
    descripcion VARCHAR(150)
);

CREATE TABLE DimTiempo (
    id_tiempo INT PRIMARY KEY,
    fecha DATE,
    mes INT,
    trimestre INT,
    anio INT
);

CREATE TABLE HechoReserva (
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_tipo_cliente INT,
    id_agencia INT,
    id_operador INT,
    id_viaje INT,
    id_destino INT,
    id_pais INT,
    id_tiempo INT,
    cantidad_reservas INT,
    FOREIGN KEY (id_cliente) REFERENCES DimCliente(id_cliente),
    FOREIGN KEY (id_tipo_cliente) REFERENCES DimTipoCliente(id_tipo_cliente),
    FOREIGN KEY (id_agencia) REFERENCES DimAgencia(id_agencia),
    FOREIGN KEY (id_operador) REFERENCES DimOperador(id_operador),
    FOREIGN KEY (id_viaje) REFERENCES DimViaje(id_viaje),
    FOREIGN KEY (id_destino) REFERENCES DimDestino(id_destino),
    FOREIGN KEY (id_pais) REFERENCES DimPais(id_pais),
    FOREIGN KEY (id_tiempo) REFERENCES DimTiempo(id_tiempo)
);
