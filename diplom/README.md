Схема БД:  
![db_scheme](https://github.com/thornix/otus_dba/blob/main/diplom/db_scheme.jpg)  

[online-store-db2-v1](https://drawsql.app/teams/mkb-7/diagrams/online-store-db2-v1)  

Purchace:   
SET @p_order_id = NULL;  
SET @p_order_number= NULL;  
select @p_order_id,@p_order_number;   
call purchase(1,1,@p_order_id,@p_order_number);  
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
UploadProducts
```
SET @products_json = '[
    {
        "name": "Смартфон iPhone 14",
        "description": "Смартфон с камерой 48 Мп",
        "price": 79999.00,
        "old_price": 84999.00,
        "quantity": 15,
        "category_id": 1,
        "brand": 1,
        "provisioner": 1,
		"quantity": 10
    }
]';

call InsertProductsFromJSON('{
        "name": "Смартфон iPhone 14",
        "description": "Смартфон с камерой 48 Мп",
        "price": 79999.00,
        "old_price": 84999.00,
        "quantity": 15,
        "category_id": 1,
        "brand": 1,
        "provisioner": 1,
		"quantity": 10
    }');
```
```
INSERT INTO online_store_db2.cart_items
(id, cart_id, product_id, quantity, added_at)
VALUES(1, 1, 8, 1, '2024-02-10 14:20:00');
```








