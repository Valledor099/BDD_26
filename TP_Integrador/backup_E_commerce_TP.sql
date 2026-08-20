-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: E_commerce_TP
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Calificacion`
--

DROP TABLE IF EXISTS `Calificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Calificacion` (
  `id_calificacion` int NOT NULL AUTO_INCREMENT,
  `id_venta` int NOT NULL,
  `id_usuario_evaluado` int NOT NULL,
  `id_calificador` int NOT NULL,
  `puntaje` int NOT NULL,
  `comentario` text,
  `fecha_calificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_calificacion`),
  KEY `id_venta` (`id_venta`),
  KEY `id_usuario_evaluado` (`id_usuario_evaluado`),
  KEY `id_calificador` (`id_calificador`),
  CONSTRAINT `Calificacion_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `Venta` (`id_venta`),
  CONSTRAINT `Calificacion_ibfk_2` FOREIGN KEY (`id_usuario_evaluado`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `Calificacion_ibfk_3` FOREIGN KEY (`id_calificador`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `Calificacion_chk_1` CHECK ((`puntaje` between 1 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Calificacion`
--

LOCK TABLES `Calificacion` WRITE;
/*!40000 ALTER TABLE `Calificacion` DISABLE KEYS */;
INSERT INTO `Calificacion` VALUES (1,1,1,2,90,'Excelente vendedor, llegó todo a tiempo.','2026-08-13 11:45:51'),(2,1,1,3,80,'Buena atención y producto en buen estado.','2026-08-13 11:45:55');
/*!40000 ALTER TABLE `Calificacion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost`*/ /*!50003 TRIGGER `trg_after_calificacion` AFTER INSERT ON `Calificacion` FOR EACH ROW BEGIN
    DECLARE v_promedio INT;

    -- Calcular el promedio redondeado de los puntajes del usuario
    SELECT ROUND(AVG(puntaje)) INTO v_promedio FROM Calificacion
    WHERE id_usuario_evaluado = NEW.id_usuario_evaluado;

    -- Actualizar el campo 'reputacion' en la tabla Usuarios
    UPDATE Usuarios
    SET reputacion = v_promedio
    WHERE id_usuario = NEW.id_usuario_evaluado;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Categoria`
--

DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria`
--

LOCK TABLES `Categoria` WRITE;
/*!40000 ALTER TABLE `Categoria` DISABLE KEYS */;
INSERT INTO `Categoria` VALUES (1,'Electronica'),(2,'Ropa'),(3,'Hogar'),(4,'Deportes'),(5,'Videojuegos'),(6,'Libros'),(7,'Celulares'),(8,'Computacion');
/*!40000 ALTER TABLE `Categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Estadistica_Diaria`
--

DROP TABLE IF EXISTS `Estadistica_Diaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Estadistica_Diaria` (
  `id_estadistica` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `cantidad_vendedores` int NOT NULL,
  `cantidad_compradores` int NOT NULL,
  `cantidad_productos` int NOT NULL,
  `cantidad_ventas` int NOT NULL,
  `facturacion_total` float NOT NULL,
  PRIMARY KEY (`id_estadistica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Estadistica_Diaria`
--

LOCK TABLES `Estadistica_Diaria` WRITE;
/*!40000 ALTER TABLE `Estadistica_Diaria` DISABLE KEYS */;
/*!40000 ALTER TABLE `Estadistica_Diaria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Estado`
--

DROP TABLE IF EXISTS `Estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Estado` (
  `id_estado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Estado`
--

LOCK TABLES `Estado` WRITE;
/*!40000 ALTER TABLE `Estado` DISABLE KEYS */;
INSERT INTO `Estado` VALUES (1,'Activa'),(2,'Finalizada'),(3,'Pausada'),(4,'Observada');
/*!40000 ALTER TABLE `Estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MedioDeEnvio`
--

DROP TABLE IF EXISTS `MedioDeEnvio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MedioDeEnvio` (
  `id_medioEnvio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_medioEnvio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedioDeEnvio`
--

LOCK TABLES `MedioDeEnvio` WRITE;
/*!40000 ALTER TABLE `MedioDeEnvio` DISABLE KEYS */;
INSERT INTO `MedioDeEnvio` VALUES (1,'OCA'),(2,'Correo Argentino');
/*!40000 ALTER TABLE `MedioDeEnvio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MedioDePago`
--

DROP TABLE IF EXISTS `MedioDePago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MedioDePago` (
  `id_medioPago` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_medioPago`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedioDePago`
--

LOCK TABLES `MedioDePago` WRITE;
/*!40000 ALTER TABLE `MedioDePago` DISABLE KEYS */;
INSERT INTO `MedioDePago` VALUES (1,'Tarjeta de credito'),(2,'Tarjeta de debito'),(3,'Pago Facil'),(4,'Rapipago');
/*!40000 ALTER TABLE `MedioDePago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NivelExposicion`
--

DROP TABLE IF EXISTS `NivelExposicion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NivelExposicion` (
  `id_nivelExposicion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_nivelExposicion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NivelExposicion`
--

LOCK TABLES `NivelExposicion` WRITE;
/*!40000 ALTER TABLE `NivelExposicion` DISABLE KEYS */;
INSERT INTO `NivelExposicion` VALUES (1,'Bronce'),(2,'Plata'),(3,'Oro'),(4,'Platino');
/*!40000 ALTER TABLE `NivelExposicion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nivel_Usuario`
--

DROP TABLE IF EXISTS `Nivel_Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nivel_Usuario` (
  `id_nivel_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(15) NOT NULL,
  PRIMARY KEY (`id_nivel_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nivel_Usuario`
--

LOCK TABLES `Nivel_Usuario` WRITE;
/*!40000 ALTER TABLE `Nivel_Usuario` DISABLE KEYS */;
INSERT INTO `Nivel_Usuario` VALUES (1,'Normal'),(2,'Platinum'),(3,'Gold');
/*!40000 ALTER TABLE `Nivel_Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notificacion`
--

DROP TABLE IF EXISTS `Notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notificacion` (
  `id_notificacion` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `fecha` datetime NOT NULL,
  `leida` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_notificacion`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `Notificacion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notificacion`
--

LOCK TABLES `Notificacion` WRITE;
/*!40000 ALTER TABLE `Notificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Oferta`
--

DROP TABLE IF EXISTS `Oferta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Oferta` (
  `id_oferta` int NOT NULL AUTO_INCREMENT,
  `id_publicacion` int NOT NULL,
  `id_usuario` int NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `fecha_oferta` datetime NOT NULL,
  PRIMARY KEY (`id_oferta`),
  KEY `id_publicacion` (`id_publicacion`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `Oferta_ibfk_1` FOREIGN KEY (`id_publicacion`) REFERENCES `Publicacion` (`id_publicacion`),
  CONSTRAINT `Oferta_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Oferta`
--

LOCK TABLES `Oferta` WRITE;
/*!40000 ALTER TABLE `Oferta` DISABLE KEYS */;
INSERT INTO `Oferta` VALUES (1,5,1,720000.00,'2026-04-20 10:00:00'),(2,5,3,750000.00,'2026-04-20 10:15:00'),(3,5,4,800000.00,'2026-04-20 10:30:00'),(4,5,1,850000.00,'2026-04-20 10:45:00'),(5,7,2,125000.00,'2026-04-21 11:00:00'),(6,7,6,135000.00,'2026-04-21 11:20:00'),(7,7,2,150000.00,'2026-04-21 11:40:00'),(8,9,8,85000.00,'2026-04-22 12:00:00'),(9,9,2,90000.00,'2026-04-22 12:15:00'),(10,9,8,100000.00,'2026-04-22 12:30:00'),(11,5,2,900000.00,'2026-08-13 11:56:39');
/*!40000 ALTER TABLE `Oferta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost`*/ /*!50003 TRIGGER `trg_before_oferta` BEFORE INSERT ON `Oferta` FOR EACH ROW BEGIN
    DECLARE v_id_estado INT;
    DECLARE v_id_vendedor INT;
    DECLARE v_max_monto FLOAT;

    -- 1. Obtener estado y vendedor de la publicación
    SELECT id_estado, id_vendedor INTO v_id_estado, v_id_vendedor FROM Publicacion 
    WHERE id_publicacion = NEW.id_publicacion;

    -- Validar que la publicación esté Activa (id_estado = 1)
    IF v_id_estado != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La publicación no está activa o ya finalizó.';
    END IF;

    -- 2. Validar que el usuario no sea el vendedor
    IF NEW.id_usuario = v_id_vendedor THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No puedes realizar una oferta en tu propia publicación.';
    END IF;

    -- 3. Validar que el monto pujado sea el mayor
	SELECT MAX(monto) INTO v_max_monto FROM Oferta
	WHERE id_publicacion = NEW.id_publicacion;

	IF v_max_monto IS NULL THEN
		SET v_max_monto = 0;
	END IF;

    IF NEW.monto <= v_max_monto THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El monto de la puja debe superar a la oferta máxima actual.';
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Preguntas_Respuestas`
--

DROP TABLE IF EXISTS `Preguntas_Respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Preguntas_Respuestas` (
  `id_pregunta` int NOT NULL AUTO_INCREMENT,
  `id_publicacion` int NOT NULL,
  `id_usuario` int NOT NULL,
  `pregunta` text NOT NULL,
  `respuesta` text,
  `fecha_pregunta` datetime NOT NULL,
  `fecha_respuesta` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pregunta`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_publicacion` (`id_publicacion`),
  CONSTRAINT `Preguntas_Respuestas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `Preguntas_Respuestas_ibfk_2` FOREIGN KEY (`id_publicacion`) REFERENCES `Publicacion` (`id_publicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Preguntas_Respuestas`
--

LOCK TABLES `Preguntas_Respuestas` WRITE;
/*!40000 ALTER TABLE `Preguntas_Respuestas` DISABLE KEYS */;
INSERT INTO `Preguntas_Respuestas` VALUES (1,1,2,'¿Los auriculares tienen garantia?','Si, tienen garantia de seis meses.','2026-04-11 10:00:00','2026-04-11 11:00:00'),(2,1,3,'¿Cuanto dura la bateria?','La bateria dura aproximadamente 20 horas.','2026-04-11 12:00:00','2026-04-11 13:00:00'),(3,3,1,'¿La notebook tiene sistema operativo?','Si, viene con Windows instalado.','2026-04-12 10:00:00','2026-04-12 11:00:00'),(4,3,6,'¿Tiene garantia?',NULL,'2026-04-12 13:00:00',NULL),(5,5,4,'¿La PlayStation incluye joystick?','Si, incluye un joystick original.','2026-04-13 14:00:00','2026-04-13 15:00:00'),(6,7,6,'¿El monitor tiene entrada HDMI?','Si, cuenta con entrada HDMI.','2026-04-14 16:00:00','2026-04-14 17:00:00'),(7,9,2,'¿El teclado tiene iluminacion RGB?','Si, posee iluminacion RGB configurable.','2026-04-15 18:00:00','2026-04-15 19:00:00'),(8,10,8,'¿La pelota es apta para partidos oficiales?','Si, es de tamaño reglamentario.','2026-04-16 10:00:00','2026-04-16 11:00:00'),(9,1,2,'¿Tienen stock para retirar hoy mismo?',NULL,'2026-08-13 09:15:00',NULL),(10,1,3,'¿Hacen envíos a CABA en el día?',NULL,'2026-08-13 10:30:00',NULL),(11,1,4,'¿El producto viene en caja sellada original?',NULL,'2026-08-13 11:00:00',NULL),(12,3,5,'¿Se le puede agregar más memoria RAM?',NULL,'2026-08-13 10:00:00',NULL),(13,3,2,'¿La distribución del teclado es en español?',NULL,'2026-08-13 12:45:00',NULL),(14,5,7,'¿Viene con algún juego físico incluido?',NULL,'2026-08-13 14:00:00',NULL);
/*!40000 ALTER TABLE `Preguntas_Respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `fecha_creacion` datetime NOT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_producto_nombre` (`nombre`),
  CONSTRAINT `Producto_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
INSERT INTO `Producto` VALUES (1,1,'Auriculares Bluetooth','Auriculares inalambricos con cancelacion de ruido y bateria de larga duracion.','2026-03-01 10:00:00'),(2,2,'Zapatillas deportivas','Zapatillas deportivas ideales para running y entrenamiento.','2026-03-02 11:00:00'),(3,3,'Notebook Lenovo','Notebook Lenovo con 16GB de RAM, 512GB SSD y pantalla Full HD.','2026-03-03 12:00:00'),(4,4,'Samsung Galaxy A55','Telefono Samsung Galaxy A55 con 128GB de almacenamiento.','2026-03-04 13:00:00'),(5,5,'PlayStation 5','Consola PlayStation 5 con un joystick DualSense incluido.','2026-03-05 14:00:00'),(6,6,'Campera deportiva','Campera deportiva impermeable para actividades al aire libre.','2026-03-06 15:00:00'),(7,7,'Monitor 24 pulgadas','Monitor Full HD de 24 pulgadas con entrada HDMI.','2026-03-07 16:00:00'),(8,8,'Libro de programacion','Libro introductorio sobre programacion y bases de datos.','2026-03-08 17:00:00'),(9,9,'Teclado mecanico RGB','Teclado mecanico con iluminacion RGB y switches mecanicos.','2026-03-09 18:00:00'),(10,10,'Pelota de futbol','Pelota de futbol de tamaño reglamentario.','2026-03-10 19:00:00');
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicacion`
--

DROP TABLE IF EXISTS `Publicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicacion` (
  `id_publicacion` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(100) DEFAULT NULL,
  `descripicion` text,
  `precio` float NOT NULL,
  `fecha_publicacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_producto` int NOT NULL,
  `id_categoria` int NOT NULL,
  `id_vendedor` int NOT NULL,
  `id_tipo_publicacion` int NOT NULL,
  `id_nivel_exposicion` int NOT NULL,
  `id_estado` int NOT NULL,
  PRIMARY KEY (`id_publicacion`),
  KEY `id_producto` (`id_producto`),
  KEY `id_vendedor` (`id_vendedor`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_tipo_publicacion` (`id_tipo_publicacion`),
  KEY `id_nivel_exposicion` (`id_nivel_exposicion`),
  KEY `idx_publicacion_estado` (`id_estado`),
  CONSTRAINT `Publicacion_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `Producto` (`id_producto`),
  CONSTRAINT `Publicacion_ibfk_2` FOREIGN KEY (`id_vendedor`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `Publicacion_ibfk_3` FOREIGN KEY (`id_categoria`) REFERENCES `Categoria` (`id_categoria`),
  CONSTRAINT `Publicacion_ibfk_4` FOREIGN KEY (`id_tipo_publicacion`) REFERENCES `TipoPublicacion` (`id_tipoPublicacion`),
  CONSTRAINT `Publicacion_ibfk_5` FOREIGN KEY (`id_nivel_exposicion`) REFERENCES `NivelExposicion` (`id_nivelExposicion`),
  CONSTRAINT `Publicacion_ibfk_6` FOREIGN KEY (`id_estado`) REFERENCES `Estado` (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicacion`
--

LOCK TABLES `Publicacion` WRITE;
/*!40000 ALTER TABLE `Publicacion` DISABLE KEYS */;
INSERT INTO `Publicacion` VALUES (1,'Auriculares Bluetooth','Auriculares inalambricos nuevos con cancelacion de ruido.',25000,'2026-08-13 10:36:28',1,1,1,1,1,2),(2,'Zapatillas deportivas','Zapatillas ideales para correr y entrenar.',60000,'2026-04-02 11:00:00',2,4,2,1,2,2),(3,'Notebook Lenovo','Notebook para trabajo, estudio y uso diario.',850000,'2026-08-13 10:36:28',3,8,3,1,4,1),(4,'Samsung Galaxy A55','Samsung Galaxy A55 de 128GB en excelente estado.',500000,'2026-04-04 13:00:00',4,7,4,1,3,2),(5,'PlayStation 5','PlayStation 5 con joystick original incluido.',700000,'2026-08-13 10:36:28',5,5,5,2,4,1),(6,'Campera deportiva','Campera impermeable para actividades deportivas.',90000,'2026-04-06 15:00:00',6,2,6,1,2,1),(7,'Monitor 24 pulgadas','Monitor Full HD ideal para gaming y trabajo.',120000,'2026-08-13 10:36:28',7,8,7,2,3,2),(8,'Libro de programacion','Libro para aprender programacion y bases de datos.',30000,'2026-04-08 17:00:00',8,6,8,1,1,2),(9,'Teclado mecanico RGB','Teclado mecanico RGB ideal para gaming.',80000,'2026-08-13 10:36:28',9,8,9,2,4,1),(10,'Pelota de futbol','Pelota profesional de futbol tamaño reglamentario.',45000,'2026-04-10 19:00:00',10,4,10,1,3,1);
/*!40000 ALTER TABLE `Publicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicacion_MedioPago`
--

DROP TABLE IF EXISTS `Publicacion_MedioPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicacion_MedioPago` (
  `id_publicacion` int NOT NULL,
  `id_medio_pago` int NOT NULL,
  PRIMARY KEY (`id_publicacion`,`id_medio_pago`),
  KEY `id_medio_pago` (`id_medio_pago`),
  CONSTRAINT `Publicacion_MedioPago_ibfk_1` FOREIGN KEY (`id_publicacion`) REFERENCES `Publicacion` (`id_publicacion`),
  CONSTRAINT `Publicacion_MedioPago_ibfk_2` FOREIGN KEY (`id_medio_pago`) REFERENCES `MedioDePago` (`id_medioPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicacion_MedioPago`
--

LOCK TABLES `Publicacion_MedioPago` WRITE;
/*!40000 ALTER TABLE `Publicacion_MedioPago` DISABLE KEYS */;
INSERT INTO `Publicacion_MedioPago` VALUES (1,1),(2,1),(3,1),(1,2),(3,2),(10,2),(6,3),(8,4);
/*!40000 ALTER TABLE `Publicacion_MedioPago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoPublicacion`
--

DROP TABLE IF EXISTS `TipoPublicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoPublicacion` (
  `id_tipoPublicacion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_tipoPublicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoPublicacion`
--

LOCK TABLES `TipoPublicacion` WRITE;
/*!40000 ALTER TABLE `TipoPublicacion` DISABLE KEYS */;
INSERT INTO `TipoPublicacion` VALUES (1,'Venta directa'),(2,'Subasta');
/*!40000 ALTER TABLE `TipoPublicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuarios`
--

DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `direccion` varchar(150) NOT NULL,
  `fecha_creacion` date NOT NULL,
  `cantidad_ventas` int DEFAULT '0',
  `facturacion_total` float DEFAULT '0',
  `reputacion` int DEFAULT '0',
  `nivel_id` int DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `telefono` (`telefono`),
  KEY `nivel_id` (`nivel_id`),
  CONSTRAINT `Usuarios_ibfk_1` FOREIGN KEY (`nivel_id`) REFERENCES `Nivel_Usuario` (`id_nivel_usuario`),
  CONSTRAINT `EsMenorDeCien` CHECK ((`reputacion` <= 100))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios`
--

LOCK TABLES `Usuarios` WRITE;
/*!40000 ALTER TABLE `Usuarios` DISABLE KEYS */;
INSERT INTO `Usuarios` VALUES (1,'Juan','Perez','juan.perez@gmail.com','1234','1123456781','Av. Corrientes 1234, CABA','2026-01-10',2,175000,85,2),(2,'Maria','Gomez','maria.gomez@gmail.com','1234','1123456782','Av. Santa Fe 2345, CABA','2026-01-12',3,45000,85,1),(3,'Carlos','Rodriguez','carlos.rodriguez@gmail.com','1234','1123456783','Av. Rivadavia 3456, CABA','2026-01-15',8,150000,92,2),(4,'Lucia','Fernandez','lucia.fernandez@gmail.com','1234','1123456784','Av. Belgrano 4567, CABA','2026-01-18',12,800000,96,3),(5,'Pedro','Martinez','pedro.martinez@gmail.com','1234','1123456785','Av. Cabildo 5678, CABA','2026-02-01',15,1200000,98,3),(6,'Sofia','Lopez','sofia.lopez@gmail.com','1234','1123456786','Av. Pueyrredon 6789, CABA','2026-02-05',5,90000,78,1),(7,'Diego','Sanchez','diego.sanchez@gmail.com','1234','1123456787','Av. Callao 7890, CABA','2026-02-10',7,110000,88,2),(8,'Valentina','Diaz','valentina.diaz@gmail.com','1234','1123456788','Av. Palermo 8901, CABA','2026-02-15',0,0,0,NULL),(9,'Martin','Torres','martin.torres@gmail.com','1234','1123456789','Av. Medrano 9012, CABA','2026-02-20',11,500000,90,3),(10,'Camila','Ruiz','camila.ruiz@gmail.com','1234','1123456790','Av. Lacroze 1122, CABA','2026-03-01',2,30000,75,1);
/*!40000 ALTER TABLE `Usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Venta`
--

DROP TABLE IF EXISTS `Venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Venta` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `id_publicacion` int NOT NULL,
  `id_comprador` int NOT NULL,
  `id_medio_pago` int NOT NULL,
  `id_medio_envio` int NOT NULL,
  `fecha_venta` datetime NOT NULL,
  `monto` float NOT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `id_publicacion` (`id_publicacion`),
  KEY `id_comprador` (`id_comprador`),
  KEY `id_medio_pago` (`id_medio_pago`),
  KEY `id_medio_envio` (`id_medio_envio`),
  CONSTRAINT `Venta_ibfk_1` FOREIGN KEY (`id_publicacion`) REFERENCES `Publicacion` (`id_publicacion`),
  CONSTRAINT `Venta_ibfk_2` FOREIGN KEY (`id_comprador`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `Venta_ibfk_3` FOREIGN KEY (`id_medio_pago`) REFERENCES `MedioDePago` (`id_medioPago`),
  CONSTRAINT `Venta_ibfk_4` FOREIGN KEY (`id_medio_envio`) REFERENCES `MedioDeEnvio` (`id_medioEnvio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Venta`
--

LOCK TABLES `Venta` WRITE;
/*!40000 ALTER TABLE `Venta` DISABLE KEYS */;
INSERT INTO `Venta` VALUES (1,2,1,1,2,'2026-04-20 10:30:00',60000),(2,4,3,2,1,'2026-04-21 15:00:00',500000),(3,8,5,3,2,'2026-04-22 17:30:00',30000),(4,1,2,1,1,'2026-08-13 11:32:30',150000),(5,1,2,1,1,'2026-08-20 09:59:13',25000);
/*!40000 ALTER TABLE `Venta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost`*/ /*!50003 TRIGGER `trg_after_venta_nivel` AFTER INSERT ON `Venta` FOR EACH ROW BEGIN
    DECLARE v_id_vendedor INT;
    DECLARE v_ventas INT;
    DECLARE v_facturacion FLOAT;
    DECLARE v_nuevo_nivel INT;

    -- Obtener el vendedor de la publicación vendida
    SELECT id_vendedor INTO v_id_vendedor FROM Publicacion 
    WHERE id_publicacion = NEW.id_publicacion;

    -- Actualizar las métricas del vendedor
    UPDATE Usuarios 
    SET cantidad_ventas = cantidad_ventas + 1,
        facturacion_total = facturacion_total + NEW.monto
    WHERE id_usuario = v_id_vendedor;

    -- Consultar las nuevas métricas actualizadas
    SELECT cantidad_ventas, facturacion_total INTO v_ventas, v_facturacion FROM Usuarios 
    WHERE id_usuario = v_id_vendedor;

    -- Lógica para asignar el id_nivel_usuario según las nuevas reglas
    -- Se evalúa desde la condición más alta a la más baja
    IF v_ventas >= 11 OR v_facturacion >= 1000000 THEN
        SET v_nuevo_nivel = 3;
    
    ELSEIF v_ventas >= 6 OR v_facturacion >= 100000 THEN
        SET v_nuevo_nivel = 2;
    
    ELSE
        SET v_nuevo_nivel = 1;
    END IF;

    -- Actualizar el nivel del usuario
    UPDATE Usuarios 
    SET nivel_id = v_nuevo_nivel 
    WHERE id_usuario = v_id_vendedor;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vw_mejor_vendedor_categoria`
--

DROP TABLE IF EXISTS `vw_mejor_vendedor_categoria`;
/*!50001 DROP VIEW IF EXISTS `vw_mejor_vendedor_categoria`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_mejor_vendedor_categoria` AS SELECT 
 1 AS `categoria`,
 1 AS `vendedor`,
 1 AS `reputacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_preguntas_sin_respuesta`
--

DROP TABLE IF EXISTS `vw_preguntas_sin_respuesta`;
/*!50001 DROP VIEW IF EXISTS `vw_preguntas_sin_respuesta`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_preguntas_sin_respuesta` AS SELECT 
 1 AS `id_pregunta`,
 1 AS `descripcion`,
 1 AS `id_publicacion`,
 1 AS `nombre_producto`,
 1 AS `nombre_vendedor`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_publicaciones_tendencia_hoy`
--

DROP TABLE IF EXISTS `vw_publicaciones_tendencia_hoy`;
/*!50001 DROP VIEW IF EXISTS `vw_publicaciones_tendencia_hoy`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_publicaciones_tendencia_hoy` AS SELECT 
 1 AS `id_publicacion`,
 1 AS `titulo`,
 1 AS `producto`,
 1 AS `cantidad_preguntas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_top_10_categorias_semana`
--

DROP TABLE IF EXISTS `vw_top_10_categorias_semana`;
/*!50001 DROP VIEW IF EXISTS `vw_top_10_categorias_semana`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_top_10_categorias_semana` AS SELECT 
 1 AS `id_categoria`,
 1 AS `categoria`,
 1 AS `cantidad_publicaciones`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_mejor_vendedor_categoria`
--

/*!50001 DROP VIEW IF EXISTS `vw_mejor_vendedor_categoria`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mejor_vendedor_categoria` AS select `c`.`nombre` AS `categoria`,concat(`u`.`nombre`,' ',`u`.`apellido`) AS `vendedor`,`u`.`reputacion` AS `reputacion` from ((`Categoria` `c` join `Publicacion` `p` on((`c`.`id_categoria` = `p`.`id_categoria`))) join `Usuarios` `u` on((`p`.`id_vendedor` = `u`.`id_usuario`))) where (`u`.`reputacion` = (select max(`u2`.`reputacion`) from (`Publicacion` `p2` join `Usuarios` `u2` on((`p2`.`id_vendedor` = `u2`.`id_usuario`))) where (`p2`.`id_categoria` = `c`.`id_categoria`))) group by `c`.`id_categoria`,`c`.`nombre`,`u`.`id_usuario`,`u`.`nombre`,`u`.`apellido`,`u`.`reputacion` order by `u`.`reputacion` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_preguntas_sin_respuesta`
--

/*!50001 DROP VIEW IF EXISTS `vw_preguntas_sin_respuesta`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_preguntas_sin_respuesta` AS select `pr`.`id_pregunta` AS `id_pregunta`,`pr`.`pregunta` AS `descripcion`,`p`.`id_publicacion` AS `id_publicacion`,`prod`.`nombre` AS `nombre_producto`,`u`.`nombre` AS `nombre_vendedor` from (((`Preguntas_Respuestas` `pr` join `Publicacion` `p` on((`pr`.`id_publicacion` = `p`.`id_publicacion`))) join `Producto` `prod` on((`p`.`id_producto` = `prod`.`id_producto`))) join `Usuarios` `u` on((`p`.`id_vendedor` = `u`.`id_usuario`))) where ((`p`.`id_estado` = 1) and (`pr`.`respuesta` is null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_publicaciones_tendencia_hoy`
--

/*!50001 DROP VIEW IF EXISTS `vw_publicaciones_tendencia_hoy`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_publicaciones_tendencia_hoy` AS select `p`.`id_publicacion` AS `id_publicacion`,`p`.`titulo` AS `titulo`,`prod`.`nombre` AS `producto`,count(`pr`.`id_pregunta`) AS `cantidad_preguntas` from ((`Publicacion` `p` join `Producto` `prod` on((`p`.`id_producto` = `prod`.`id_producto`))) join `Preguntas_Respuestas` `pr` on((`p`.`id_publicacion` = `pr`.`id_publicacion`))) where (cast(`pr`.`fecha_pregunta` as date) = curdate()) group by `p`.`id_publicacion`,`p`.`titulo`,`prod`.`nombre` order by `cantidad_preguntas` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_top_10_categorias_semana`
--

/*!50001 DROP VIEW IF EXISTS `vw_top_10_categorias_semana`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.andreoli.castro.thiago`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_top_10_categorias_semana` AS select `c`.`id_categoria` AS `id_categoria`,`c`.`nombre` AS `categoria`,count(`p`.`id_publicacion`) AS `cantidad_publicaciones` from (`Categoria` `c` join `Publicacion` `p` on((`c`.`id_categoria` = `p`.`id_categoria`))) where (yearweek(`p`.`fecha_publicacion`,1) = yearweek(curdate(),1)) group by `c`.`id_categoria`,`c`.`nombre` order by `cantidad_publicaciones` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-20 11:08:26
