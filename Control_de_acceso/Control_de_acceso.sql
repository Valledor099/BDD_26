USE classicmodels;

/*1*/
create user 'analista_stock'@'localhost' IDENTIFIED BY 'dragon_00';
create user 'gestor_productos'@'localhost' IDENTIFIED BY 'Dragon_01';
create user 'analista_ordenes'@'localhost' IDENTIFIED BY 'dragon_32';
create user 'user_reportes'@'localhost' IDENTIFIED BY 'DRag0n_208';
create user 'desarrollo'@'localhost' IDENTIFIED BY 'DR4g0N_12';
create user 'admin_bdd'@'localhost' IDENTIFIED BY 'dr4Gon_92';


SELECT * FROM mysql.user;


 use stock;
/*2*/
-- ROL STOCK
CREATE ROLE 'rol_stock'@'%';
grant SELECT ON stock.* to 'rol_stock'@'%';
GRANT EXECUTE ON PROCEDURE stock.actualizarStock TO 'rol_stock'@'%';
GRANT EXECUTE ON PROCEDURE stock.reducirPrecio TO 'rol_stock'@'%';
GRANT EXECUTE ON PROCEDURE stock.actualizarPrecioPorProveedor TO 'rol_stock'@'%';


delimiter //
CREATE PROCEDURE actualizarStock()
begin
end//
delimiter ;

delimiter //
CREATE PROCEDURE reducirPrecio()
begin
end//
delimiter ;

delimiter //
CREATE PROCEDURE actualizarPrecioPorProveedor()
begin
end//
delimiter ;


-- ROL gestion_ordenes
CREATE ROLE 'gestion_ordenes';
GRANT execute on procedure classicmodels.borrarOrden to 'gestion_ordenes';
GRANT execute on procedure classicmodels.borrarLinea to 'gestion_ordenes';
GRANT execute on procedure classicmodels.modificarComment to 'gestion_ordenes';
GRANT SELECT on classicmodels.orders to 'gestion_ordenes';
GRANT SELECT on classicmodels.orderdetails to 'gestion_ordenes';


-- ROL reportes
CREATE ROLE 'reportes';
GRANT select on classicmodels.* to 'reportes';
grant select on stock.* to 'reportes';
GRANT execute ON function classicmodels.* TO 'reportes';


-- ROL desarrollo
CREATE ROLE 'desarrollo';
GRANT SELECT on classicmodels.* TO 'desarrollo';
GRANT SELECT on stock.* TO 'desarrollo';
GRANT INSERT on classicmodels.* TO 'desarrollo';
GRANT INSERT on stock.* TO 'desarrollo';
GRANT UPDATE on classicmodels.* TO 'desarrollo';
GRANT UPDATE on stock.* TO 'desarrollo';
GRANT DELETE on classicmodels.* TO 'desarrollo';
GRANT DELETE on stock.* TO 'desarrollo';
GRANT TRIGGER on classicmodels.* TO 'desarrollo';
GRANT TRIGGER on stock.* TO 'desarrollo';
GRANT EVENT on classicmodels.* TO 'desarrollo';
GRANT EVENT on stock.* TO 'desarrollo';
GRANT ROUTINE on classicmodels.* TO 'desarrollo';
GRANT ROUTINE on stock.* TO 'desarrollo';




-- ROL administrador
create role 'administrador';
GRANT ALL privileges ON classicmodels.* TO 'administrador';
GRANT ALL privileges ON stock.* TO 'administrador';

show grants for 'rol_stock';

/*3*/
GRANT 'rol_stock' TO 'analista_stock'@'localhost';
DROP user 'analista_stock'@'localhost';
DROP ROLE 'rol_stock';

GRANT 'gestion_ordenes' TO 'gestor_productos'@'localhost';
GRANT 'reportes' TO 'user_reportes'@'localhost';
GRANT 'desarrollo' TO 'desarrollo'@'localhost';
GRANT 'administrador' TO 'admin_bdd'@'localhost';

use stock;
select * from categoria;


SET GLOBAL activate_all_roles_on_login = ON;
