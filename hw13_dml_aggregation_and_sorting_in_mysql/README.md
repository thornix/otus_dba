**Домашнее задание**  
Создаем отчетную выборку  

Цель:  
Создавать ответную выборку.  


Описание/Пошаговая инструкция выполнения домашнего задания:  
Предоставить следующий результат:  

группировки с ипользованием CASE, HAVING, ROLLUP, GROUPING() :  
для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений  
сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории  
сделать rollup с количеством товаров по категориям  

Критерии оценки:  
Выполнение ДЗ: 10 баллов  
плюс 2 балла за красивое решение  
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**Решение:**  
1.для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений:   
не совсем понял про какой списк говориться. Сделал выборку из таблицы products БД инет.магазина, цена + количество товара:  
```
SELECT p.price, p.stock_quantity FROM products p where p.price = 
(select max(price) from products) or p.price = (select min(price) from products)
```
2. сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории:
```
SELECT c.name, max(p.price), min(p.price) FROM products p join categories c on p.category_id = c.category_id GROUP BY p.category_id
```
3. сделать rollup с количеством товаров по категориям:
```
SELECT c.name, count(p.stock_quantity) FROM products p join categories c on p.category_id = c.category_id GROUP BY c.name
```

Other cases:  
CASE: Есть товар в наличии или нет:  
```
SELECT name, 
CASE
  WHEN stock_quantity > 0 THEN 'in stock'
  ELSE 'not available'
END AS 'availability of goods'
FROM products
```

GROUPING - HAVING: Средняя цена товара в каждой категории с фильтром цены > 1000:  
```
SELECT ROUND(AVG(p.price),2) AS price,c.name AS category
FROM products p JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name HAVING price > 1000;
```

GROUPING - HAVING - ROLLUP: Плюс итог и понятный NULL:
```
SELECT ROUND(AVG(p.price),2) AS price, c.name AS category, GROUPING(c.name)
FROM products p JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name WITH ROLLUP HAVING price > 1000;
```




