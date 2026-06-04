USE classicmodels;

-- 1 -- 
DELIMITER //
create procedure compra (in idcliente int, in idproducto text, in cantidad int, in fechaenvio date)
begin 
start transaction;
update products set quantityInStock = quantityInStock - cantidad
where productCode = idproducto;
if(select quantityInStock from products where productCode = idproducto) < 0 then 
rollback;
signal sqlstate '45000' set MESSAGE_TEXT = 'Error, saldo insuficiente';
end if;
commit;
end//
DELIMITER ;

drop procedure compra;

CALL compra (12,'S10_1678', 10000,date(now()))

-- 3 -- 


