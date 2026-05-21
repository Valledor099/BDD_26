USE classicmodels;

delimiter //
create event cambiarEstado on schedule every 1 day starts now() do
begin
update orders 
set status ="delayed"
where status="In Process" and requiredDate < date(now());
end//
delimiter ;