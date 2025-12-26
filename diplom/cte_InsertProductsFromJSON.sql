USE online_store_db2;

DELIMITER //

CREATE PROCEDURE InsertProductsFromJSON(IN json_data JSON)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE products_count INT DEFAULT 0;
    DECLARE product_name VARCHAR(255);
    DECLARE product_description TEXT;
    DECLARE product_price DECIMAL(10,2);
    DECLARE product_old_price DECIMAL(10,2);
    DECLARE product_category_id INT;
    DECLARE product_brand_id INT;
    DECLARE product_provisioner_id INT;
    DECLARE product_quantity INT;
    DECLARE product_created DATE;
    
    -- Проверяем, является ли JSON массивом
    IF JSON_TYPE(json_data) = 'ARRAY' THEN
        SET products_count = JSON_LENGTH(json_data);
        
        WHILE i < products_count DO
            -- Извлекаем данные из JSON
            SET product_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, CONCAT('$[', i, '].name')));
            SET product_description = JSON_UNQUOTE(JSON_EXTRACT(json_data, CONCAT('$[', i, '].description')));
            SET product_price = JSON_EXTRACT(json_data, CONCAT('$[', i, '].price'));
            SET product_old_price = JSON_EXTRACT(json_data, CONCAT('$[', i, '].old_price'));
            SET product_category_id = JSON_EXTRACT(json_data, CONCAT('$[', i, '].category_id'));
            SET product_brand_id = JSON_EXTRACT(json_data, CONCAT('$[', i, '].brand_id'));
            SET product_provisioner_id = JSON_EXTRACT(json_data, CONCAT('$[', i, '].provisioner_id'));
            SET product_quantity = JSON_EXTRACT(json_data, CONCAT('$[', i, '].quantity'));
            SET product_created = JSON_UNQUOTE(JSON_EXTRACT(json_data, CONCAT('$[', i, '].created')));
            
            -- Вставляем данные в таблицу
            INSERT INTO products (name, description, price, old_price, category_id, brand_id, provisioner_id, quantity, created)
            VALUES (product_name, product_description, product_price, product_old_price, 
                    product_category_id, product_brand_id, product_provisioner_id, 
                    product_quantity, product_created);
            
            SET i = i + 1;
        END WHILE;
    ELSE
        -- Если передан не массив, а один объект
        SET product_name = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.name'));
        SET product_description = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.description'));
        SET product_price = JSON_EXTRACT(json_data, '$.price');
        SET product_old_price = JSON_EXTRACT(json_data, '$.old_price');
        SET product_category_id = JSON_EXTRACT(json_data, '$.category_id');
        SET product_brand_id = JSON_EXTRACT(json_data, '$.brand_id');
        SET product_provisioner_id = JSON_EXTRACT(json_data, '$.provisioner_id');
        SET product_quantity = JSON_EXTRACT(json_data, '$.quantity');
        SET product_created = JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.created'));
        
        INSERT INTO products (name, description, price, old_price, category_id, brand_id, provisioner_id, quantity, created)
        VALUES (product_name, product_description, product_price, product_old_price, 
                product_category_id, product_brand_id, product_provisioner_id, 
                product_quantity, product_created);
    END IF;
END //

DELIMITER ;