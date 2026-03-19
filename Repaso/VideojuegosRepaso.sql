use VideoJuegos;

CREATE TABLE IF NOT EXISTS `VideoJuegos`.`Equipos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Capitan` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  INDEX `fk_Equipos_Capitan_idx` (`Capitan` ASC) VISIBLE,
  UNIQUE INDEX `Capitan_UNIQUE` (`Capitan` ASC) VISIBLE,
  CONSTRAINT `fk_Equipos_Capitan`
    FOREIGN KEY (`Capitan`)
    REFERENCES `VideoJuegos`.`Jugadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE IF NOT EXISTS `VideoJuegos`.`Jugadores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Fecha_de_nacimiento` DATE NOT NULL,
  `Pais` VARCHAR(45) NOT NULL,
  `Equipos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `fk_Jugadores_Equipos_idx` (`Equipos_id` ASC) VISIBLE,
  CONSTRAINT `fk_Jugadores_Equipos`
    FOREIGN KEY (`Equipos_id`)
    REFERENCES `VideoJuegos`.`Equipos` (`id`));
    
    CREATE TABLE IF NOT EXISTS `VideoJuegos`.`Videojuegos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Genero` VARCHAR(45) NOT NULL,
  `Clasificacion_de_edad_minima` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `VideoJuegos`.`Torneos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Fecha_de_inicio` DATE NOT NULL,
  `Fecha_fin` DATE NOT NULL,
  `Premio` INT NOT NULL,
  `Videojuegos_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_Torneos_Videojuegos1_idx` (`Videojuegos_id` ASC) VISIBLE,
  CONSTRAINT `fk_Torneos_Videojuegos1`
    FOREIGN KEY (`Videojuegos_id`)
    REFERENCES `VideoJuegos`.`Videojuegos` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    check (`Fecha_fin` > `Fecha_de_inicio`),
    check (`Premio` >=0 ));

CREATE TABLE IF NOT EXISTS `VideoJuegos`.`Equipos_has_Torneos` (
  `Equipos_id` INT NOT NULL,
  `Torneos_id` INT NOT NULL,
  `Fecha_de_inscripcion` DATE NOT NULL,
  `Posicion_Final` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Equipos_id`, `Torneos_id`),
  INDEX `fk_Equipos_has_Torneos_Torneos1_idx` (`Torneos_id` ASC) VISIBLE,
  INDEX `fk_Equipos_has_Torneos_Equipos1_idx` (`Equipos_id` ASC) VISIBLE,
  CONSTRAINT `fk_Equipos_has_Torneos_Equipos1`
    FOREIGN KEY (`Equipos_id`)
    REFERENCES `VideoJuegos`.`Equipos` (`id`),
  CONSTRAINT `fk_Equipos_has_Torneos_Torneos1`
    FOREIGN KEY (`Torneos_id`)
    REFERENCES `VideoJuegos`.`Torneos` (`id`));



