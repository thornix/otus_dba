## *Домашнее задание*  
Добавляем в модель данных дополнительные индексы и ограничения

**Цель:**  
* Применять индексы в реальном проекте.


**Описание/Пошаговая инструкция выполнения домашнего задания:**  
* Проводим анализ возможных запросов\отчетов\поиска данных.
* Предполагаем возможную кардинальность поля.
* Создаем дополнительные индексы - простые или композитные.
* На каждый индекс пишем краткое описание зачем он нужен (почему по этому полю\полям).
* Думаем какие логические ограничения в БД нужно добавить - например какие поля должны быть уникальны, в какие нужно добавить условия, чтобы не нарушить бизнес логику. Пример - нельзя провести операцию по переводу средств на отрицательную сумму.
* Создаем ограничения по выбранным полям.


**Критерии оценки:**  
* Выполнение ДЗ: 10 баллов  
* плюс 2 балла за красивое решение  
* минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

## **Схема БД:**
![sb_scheme](https://github.com/thornix/otus_dba/blob/main/hw2_dbms_components/drawSQL-image-export.png)

<u> Кейсы: </u>
1) Выгрузка покупок кастомера:  
*SELECT * FROM orders WHERE customer_id = (SELECT id FROM customers WHERE name LIKE 'Ivan');*  
*Имеется кардинальность поля - customer_id, содаём индекс:*    
*CREATE INDEX "orders_customer_id_index" ON "orders"("customer_id");*
--- 
2) Количество покупок товаров определённной категории:  
> select sum(id) from products where category_id = (select id from category where name like 'notebooks')
3) Количество покупок определённого товара:  
> select sum(id) from orders where product_id = (select id from products where name like 'Acer Aspire 3 A315-59-39S9')
4) Поиск всех товаров определённого производителя:  
> select name from products where manufacturer_id = (select id from manufacturer where name like 'Acer')
5) Поиск товара по цене:  
> select * from products where price_id = (select id from prices where price = '52000')


