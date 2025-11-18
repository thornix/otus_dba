**Домашнее задание**  
Добавляем в базу хранимые процедуры и триггеры  

Цель:  
Создавать пользователей, процедуры и триггеры.  

Описание/Пошаговая инструкция выполнения домашнего задания:  
Создать пользователей client, manager.  
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры  
Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи  

дать права да запуск процедуры пользователю client  
Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)  
Права дать пользователю manager  

Критерии оценки:  
Выполнение ДЗ: 10 баллов  
плюс 2 балла за красивое решение  
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**Решение:**  
Создать пользователей client, manager:  
```
CREATE USER 'client'@'%' IDENTIFIED BY 'password';
CREATE USER 'manager'@'%' IDENTIFIED BY 'password';
```
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры:  
```
CREATE PROCEDURE selectProduct(
IN category VARCHAR(255), 
IN price DECIMAL, 
IN brand VARCHAR(255), 
IN attribute VARCHAR(255),
IN sortproductname VARCHAR(255)
)
BEGIN
	IF (category != 'NULL') THEN
		IF (sortproductname != 'NULL') THEN
			SELECT p.name FROM products p join categories c on p.category_id = c.category_id WHERE c.name LIKE category ORDER BY CONCAT('c.', sortproductname);
		ELSE
			SELECT p.name FROM products p join categories c on p.category_id = c.category_id WHERE c.name LIKE category;
		END IF;
	END IF;
	IF (price != 'NULL') THEN
		IF (sortproductname != 'NULL') THEN
			SELECT p.name FROM products p join categories c on p.category_id = c.category_id WHERE p.price = price ORDER BY CONCAT('c.', sortproductname);
		ELSE
			SELECT p.name FROM products p WHERE p.price = price;
		END IF;
	END IF;
	IF (brand != 'NULL') THEN
		IF (sortproductname != 'NULL') THEN
			SELECT p.name FROM products p join categories c on p.category_id = c.category_id join brands b on p.brand_id = b.brand_id where b.name like brand ORDER BY CONCAT('c.', sortproductname);
		ELSE
			select p.name from products p join brands b on p.brand_id = b.brand_id where b.name like brand;
		END IF;
	END IF;
	IF (attribute != 'NULL') THEN
		select p.name from product_attributes pa join products ps on pa.product_id = ps.product_id where pa.value like attribute;
	END IF;
END
```
Выдать права пользователю client на выполнение процедуры selectProduct:    
```
GRANT EXECUTE ON PROCEDURE online_store.selectProduct TO 'client'@'%';
```
Результат:  
![func_select](https://github.com/thornix/otus_dba/blob/main/hw16_stored_procedures_and_triggers_in_mysql/result_select_proc.jpg)

Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)
```
CREATE PROCEDURE getOrders(
IN hours VARCHAR(255), 
IN day VARCHAR(255), 
IN week VARCHAR(255),
IN product VARCHAR(255),
IN category VARCHAR(255),
IN producer VARCHAR(255)
)
BEGIN
	DECLARE time VARCHAR(255);
	
    IF (hours != 'NULL') THEN
    	SET @time = hours;
    END IF;
    IF (day != 'NULL') THEN
    	SET @time = day;
    END IF;
    IF (week != 'NULL') THEN
    	SET @time = week;
    END IF;
    IF (product != 'NULL') THEN
    	SELECT count(os.order_id),ps.name FROM orders os join order_items oi on os.order_id = oi.order_id join products ps on ps.product_id = oi.order_id where os.created_at > (SUBTIME(NOW(), @time)) group by ps.name;
    END IF;
    IF (category != 'NULL') THEN
    	SELECT count(os.order_id),c.name FROM orders os join order_items oi on os.order_id = oi.order_id join products ps on ps.product_id = oi.order_id join categories c on ps.category_id = c.category_id where os.created_at > (SUBTIME(NOW(), @time)) group by c.name;
    END IF;
    IF (producer != 'NULL') THEN
    	SELECT count(os.order_id),b.name FROM orders os join order_items oi on os.order_id = oi.order_id join products ps on ps.product_id = oi.order_id join categories c on ps.category_id = c.category_id join brands b on b.brand_id = ps.brand_id where os.created_at > (SUBTIME(NOW(), @time)) group by b.name;
    END IF;

END
```
Выдать права пользователю client на выполнение процедуры selectProduct:  
```
GRANT EXECUTE ON PROCEDURE online_store.getOrders TO 'manager'@'%';
```

Результат:  
![func_params](https://github.com/thornix/otus_dba/blob/main/hw16_stored_procedures_and_triggers_in_mysql/func_params.png)













