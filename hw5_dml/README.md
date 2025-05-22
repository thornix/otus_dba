## *Домашнее задание*  
DML в PostgreSQL

**<u>Цель:</u>**  
* Написать запрос с конструкциями SELECT, JOIN;  
* Написать запрос с добавлением данных INSERT INTO;  
* Написать запрос с обновлением данных с UPDATE FROM;  
* Использовать using для оператора DELETE.    


**<u>Описание/Пошаговая инструкция выполнения домашнего задания:</u>**  
* Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.  
* Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?  
* Напишите запрос на добавление данных с выводом информации о добавленных строках.  
* Напишите запрос с обновлением данные используя UPDATE FROM.  
* Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.  

**<u>Задание со \*:</u>**
* Приведите пример использования утилиты COPY  


**<u>Критерии оценки:</u>**  
* Выполнение ДЗ: 10 баллов  
* плюс 5 баллов за задание со *
* плюс 2 балла за красивое решение  
* минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**<u>Решение:</u>**  
1. Поиск всех имён начинающихся с A или B:  
*SELECT * FROM customers WHERE "FirstName" SIMILAR TO '[VB]%';*  
2. Вывести все результаты из таблицы customers, и если есть совпадения,то вывести из orders(LEFT JOIN):    
*select c."FirstName", c."LastName", o.sum from customers c left join orders o on c."ID" = o.customer_id;*
3. Вывести только тех всех покупателей которые имели покупки(INNER JOIN):  
*select c."FirstName", o.sum from customers c inner join orders o on c."ID" = o.customer_id;* 
*Порядок соединений в FROM определяет(напрмер для LEFT JOIN, RIGHT JOIN), какая таблица будет являться базовой и к какой будут добавляться данные из других таблиц.*    
4. *insert into customers values (3, 'Vladimir', 'Petrov', 'male', to_date('YYYY-MM-DD', '19860224'), 'vladimir91@gmail.com', 89024451129, to_date('YYYY-MM-DD','20250525')) returning \*;*  
5. *update customers set FirstName = (select name from customers p where p.id = 2) where id = 1;*  
6. *delete from orders using customers where orders.customer_id = customers."ID";*  
7. Сохранение данных таблицы в файле для последующего восстановления:
   *COPY (SELECT * FROM customers) TO '/path/to/customers.csv' WITH CSV;*  
   *COPY customers_tmp FROM '/path/to/customers.csv' CSV;*  