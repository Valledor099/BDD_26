create database E_commerce_TP;
use E_commerce_TP;

create table if not exists Usuarios(
	id_usuario int auto_increment primary key,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    email varchar(255) not null unique,
    contraseña varchar(255) not null,
    telefono varchar(20) not null unique,
    direccion varchar(150) not null,
    fecha_creacion date not null default 0,
    cantidad_ventas int default 0,
    facturacion_total FLOAT  default 0,
    reputacion int default 0,
    nivel_id int null,
    constraint EsMenorDeCien
    check (reputacion <= 100),
    constraint FK_NivelUsuario foreign key
    (nivel_id) references nivel_usuario(id_nivel_usuario)
);

create table if not exists nivel_usuario(
	id_nivel_usuario int auto_increment primary key,
    nombre varchar(15) not null
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
FOREIGN KEY (id_vendedor) REFERENCES Venderdor(id_vendedor),
FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
FOREIGN KEY (id_tipo_publicacion) REFERENCES TipoPublicacion(id_tipoPublicacion),
FOREIGN KEY (id_nivel_exposicion) REFERENCES NivelExposicion(id_nivelExposicion),
FOREIGN KEY (id_estado) REFERENCES Categoria(id_estado)
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

create table if not exists Productos(
	id_producto int auto_increment primary key,
    id_usuario int  not null,
    nombre varchar(255) not null,
    descripcion text not null,
	fecha_creacion datetime not null,
	constraint FK_UsuarioId foreign key
    (id_usuario) references Usuarios(id_usuario)
);

CREATE TABLE Categoria(
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);

create table if not exists Preguntas_Respuestas (
	id_pregunta int primary key auto_increment,
	id_publicacion int not null,
	id_usuario int not null,
	pregunta text not null,
	respuesta text null, 
	fecha_pregunta datetime not null,
	fecha_respuesta datetime null,
	constraint FK_UsuarioId foreign key
	(id_usuario) references Usuarios(id_usuario),
	constraint FK_UsuarioId foreign key
	(id_publicacion) references publicacion(id_publicacion)
);

CREATE TABLE MedioDePago(
	id_medioPago INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(25)
);
 
CREATE TABLE MedioDeEnvio(
	id_medioEnvio INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(25)
);

/**/