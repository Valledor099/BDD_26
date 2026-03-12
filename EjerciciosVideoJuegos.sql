use VideoJuegos;

/*8*/
SELECT subq.Equiposid FROM 
(select count(Torneos_id) as cantTorneos, eht1.Equipos_id as Equiposid from Equipos_has_Torneos eht1
group by eht1.Equipos_id 
having cantTorneos > 0) subq;


/*5*/
SELECT count(J.id) as Cantidad_Por_Pais, J.Pais from Jugadores J
GROUP BY J.Pais;

/*11*/
SELECT count(t.id) as cant, v.Nombre FROM Torneos t
JOIN Videojuegos v ON t.Videojuegos_id = v.id
GROUP BY t.Videojuegos_id
order by cant DESC
limit 1;

/*INSERT DE PRUEBA*/

INSERT INTO Torneos (Nombre, Fecha_de_inicio, Fecha_fin, Premio, Videojuegos_id) VALUES
('Champions Valorant','2025-01-10','2025-02-10',50000,3);


/*13*/
UPDATE Torneos t
SET t.Premio = t.Premio * 2
WHERE t.id IN (SELECT subq.tid
FROM (SELECT COUNT(eht1.Equipos_id) as cant, eht1.Torneos_id as tid FROM Equipos_has_Torneos eht1
GROUP BY eht1.Torneos_id
HAVING cant < 2) as subq);

/*14*/
UPDATE Videojuegos v
SET v.Nombre = concat('[POPULAR]' , v.Nombre)
WHERE v.id IN (SELECT t.Videojuegos_id FROM Torneos t
GROUP BY t.Videojuegos_id
HAVING count(*) > 1);

/*16*/

DELETE FROM Jugadores 
WHERE Equipos_id IS NULL;

