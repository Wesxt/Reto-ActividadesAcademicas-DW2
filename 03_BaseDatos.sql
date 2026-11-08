-- ============================================================================
-- PROYECTO INTEGRADOR: UniCampus - Plataforma de Registro de Actividades Académicas
-- Asignatura: Desarrollo de Aplicaciones Web II
-- Docente: Ing. Cindy Fuentes
-- Institución: Corporación Universitaria Americana
-- Archivo: 03_BaseDatos.sql
-- Descripción: Script reproducible de creación de base de datos, tablas y
--              restricciones para SQL Server (sin datos preinsertados).
-- ============================================================================

USE master;
GO

-- 1. Crear Base de Datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'UniCampusDB')
BEGIN
    CREATE DATABASE UniCampusDB;
    PRINT 'Base de datos UniCampusDB creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La base de datos UniCampusDB ya existe.';
END
GO

USE UniCampusDB;
GO

-- ============================================================================
-- 2. LIMPIEZA PREVIA DE TABLAS (Si existen, en orden inverso de dependencias)
-- ============================================================================
IF OBJECT_ID('dbo.Resena', 'U') IS NOT NULL DROP TABLE dbo.Resena;
IF OBJECT_ID('dbo.Inscripcion', 'U') IS NOT NULL DROP TABLE dbo.Inscripcion;
IF OBJECT_ID('dbo.ActividadAcademica', 'U') IS NOT NULL DROP TABLE dbo.ActividadAcademica;
IF OBJECT_ID('dbo.TipoActividad', 'U') IS NOT NULL DROP TABLE dbo.TipoActividad;
IF OBJECT_ID('dbo.Usuario', 'U') IS NOT NULL DROP TABLE dbo.Usuario;
GO

-- ============================================================================
-- 3. CREACIÓN DE TABLAS
-- ============================================================================

-- Tabla 3.1: Usuario (Estudiantes, Docentes y Administradores)
CREATE TABLE dbo.Usuario (
    UsuarioId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(150) NOT NULL UNIQUE,
    Clave NVARCHAR(100) NOT NULL,
    Programa NVARCHAR(100) NOT NULL,
    Rol NVARCHAR(30) NOT NULL CONSTRAINT DF_Usuario_Rol DEFAULT ('Estudiante'),
    Telefono NVARCHAR(30) NULL,
    FechaRegistro DATETIME2 NOT NULL CONSTRAINT DF_Usuario_Fecha DEFAULT (SYSUTCDATETIME())
);
GO

-- Tabla 3.2: Tipo de Actividad (Catálogo de clasificación)
CREATE TABLE dbo.TipoActividad (
    TipoId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(250) NULL
);
GO

-- Tabla 3.3: Actividad Académica (Entidad Central del Sistema)
CREATE TABLE dbo.ActividadAcademica (
    ActividadId INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(120) NOT NULL,
    Descripcion NVARCHAR(1000) NULL,
    Tipo NVARCHAR(50) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    HoraInicio NVARCHAR(10) NOT NULL,
    HoraFin NVARCHAR(10) NOT NULL,
    Modalidad NVARCHAR(50) NOT NULL CONSTRAINT DF_Actividad_Modalidad DEFAULT ('Presencial'),
    Lugar NVARCHAR(150) NOT NULL,
    Cupos INT NOT NULL CONSTRAINT DF_Actividad_Cupos DEFAULT (0),
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Actividad_Estado DEFAULT ('Activa'),
    FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Actividad_FechaCreacion DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT CK_Actividad_Cupos CHECK (Cupos >= 0),
    CONSTRAINT CK_Actividad_Estado CHECK (Estado IN ('Activa', 'Próxima', 'Finalizada', 'Cancelada', 'Borrador')),
    CONSTRAINT CK_Actividad_Modalidad CHECK (Modalidad IN ('Presencial', 'Virtual', 'Híbrida'))
);
GO

-- Tabla 3.4: Inscripción (Relación N:M entre Estudiante y Actividad)
CREATE TABLE dbo.Inscripcion (
    InscripcionId INT IDENTITY(1,1) PRIMARY KEY,
    ActividadId INT NOT NULL,
    UsuarioId INT NOT NULL,
    FechaInscripcion DATETIME2 NOT NULL CONSTRAINT DF_Inscripcion_Fecha DEFAULT (SYSUTCDATETIME()),
    Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Inscripcion_Estado DEFAULT ('Activa'),
    CONSTRAINT FK_Inscripcion_Actividad FOREIGN KEY (ActividadId) 
        REFERENCES dbo.ActividadAcademica(ActividadId) ON DELETE CASCADE,
    CONSTRAINT FK_Inscripcion_Usuario FOREIGN KEY (UsuarioId) 
        REFERENCES dbo.Usuario(UsuarioId) ON DELETE CASCADE,
    CONSTRAINT UQ_Inscripcion_Actividad_Usuario UNIQUE (ActividadId, UsuarioId),
    CONSTRAINT CK_Inscripcion_Estado CHECK (Estado IN ('Activa', 'Cancelada', 'Completada'))
);
GO

-- Tabla 3.5: Reseña y Valoración
CREATE TABLE dbo.Resena (
    ResenaId INT IDENTITY(1,1) PRIMARY KEY,
    ActividadId INT NOT NULL,
    UsuarioId INT NOT NULL,
    Calificacion TINYINT NOT NULL,
    Comentario NVARCHAR(1000) NULL,
    FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Resena_Fecha DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT CK_Resena_Calificacion CHECK (Calificacion BETWEEN 1 AND 5),
    CONSTRAINT FK_Resena_Actividad FOREIGN KEY (ActividadId) 
        REFERENCES dbo.ActividadAcademica(ActividadId) ON DELETE CASCADE,
    CONSTRAINT FK_Resena_Usuario FOREIGN KEY (UsuarioId) 
        REFERENCES dbo.Usuario(UsuarioId) ON DELETE CASCADE,
    CONSTRAINT UQ_Resena_Actividad_Usuario UNIQUE (ActividadId, UsuarioId)
);
GO

PRINT '============================================================================';
PRINT 'Esquema de base de datos UniCampusDB creado exitosamente.';
PRINT '============================================================================';
GO

-- ============================================================================
-- 4. CATÁLOGO INICIAL DE TIPOS DE ACTIVIDAD Y CUENTAS POR DEFECTO
-- ============================================================================
INSERT INTO dbo.TipoActividad (Nombre, Descripcion) VALUES 
(N'Taller', N'Actividad práctica orientada al aprendizaje de habilidades aplicadas'),
(N'Conferencia', N'Exposición magistral impartida por expertos en la materia'),
(N'Seminario', N'Sesión académica intensiva de debate e investigación'),
(N'Simposio', N'Reunión de especialistas que analizan un tema desde diversos enfoques'),
(N'Webinar', N'Seminario interactivo impartido en línea a través de plataformas digitales');
GO

-- 4.1 Cuentas iniciales del sistema (Administrador, Docente y Estudiante)
INSERT INTO dbo.Usuario (Nombre, Correo, Clave, Programa, Rol, Telefono) VALUES 
(N'Administrador del Sistema', N'admin@unicampus.edu', N'admin123', N'Dirección Académica', N'Administrador', N'3000000000'),
(N'Ing. Cindy Fuentes', N'docente@americana.edu.co', N'docente123', N'Ingeniería de Sistemas', N'Docente', N'3001112233'),
(N'Arnold Beleño Zuletta', N'estudiante@americana.edu.co', N'123456789', N'Ingeniería de Sistemas', N'Estudiante', N'3009876543');
GO

