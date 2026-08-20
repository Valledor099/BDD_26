create database E_commerce_TP;
use E_commerce_TP;

create table if not exists Nivel_Usuario(
	id_nivel_usuario int auto_increment primary key,
    nombre varchar(15) not null
);

create table if not exists Usuarios(
	id_usuario int auto_increment primary key,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    email varchar(255) not null unique,
    contraseña varchar(255) not null,
    telefono varchar(20) not null unique,
    direccion varchar(150) not null,
    fecha_creacion date not null,
    cantidad_ventas int default 0,
    facturacion_total FLOAT  default 0,
    reputacion int default 0,
    nivel_id int null,
    constraint EsMenorDeCien
    check (reputacion <= 100),
    foreign key (nivel_id) references Nivel_Usuario(id_nivel_usuario)
);

create table if not exists Producto(
	id_producto int auto_increment primary key,
    id_usuario int  not null,
    nombre varchar(255) not null,
    descripcion text not null,
	fecha_creacion datetime not null,
    foreign key (id_usuario) references Usuarios(id_usuario)
);

CREATE TABLE Categoria(
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);

CREATE TABLE TipoPublicacion (
	id_tipoPublicacion INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR (15)
);

CREATE TABLE NivelExposicion (
id_nivelExposicion INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR (15)
);

CREATE TABLE Estado (
id_estado INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(20)
);

CREATE TABLE Publicacion(
id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR (100),
descripicion TEXT,
precio FLOAT NOT NULL,
fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
 
id_producto INT NOT NULL,
id_categoria INT NOT NULL,
id_vendedor INT NOT NULL,
id_tipo_publicacion INT NOT NULL,
id_nivel_exposicion INT NOT NULL,
id_estado INT NOT NULL,
FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
FOREIGN KEY (id_vendedor) REFERENCES Usuarios(id_usuario),
FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
FOREIGN KEY (id_tipo_publicacion) REFERENCES TipoPublicacion(id_tipoPublicacion),
FOREIGN KEY (id_nivel_exposicion) REFERENCES NivelExposicion(id_nivelExposicion),
FOREIGN KEY (id_estado) REFERENCES Estado(id_estado)
);
 
create table if not exists Preguntas_Respuestas (
	id_pregunta int primary key auto_increment,
	id_publicacion int not null,
	id_usuario int not null,
	pregunta text not null,
	respuesta text null, 
	fecha_pregunta datetime not null,
	fecha_respuesta datetime null,
    foreign key (id_usuario) references Usuarios(id_usuario),
    foreign key (id_publicacion) references Publicacion(id_publicacion)
);

CREATE TABLE MedioDePago(
	id_medioPago INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(25)
);

CREATE TABLE Publicacion_MedioPago (
    id_publicacion INT NOT NULL,
    id_medio_pago INT NOT NULL,
    PRIMARY KEY (id_publicacion, id_medio_pago),
    FOREIGN KEY (id_publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY (id_medio_pago) REFERENCES MedioDePago(id_medioPago)
);
 
CREATE TABLE MedioDeEnvio(
	id_medioEnvio INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(25)
);

CREATE TABLE Venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_comprador INT NOT NULL,
    id_medio_pago INT NOT NULL,
    id_medio_envio INT NOT NULL,
    fecha_venta DATETIME NOT NULL,
    monto float NOT NULL,
    FOREIGN KEY (id_publicacion) REFERENCES Publicacion(id_publicacion),
	FOREIGN KEY (id_comprador) REFERENCES Usuarios(id_usuario),
	FOREIGN KEY (id_medio_pago) REFERENCES MedioDePago(id_medioPago),
    FOREIGN KEY (id_medio_envio) REFERENCES MedioDeEnvio(id_medioEnvio)
);

CREATE TABLE Oferta (
    id_oferta INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_usuario INT NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    fecha_oferta DATETIME NOT NULL,

    FOREIGN KEY (id_publicacion) REFERENCES Publicacion(id_publicacion),
	FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);


CREATE TABLE IF NOT EXISTS Calificacion (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_usuario_evaluado INT NOT NULL, -- Usuario que recibe la calificación
    id_calificador INT NOT NULL,       -- Usuario que califica
    puntaje INT NOT NULL CHECK (puntaje BETWEEN 1 AND 100),
    comentario TEXT NULL,
    fecha_calificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_usuario_evaluado) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_calificador) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    mensaje VARCHAR(255) NOT NULL,
    fecha DATETIME NOT NULL,
    leida BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Estadistica_Diaria (
    id_estadistica INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad_vendedores INT NOT NULL,
    cantidad_compradores INT NOT NULL,
    cantidad_productos INT NOT NULL,
    cantidad_ventas INT NOT NULL,
    facturacion_total FLOAT NOT NULL
);


DROP DATABASE E_commerce_TP;


/*INSERTS*/

USE E_commerce_TP;

-- =========================================================
-- 1. NIVELES DE USUARIO
-- =========================================================

INSERT INTO Nivel_Usuario (nombre) VALUES
('Normal'),
('Platinum'),
('Gold');


-- =========================================================
-- 2. USUARIOS
-- =========================================================

INSERT INTO Usuarios
(nombre, apellido, email, contraseña, telefono, direccion,
 fecha_creacion, cantidad_ventas, facturacion_total, reputacion, nivel_id)
VALUES
('Juan', 'Perez',
 'juan.perez@gmail.com', '1234', '1123456781',
 'Av. Corrientes 1234, CABA',
 '2026-01-10', 0, 0, 0, NULL),

('Maria', 'Gomez',
 'maria.gomez@gmail.com', '1234', '1123456782',
 'Av. Santa Fe 2345, CABA',
 '2026-01-12', 3, 45000, 85, 1),

('Carlos', 'Rodriguez',
 'carlos.rodriguez@gmail.com', '1234', '1123456783',
 'Av. Rivadavia 3456, CABA',
 '2026-01-15', 8, 150000, 92, 2),

('Lucia', 'Fernandez',
 'lucia.fernandez@gmail.com', '1234', '1123456784',
 'Av. Belgrano 4567, CABA',
 '2026-01-18', 12, 800000, 96, 3),

('Pedro', 'Martinez',
 'pedro.martinez@gmail.com', '1234', '1123456785',
 'Av. Cabildo 5678, CABA',
 '2026-02-01', 15, 1200000, 98, 3),

('Sofia', 'Lopez',
 'sofia.lopez@gmail.com', '1234', '1123456786',
 'Av. Pueyrredon 6789, CABA',
 '2026-02-05', 5, 90000, 78, 1),

('Diego', 'Sanchez',
 'diego.sanchez@gmail.com', '1234', '1123456787',
 'Av. Callao 7890, CABA',
 '2026-02-10', 7, 110000, 88, 2),

('Valentina', 'Diaz',
 'valentina.diaz@gmail.com', '1234', '1123456788',
 'Av. Palermo 8901, CABA',
 '2026-02-15', 0, 0, 0, NULL),

('Martin', 'Torres',
 'martin.torres@gmail.com', '1234', '1123456789',
 'Av. Medrano 9012, CABA',
 '2026-02-20', 11, 500000, 90, 3),

('Camila', 'Ruiz',
 'camila.ruiz@gmail.com', '1234', '1123456790',
 'Av. Lacroze 1122, CABA',
 '2026-03-01', 2, 30000, 75, 1);


-- =========================================================
-- 3. CATEGORIAS
-- =========================================================

INSERT INTO Categoria (nombre) VALUES
('Electronica'),
('Ropa'),
('Hogar'),
('Deportes'),
('Videojuegos'),
('Libros'),
('Celulares'),
('Computacion');


-- =========================================================
-- 4. PRODUCTOS
-- =========================================================

INSERT INTO Producto
(id_usuario, nombre, descripcion, fecha_creacion)
VALUES
(1,
 'Auriculares Bluetooth',
 'Auriculares inalambricos con cancelacion de ruido y bateria de larga duracion.',
 '2026-03-01 10:00:00'),

(2,
 'Zapatillas deportivas',
 'Zapatillas deportivas ideales para running y entrenamiento.',
 '2026-03-02 11:00:00'),

(3,
 'Notebook Lenovo',
 'Notebook Lenovo con 16GB de RAM, 512GB SSD y pantalla Full HD.',
 '2026-03-03 12:00:00'),

(4,
 'Samsung Galaxy A55',
 'Telefono Samsung Galaxy A55 con 128GB de almacenamiento.',
 '2026-03-04 13:00:00'),

(5,
 'PlayStation 5',
 'Consola PlayStation 5 con un joystick DualSense incluido.',
 '2026-03-05 14:00:00'),

(6,
 'Campera deportiva',
 'Campera deportiva impermeable para actividades al aire libre.',
 '2026-03-06 15:00:00'),

(7,
 'Monitor 24 pulgadas',
 'Monitor Full HD de 24 pulgadas con entrada HDMI.',
 '2026-03-07 16:00:00'),

(8,
 'Libro de programacion',
 'Libro introductorio sobre programacion y bases de datos.',
 '2026-03-08 17:00:00'),

(9,
 'Teclado mecanico RGB',
 'Teclado mecanico con iluminacion RGB y switches mecanicos.',
 '2026-03-09 18:00:00'),

(10,
 'Pelota de futbol',
 'Pelota de futbol de tamaño reglamentario.',
 '2026-03-10 19:00:00');


-- =========================================================
-- 5. TIPOS DE PUBLICACION
-- =========================================================

INSERT INTO TipoPublicacion (nombre) VALUES
('Venta directa'),
('Subasta');


-- =========================================================
-- 6. NIVELES DE EXPOSICION
-- =========================================================

INSERT INTO NivelExposicion (nombre) VALUES
('Bronce'),
('Plata'),
('Oro'),
('Platino');


-- =========================================================
-- 7. ESTADOS
-- =========================================================

INSERT INTO Estado (nombre) VALUES
('Activa'),
('Finalizada'),
('Pausada'),
('Observada');


-- =========================================================
-- 8. PUBLICACIONES
-- =========================================================

INSERT INTO Publicacion
(titulo, descripicion, precio, fecha_publicacion,
 id_producto, id_categoria, id_vendedor,
 id_tipo_publicacion, id_nivel_exposicion, id_estado)
VALUES

-- 1 - Venta directa activa
(
 'Auriculares Bluetooth',
 'Auriculares inalambricos nuevos con cancelacion de ruido.',
 25000,
 '2026-04-01 10:00:00',
 1, 1, 1, 1, 1, 1
),

-- 2 - Venta directa finalizada
(
 'Zapatillas deportivas',
 'Zapatillas ideales para correr y entrenar.',
 60000,
 '2026-04-02 11:00:00',
 2, 4, 2, 1, 2, 2
),

-- 3 - Venta directa activa
(
 'Notebook Lenovo',
 'Notebook para trabajo, estudio y uso diario.',
 850000,
 '2026-04-03 12:00:00',
 3, 8, 3, 1, 4, 1
),

-- 4 - Venta directa finalizada
(
 'Samsung Galaxy A55',
 'Samsung Galaxy A55 de 128GB en excelente estado.',
 500000,
 '2026-04-04 13:00:00',
 4, 7, 4, 1, 3, 2
),

-- 5 - Subasta activa
(
 'PlayStation 5',
 'PlayStation 5 con joystick original incluido.',
 700000,
 '2026-04-05 14:00:00',
 5, 5, 5, 2, 4, 1
),

-- 6 - Venta directa activa
(
 'Campera deportiva',
 'Campera impermeable para actividades deportivas.',
 90000,
 '2026-04-06 15:00:00',
 6, 2, 6, 1, 2, 1
),

-- 7 - Subasta activa
(
 'Monitor 24 pulgadas',
 'Monitor Full HD ideal para gaming y trabajo.',
 120000,
 '2026-04-07 16:00:00',
 7, 8, 7, 2, 3, 1
),

-- 8 - Venta directa finalizada
(
 'Libro de programacion',
 'Libro para aprender programacion y bases de datos.',
 30000,
 '2026-04-08 17:00:00',
 8, 6, 8, 1, 1, 2
),

-- 9 - Subasta activa
(
 'Teclado mecanico RGB',
 'Teclado mecanico RGB ideal para gaming.',
 80000,
 '2026-04-09 18:00:00',
 9, 8, 9, 2, 4, 1
),

-- 10 - Venta directa activa
(
 'Pelota de futbol',
 'Pelota profesional de futbol tamaño reglamentario.',
 45000,
 '2026-04-10 19:00:00',
 10, 4, 10, 1, 3, 1
);


-- =========================================================
-- 9. PREGUNTAS Y RESPUESTAS
-- =========================================================

INSERT INTO Preguntas_Respuestas
(id_publicacion, id_usuario, pregunta, respuesta,
 fecha_pregunta, fecha_respuesta)
VALUES

(
 1, 2,
 '¿Los auriculares tienen garantia?',
 'Si, tienen garantia de seis meses.',
 '2026-04-11 10:00:00',
 '2026-04-11 11:00:00'
),

(
 1, 3,
 '¿Cuanto dura la bateria?',
 'La bateria dura aproximadamente 20 horas.',
 '2026-04-11 12:00:00',
 '2026-04-11 13:00:00'
),

(
 3, 1,
 '¿La notebook tiene sistema operativo?',
 'Si, viene con Windows instalado.',
 '2026-04-12 10:00:00',
 '2026-04-12 11:00:00'
),

(
 3, 6,
 '¿Tiene garantia?',
 NULL,
 '2026-04-12 13:00:00',
 NULL
),

(
 5, 4,
 '¿La PlayStation incluye joystick?',
 'Si, incluye un joystick original.',
 '2026-04-13 14:00:00',
 '2026-04-13 15:00:00'
),

(
 7, 6,
 '¿El monitor tiene entrada HDMI?',
 'Si, cuenta con entrada HDMI.',
 '2026-04-14 16:00:00',
 '2026-04-14 17:00:00'
),

(
 9, 2,
 '¿El teclado tiene iluminacion RGB?',
 'Si, posee iluminacion RGB configurable.',
 '2026-04-15 18:00:00',
 '2026-04-15 19:00:00'
),

(
 10, 8,
 '¿La pelota es apta para partidos oficiales?',
 'Si, es de tamaño reglamentario.',
 '2026-04-16 10:00:00',
 '2026-04-16 11:00:00'
);




-- Inserts para probar la view 3
INSERT INTO Preguntas_Respuestas 
(id_publicacion, id_usuario, pregunta, respuesta, fecha_pregunta, fecha_respuesta)
VALUES
-- Tres preguntas para la publicación 1 (Será la tendencia principal)
(1, 2, '¿Tienen stock para retirar hoy mismo?', NULL, '2026-08-13 09:15:00', NULL),
(1, 3, '¿Hacen envíos a CABA en el día?', NULL, '2026-08-13 10:30:00', NULL),
(1, 4, '¿El producto viene en caja sellada original?', NULL, '2026-08-13 11:00:00', NULL),

-- Dos preguntas para la publicación 3
(3, 5, '¿Se le puede agregar más memoria RAM?', NULL, '2026-08-13 10:00:00', NULL),
(3, 2, '¿La distribución del teclado es en español?', NULL, '2026-08-13 12:45:00', NULL),

-- Una pregunta para la publicación 5
(5, 7, '¿Viene con algún juego físico incluido?', NULL, '2026-08-13 14:00:00', NULL);

-- =========================================================
-- 10. MEDIOS DE PAGO
-- =========================================================

INSERT INTO MedioDePago (nombre) VALUES
('Tarjeta de credito'),
('Tarjeta de debito'),
('Pago Facil'),
('Rapipago');

-- =========================================================
-- Publicacion_Medio_de_pago
-- =========================================================
INSERT INTO Publicacion_MedioPago
(id_publicacion, id_medio_pago)
VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(3, 2),
(6, 3),
(8, 4),
(10, 2);

-- =========================================================
-- 11. MEDIOS DE ENVIO
-- =========================================================

INSERT INTO MedioDeEnvio (nombre) VALUES
('OCA'),
('Correo Argentino');


-- =========================================================
-- 12. VENTAS
-- =========================================================

-- Venta de la publicacion 2
INSERT INTO Venta
(id_publicacion, id_comprador, id_medio_pago, id_medio_envio,
 fecha_venta, monto)
VALUES
(2, 1, 1, 2, '2026-04-20 10:30:00', 60000);

-- Venta de la publicacion 4
INSERT INTO Venta
(id_publicacion, id_comprador, id_medio_pago, id_medio_envio,
 fecha_venta, monto)
VALUES
(4, 3, 2, 1, '2026-04-21 15:00:00', 500000);

-- Venta de la publicacion 8
INSERT INTO Venta
(id_publicacion, id_comprador, id_medio_pago, id_medio_envio,
 fecha_venta, monto)
VALUES
(8, 5, 3, 2, '2026-04-22 17:30:00', 30000);


-- =========================================================
-- 13. OFERTAS
-- =========================================================

-- Subasta de PlayStation 5
INSERT INTO Oferta
(id_publicacion, id_usuario, monto, fecha_oferta)
VALUES
(5, 1, 720000, '2026-04-20 10:00:00'),
(5, 3, 750000, '2026-04-20 10:15:00'),
(5, 4, 800000, '2026-04-20 10:30:00'),
(5, 1, 850000, '2026-04-20 10:45:00');

-- Subasta del monitor
INSERT INTO Oferta
(id_publicacion, id_usuario, monto, fecha_oferta)
VALUES
(7, 2, 125000, '2026-04-21 11:00:00'),
(7, 6, 135000, '2026-04-21 11:20:00'),
(7, 2, 150000, '2026-04-21 11:40:00');

-- Subasta del teclado
INSERT INTO Oferta
(id_publicacion, id_usuario, monto, fecha_oferta)
VALUES
(9, 8, 85000, '2026-04-22 12:00:00'),
(9, 2, 90000, '2026-04-22 12:15:00'),
(9, 8, 100000, '2026-04-22 12:30:00');
