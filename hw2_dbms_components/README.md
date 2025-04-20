Кейсы:
1) Количество покупок определённого покупателя:  
   select sum(id) from orders where customer_id = (select id from customers where name like 'Ivan')
2) Количество покупок товаров определённной категории:  
   select sum(id) from products where category_id = (select id from category where name like 'notebooks')
3) Количество покупок определённого товара:  
   select sum(id) from orders where product_id = (select id from products where name like 'Acer Aspire 3 A315-59-39S9')
4) Поиск всех товаров определённого производителя:  
   select name from products where manufacturer_id = (select id from manufacturer where name like 'Acer')
5) Поиск товара по цене:  
   select * from products where price_id = (select id from prices where price = '52000')

Схема БД:
![Alt text](https://github.com/thornix/otus_dba/blob/main/hw2_dbms_components/drawSQL-image-export-2025-04-18.png)
