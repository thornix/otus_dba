**Домашнее задание**  
Транзакции  

Цель:  
Заполнить свой проект данными.  


Описание/Пошаговая инструкция выполнения домашнего задания:  
Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.  

Загрузить данные из приложенных в материалах csv.  
Реализовать следующими путями:  

LOAD DATA  

Задание со *: загрузить используя  

mysqlimport  

Критерии оценки:  
Выполнение ДЗ: 10 баллов  
плюс 5 баллов за задание со *  
плюс 2 балла за красивое решение   
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены   

Решение:  

1. Храниая процедура для создания новой категории товаров и перемещения в неё товаров определённой категории:
```
CREATE PROCEDURE CreateCategoryAndMoveProducts(IN new_category_name VARCHAR(255),IN old_category_id INT)
BEGIN
    DECLARE new_category_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Создаем категорию
    INSERT INTO categories (name, created_at)
    VALUES (new_category_name, NOW());
    
    SET new_category_id = LAST_INSERT_ID();
    
    -- Если указаны товары для перемещения
    IF old_category_id IS NOT NULL AND old_category_id != '' THEN
        -- Обновляем категорию товаров
        UPDATE products 
        SET category_id = new_category_id,
            updated_at = NOW()
        WHERE category_id = old_category_id;
    END IF;
    
    COMMIT;
    
    SELECT 
        new_category_id AS category_id,
        CONCAT('Категория создана, товары перемещены') AS result;
    
END
``` 

2. Загрузить данные из приложенных в материалах csv:  
Загрузка категорий:    
Перезапустить mysql с опцией - secure-file-priv = ""  

```
LOAD DATA INFILE '/data_upload/categories_import.csv'
INTO TABLE categories
FIELDS TERMINATED BY ','
ENCLOSED BY '\''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, description, parent_category_id)
SET parent_category_id = NULLIF(@parent_id, '');
```


