use VideoJuegos;
/*8-11-13-14-16-5*/		

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO Equipos (id, Nombre, Capitan) VALUES
(1,'Dragones',1),
(2,'Titanes',2),
(3,'Fenix',3),
(4,'Samurais',4),
(5,'Vikingos',5),
(6,'Leones',6),
(7,'Gladiadores',7),
(8,'Panteras',8),
(9,'Halcones',9),
(10,'Kraken',10);

INSERT INTO Jugadores (id, Nombre, Apellido, Email, Fecha_de_nacimiento, Pais, Equipos_id) VALUES
(1,'Juan','Perez','juan1@gmail.com','2000-05-10','Argentina',1),
(2,'Martin','Gomez','martin2@gmail.com','1999-07-21','Chile',2),
(3,'Lucas','Fernandez','lucas3@gmail.com','2001-03-15','Uruguay',3),
(4,'Pedro','Sosa','pedro4@gmail.com','1998-11-30','Argentina',4),
(5,'Santiago','Lopez','santiago5@gmail.com','2002-06-08','Mexico',5),
(6,'Andres','Diaz','andres6@gmail.com','1997-09-19','Peru',6),
(7,'Javier','Torres','javier7@gmail.com','2000-12-25','Colombia',7),
(8,'Fernando','Castro','fernando8@gmail.com','1996-04-11','Argentina',8),
(9,'Mateo','Rojas','mateo9@gmail.com','2001-08-17','Chile',9),
(10,'Nicolas','Silva','nicolas10@gmail.com','1999-01-05','Uruguay',10);



INSERT INTO Videojuegos (Nombre, Genero, Clasificacion_de_edad_minima) VALUES
('League of Legends','MOBA',13),
('Counter Strike 2','FPS',16),
('Valorant','FPS',16),
('Dota 2','MOBA',13),
('Fortnite','Battle Royale',12),
('Rocket League','Deportes',3),
('Overwatch 2','FPS',13),
('Call of Duty Warzone','Battle Royale',18),
('Apex Legends','Battle Royale',16),
('EA Sports FC 24','Deportes',3);

INSERT INTO Torneos (Nombre, Fecha_de_inicio, Fecha_fin, Premio, Videojuegos_id) VALUES
('Worlds LoL','2025-01-10','2025-02-10',50000,1),
('CS Major','2025-02-15','2025-03-10',40000,2),
('Valorant Masters','2025-03-01','2025-03-20',35000,3),
('The International','2025-04-05','2025-05-01',100000,4),
('Fortnite Global','2025-06-10','2025-07-10',45000,5),
('Rocket League Cup','2025-03-01','2025-03-25',20000,6),
('Overwatch League','2025-04-15','2025-05-20',30000,7),
('Warzone Battle','2025-05-10','2025-06-10',50000,8),
('Apex Predator Cup','2025-07-01','2025-08-01',42000,9),
('FC Pro Series','2025-09-01','2025-09-30',25000,10);

INSERT INTO Equipos_has_Torneos (Equipos_id, Torneos_id, Fecha_de_inscripcion, Posicion_Final) VALUES
(1,1,'2024-12-20',1),
(2,1,'2024-12-21',2),
(3,2,'2025-01-30',1),
(4,2,'2025-01-30',3),
(5,3,'2025-02-10',NULL),
(6,4,'2025-03-10',NULL),
(7,5,'2025-05-01',NULL),
(8,6,'2025-02-20',2),
(9,7,'2025-03-25',NULL),
(10,8,'2025-04-15',NULL);



SET FOREIGN_KEY_CHECKS = 1;


