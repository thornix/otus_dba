Схема БД:  
![db_scheme](https://github.com/thornix/otus_dba/blob/main/diplom/db_scheme.jpg)  

[online-store-db2-v1](https://drawsql.app/teams/mkb-7/diagrams/online-store-db2-v1)  

Purchace:  
```
drop procedure purchase;
SET @p_order_id = NULL;
SET @p_order_number = NULL;
call purchase(1,1,@p_order_id,@p_order_number);
select @p_order_id, @p_order_number;
select * from orders o 
select * from order_items
update orders set status= 'cancelled' where id = 16;
```






