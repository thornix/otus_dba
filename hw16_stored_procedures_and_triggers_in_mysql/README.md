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
GRANT EXECUTE ON PROCEDURE online_store.selectProduct TO 'client'@'%';
CREATE USER 'manager'@'%' IDENTIFIED BY 'password';
```
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры:  
```
CREATE PROCEDURE selectProduct(IN category VARCHAR(255), IN price DECIMAL, IN brand VARCHAR(255), IN attribute VARCHAR(255))
BEGIN
	IF (category != 'NULL') THEN
		SELECT p.* FROM products p join categories c on p.category_id = c.category_id WHERE c.name LIKE 'Смартфоны';
	END IF;
	IF (price != 'NULL') THEN
		select * from products p where p.price = price;
	END IF;
	IF (brand != 'NULL') THEN
		select * from products p join brands b on p.brand_id = b.brand_id where b.name like brand;
	END IF;
	IF (attribute != 'NULL') THEN
		select * from product_attributes pa join products ps on pa.product_id = ps.product_id where pa.value like attribute;
	END IF;
END
```



