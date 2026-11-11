/* =====================================================
 Base de datos: Cine (SQL Server / T-SQL)
 Basada en el MER dibujado a mano
 ===================================================== */

IF DB_ID('Cine') IS NULL
 CREATE DATABASE Cine;
GO

USE Cine;
GO

/* ---------- Tablas independientes ---------- */

CREATE TABLE Cine (
 ID_Cine INT IDENTITY(1,1) NOT NULL,
 Establecimiento VARCHAR(100) NOT NULL,
 Ubicacion VARCHAR(150) NOT NULL,
 Nombre_Cine VARCHAR(100) NOT NULL,
 CONSTRAINT PK_Cine PRIMARY KEY (ID_Cine),
 CONSTRAINT UQ_Cine_Nombre UNIQUE (Nombre_Cine)
);

CREATE TABLE Usuario (
 ID_Usuario INT IDENTITY(1,1) NOT NULL,
 Nacimiento_Fecha DATE NOT NULL,
 Nombre_Usuario VARCHAR(60) NOT NULL,
 Apellido_Usuario VARCHAR(60) NOT NULL,
 DNI_Usuario VARCHAR(15) NOT NULL,
 CONSTRAINT PK_Usuario PRIMARY KEY (ID_Usuario),
 CONSTRAINT UQ_Usuario_DNI UNIQUE (DNI_Usuario)
);

CREATE TABLE Tipo_Entrada (
 ID_Tipo INT IDENTITY(1,1) NOT NULL,
 Edad INT NOT NULL,
 Nombre_Tipo VARCHAR(50) NOT NULL,
 CONSTRAINT PK_Tipo_Entrada PRIMARY KEY (ID_Tipo)
);

CREATE TABLE Pais (
 ID_Pais INT IDENTITY(1,1) NOT NULL,
 Nombre_Pais VARCHAR(60) NOT NULL,
 Idioma VARCHAR(40) NOT NULL,
 CONSTRAINT PK_Pais PRIMARY KEY (ID_Pais)
);

CREATE TABLE Genero (
 ID_Genero INT IDENTITY(1,1) NOT NULL,
 Titulo_Genero VARCHAR(50) NOT NULL,
 CONSTRAINT PK_Genero PRIMARY KEY (ID_Genero)
);

CREATE TABLE Actores (
 ID_Actor INT IDENTITY(1,1) NOT NULL,
 Nombre_Actor VARCHAR(60) NOT NULL,
 Apellido_Actor VARCHAR(60) NOT NULL,
 DNI_Actor VARCHAR(15) NOT NULL,
 CONSTRAINT PK_Actores PRIMARY KEY (ID_Actor)
);

/* ---------- Tablas dependientes ---------- */

CREATE TABLE Sala_Cine (
 ID_Sala INT IDENTITY(1,1) NOT NULL,
 ID_Cine INT NOT NULL,
 Total_Butacas INT NOT NULL,
 Disponibilidad INT NOT NULL,
 Numero_Sala INT NOT NULL,
 CONSTRAINT PK_Sala_Cine PRIMARY KEY (ID_Sala),
 CONSTRAINT FK_Sala_Cine FOREIGN KEY (ID_Cine) REFERENCES Cine(ID_Cine),
 CONSTRAINT UQ_Sala_Numero UNIQUE (ID_Cine, Numero_Sala),
 CONSTRAINT CK_Sala_Disp CHECK (Disponibilidad BETWEEN 0 AND Total_Butacas)
);

CREATE TABLE Elenco (
 ID_Elenco INT IDENTITY(1,1) NOT NULL,
 ID_Actor INT NOT NULL,
 Cantidad_Actores INT NOT NULL,
 CONSTRAINT PK_Elenco PRIMARY KEY (ID_Elenco),
 CONSTRAINT FK_Elenco_Actor FOREIGN KEY (ID_Actor) REFERENCES Actores(ID_Actor)
);

CREATE TABLE Peliculas (
 ID_Pelicula INT IDENTITY(1,1) NOT NULL,
 ID_Pais INT NOT NULL,
 ID_Elenco INT NOT NULL,
 ID_Genero INT NOT NULL,
 Titulo_Pelicula VARCHAR(150) NOT NULL,
 Duracion_Pelicula INT NOT NULL, -- minutos
 Estudio_Pelicula VARCHAR(100) NOT NULL,
 CONSTRAINT PK_Peliculas PRIMARY KEY (ID_Pelicula),
 CONSTRAINT FK_Peliculas_Pais FOREIGN KEY (ID_Pais) REFERENCES Pais(ID_Pais),
 CONSTRAINT FK_Peliculas_Elenco FOREIGN KEY (ID_Elenco) REFERENCES Elenco(ID_Elenco),
 CONSTRAINT FK_Peliculas_Genero FOREIGN KEY (ID_Genero) REFERENCES Genero(ID_Genero)
);

CREATE TABLE Funciones (
 ID_Funcion INT IDENTITY(1,1) NOT NULL,
 ID_Sala INT NOT NULL,
 ID_Pelicula INT NOT NULL,
 Fecha_Funcion DATE NOT NULL,
 Horario_Funcion TIME NOT NULL,
 CONSTRAINT PK_Funciones PRIMARY KEY (ID_Funcion),
 CONSTRAINT FK_Funciones_Sala FOREIGN KEY (ID_Sala) REFERENCES Sala_Cine(ID_Sala),
 CONSTRAINT FK_Funciones_Pelicula FOREIGN KEY (ID_Pelicula) REFERENCES Peliculas(ID_Pelicula)
);

CREATE TABLE Programacion (
 ID_Programacion INT IDENTITY(1,1) NOT NULL,
 ID_Funcion INT NOT NULL,
 CONSTRAINT PK_Programacion PRIMARY KEY (ID_Programacion),
 CONSTRAINT FK_Programacion_Funcion FOREIGN KEY (ID_Funcion) REFERENCES Funciones(ID_Funcion)
);

CREATE TABLE Venta (
 ID_Venta INT IDENTITY(1,1) NOT NULL,
 ID_Usuario INT NOT NULL,
 Fecha_Venta DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
 Precio DECIMAL(10,2) NOT NULL,
 CONSTRAINT PK_Venta PRIMARY KEY (ID_Venta),
 CONSTRAINT FK_Venta_Usuario FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario),
 CONSTRAINT CK_Venta_Precio CHECK (Precio >= 0)
);

CREATE TABLE Entrada (
 ID_Entrada INT IDENTITY(1,1) NOT NULL,
 ID_Funcion INT NOT NULL,
 ID_Tipo INT NOT NULL,
 ID_Venta INT NOT NULL,
 Vencimiento DATE NOT NULL,
 CONSTRAINT PK_Entrada PRIMARY KEY (ID_Entrada),
 CONSTRAINT FK_Entrada_Funcion FOREIGN KEY (ID_Funcion) REFERENCES Funciones(ID_Funcion),
 CONSTRAINT FK_Entrada_Tipo FOREIGN KEY (ID_Tipo) REFERENCES Tipo_Entrada(ID_Tipo),
 CONSTRAINT FK_Entrada_Venta FOREIGN KEY (ID_Venta) REFERENCES Venta(ID_Venta)
);
GO

/* ---------- Datos de ejemplo ---------- */

INSERT INTO Cine (Establecimiento, Ubicacion, Nombre_Cine)
VALUES ('Shopping Central', 'Av. Principal 123', 'Cine Central');

INSERT INTO Sala_Cine (ID_Cine, Total_Butacas, Disponibilidad, Numero_Sala)
VALUES (1, 120, 120, 1);

INSERT INTO Pais (Nombre_Pais, Idioma) VALUES ('Argentina', 'Español');
INSERT INTO Genero (Titulo_Genero) VALUES ('Drama');
INSERT INTO Actores (Nombre_Actor, Apellido_Actor, DNI_Actor) VALUES ('Juan', 'Pérez', '30111222');
INSERT INTO Elenco (ID_Actor, Cantidad_Actores) VALUES (1, 1);

INSERT INTO Peliculas (ID_Pais, ID_Elenco, ID_Genero, Titulo_Pelicula, Duracion_Pelicula, Estudio_Pelicula)
VALUES (1, 1, 1, 'Película de ejemplo', 110, 'Estudio Demo');

INSERT INTO Funciones (ID_Sala, ID_Pelicula, Fecha_Funcion, Horario_Funcion)
VALUES (1, 1, '2026-11-20', '20:30');

INSERT INTO Programacion (ID_Funcion) VALUES (1);

INSERT INTO Tipo_Entrada (Edad, Nombre_Tipo) VALUES (18, 'General'), (12, 'Menor');

INSERT INTO Usuario (Nacimiento_Fecha, Nombre_Usuario, Apellido_Usuario, DNI_Usuario)
VALUES ('2000-05-10', 'Ana', 'Gómez', '40123456');

INSERT INTO Venta (ID_Usuario, Precio) VALUES (1, 5500.00);
INSERT INTO Entrada (ID_Funcion, ID_Tipo, ID_Venta, Vencimiento) VALUES (1, 1, 1, '2026-11-20');
GO

/* ---------- Consulta de prueba ---------- */
SELECT u.Nombre_Usuario, p.Titulo_Pelicula, f.Fecha_Funcion, f.Horario_Funcion, s.Numero_Sala, c.Nombre_Cine
FROM Entrada e
JOIN Venta v ON v.ID_Venta = e.ID_Venta
JOIN Usuario u ON u.ID_Usuario = v.ID_Usuario
JOIN Funciones f ON f.ID_Funcion = e.ID_Funcion
JOIN Peliculas p ON p.ID_Pelicula = f.ID_Pelicula
JOIN Sala_Cine s ON s.ID_Sala = f.ID_Sala
JOIN Cine c ON c.ID_Cine = s.ID_Cine;
