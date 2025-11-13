**Домашнее задание**  
Оконные функции (задание для QA)  

Цель:  
научиться проектировать, использовать и анализировать оконные функции с учётом граничных случаев;  


Описание/Пошаговая инструкция выполнения домашнего задания:  
Для этого домашнего занятия вам понадобятся пустые таблицы:  
```
CREATE TABLE stores (
    store_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(50) NOT NULL
);

CREATE TABLE sales (
    sale_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    store_id BIGINT REFERENCES stores (store_id),
    date TIMESTAMP NOT NULL,
    sale_amount DECIMAL(10,2) NOT NULL
);
```
Напишите хранимую процедуру (или скрипт на любом языке программирования) со следующей функциональностью:  
сгенерировать 10 магазинов в таблице stores  
сгенерировать 100000 продаж в таблице sales за последние 2 года  
продажи должны быть распределены НЕРАВНОМЕРНО между магазинами (70-75% продаж должны быть в каком-то одном магазине)  
Напишите запрос, который выведет нарастающий итог продаж по каждому магазину с группировкой по месяцам.  

Напишите запрос, который выведет 7-дневное скользящее среднее за последний месяц по самому плодовитому магазину.  

Опишите, какие граничные случаи вы учли в своих запросах:   
по нарастающему итогу часть информации была на занятии
по скользящему среднему нужно подумать самостоятельно

Решение:  
Cгенерировать 10 магазинов в таблице stores:
Создаём процедуру:  
```
CREATE PROCEDURE addShop(IN json_array TEXT)
BEGIN
    DECLARE i INT;
   	DECLARE j INT;
    DECLARE array_length INT;
    DECLARE store_address VARCHAR(255);
    DECLARE store_id INT;
   	DECLARE rand_num INT;
    DECLARE store_count INT;
    DECLARE sales_parts INT;
    
    SET array_length = JSON_LENGTH(json_array);
    SET @i := 0;
    
    START TRANSACTION;
    WHILE @i < array_length DO
   		SET @store_address = JSON_UNQUOTE(JSON_EXTRACT(json_array, CONCAT('$[', @i, '].address')));
   		INSERT INTO stores(address) values (@store_address);
   		SET @i:=@i+1;
   	END WHILE;
    COMMIT;
   
   	SET @i := 0;
    SET @store_id = (select min(s.store_id) from stores s);
    START TRANSACTION;
   	WHILE @i < 700 DO
   		SET @rand_num = (FLOOR(1 + RAND() * 730));
    	INSERT INTO sales(store_id, date, sale_amount) values (@store_id, DATE_SUB(CURDATE(), INTERVAL @rand_num DAY),(FLOOR(1 + RAND() * 1000000)));
   		SET @i:=@i+1;
   	END WHILE;
    COMMIT;
   
    SET @i := 0;
    SET @j := ((select max(s.store_id) from sales s));
    SET @store_count = ((select count(s.store_id) from stores s));
   	SET @sales_parts = round(300/@store_count);
   
    WHILE @j <= @store_count DO
    		START TRANSACTION;
   			WHILE @i < @sales_parts DO
   				SET @rand_num = (FLOOR(1 + RAND() * 730));
    			INSERT INTO sales(store_id, date, sale_amount) values (@j, DATE_SUB(CURDATE(), INTERVAL @rand_num DAY),(FLOOR(1 + RAND() * 1000000)));
   				SET @i:=@i+1;
   			END WHILE;
   		    SET @i := 0;
   		    COMMIT;
    SET @j:=@j+1;
    END WHILE;
END
```
Создаём данные:  
```
SET @address_json = '[
{"address": "123 Main Street, Orlando, FL 32801"},
{"address": "456 Ocean Drive, Miami Beach, FL 33139"},
{"address": "789 Palm Avenue, Tampa, FL 33602"},
{"address": "6121 Kirkstone Lane, Windermere, FL 34786"},
{"address": "909 Bay Street, St. Augustine, FL 32084"},
{"address": "221 Baker Street, Key West, FL 33040"},
{"address": "303 Sunset Boulevard, Fort Lauderdale, FL 33315"},
{"address": "567 Citrus Grove, Winter Garden, FL 34787"},
{"address": "888 Sand Dollar Road, Sarasota, FL 34242 "},
{"address": "456 Ocean Drive, Miami Beach, FL 33139"}
]';
```
Вызываем процедуру:  
```
CALL addShop(@address_json);
```
Результат:  
![shops](https://github.com/thornix/otus_dba/blob/main/hw15_cte_and_analytic_functions_in_mysql/shops.jpg)  


Напишите запрос, который выведет нарастающий итог продаж по каждому магазину с группировкой по месяцам:  
```
select MONTH(sl.date) as date, sum(sl.sale_amount) as 
SUM from sales sl join stores st on sl.store_id = st.store_id 
group by MONTH(sl.date) order by SUM desc;
```
Результат:  
![month_sales](https://github.com/thornix/otus_dba/blob/main/hw15_cte_and_analytic_functions_in_mysql/month_sales.jpg)










