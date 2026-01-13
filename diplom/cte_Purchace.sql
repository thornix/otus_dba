USE online_store_db2;

DELIMITER //

CREATE PROCEDURE purchase(IN p_user_id BIGINT,IN p_shipping_address_id BIGINT,OUT p_order_id BIGINT,OUT p_order_number VARCHAR(50))
BEGIN
DECLARE v_cart_id BIGINT;
DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;
DECLARE v_product_id BIGINT;
DECLARE v_quantity INT;
DECLARE v_price DECIMAL(10,2);
DECLARE v_item_total DECIMAL(10,2);
DECLARE v_finished INTEGER DEFAULT 0;
-- Курсор для товаров в корзине пользователя
 DECLARE cart_items_cursor CURSOR FOR
     SELECT ci.product_id, ci.quantity, p.price
     FROM cart_items ci
     JOIN products p ON ci.product_id = p.id
     WHERE ci.cart_id = v_cart_id;

 -- Обработчик для завершения цикла
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

 -- Начало транзакции
 START TRANSACTION;

 -- Проверяем, что адрес доставки принадлежит пользователю
 IF NOT EXISTS (SELECT 1 FROM addresses WHERE id = p_shipping_address_id AND user_id = p_user_id) THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipping address does not belong to the user';
 END IF;

 -- Получаем корзину пользователя
 SELECT id INTO v_cart_id FROM carts WHERE user_id = p_user_id LIMIT 1;

 -- Если корзина не найдена, то ошибка
 IF v_cart_id IS NULL THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cart not found';
 END IF;

 -- Проверяем, что корзина не пуста
 IF NOT EXISTS (SELECT 1 FROM cart_items WHERE cart_id = v_cart_id) THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cart is empty';
 END IF;

 -- Проверяем наличие товаров и их количество
 OPEN cart_items_cursor;

 check_loop: LOOP
     FETCH cart_items_cursor INTO v_product_id, v_quantity, v_price;
     IF v_finished = 1 THEN
         LEAVE check_loop;
     END IF;

     -- Проверяем, что товара достаточно на складе
     IF (SELECT quantity FROM products WHERE id = v_product_id) < v_quantity THEN
         CLOSE cart_items_cursor;
         ROLLBACK;
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity for product';
     END IF;
 END LOOP;

 CLOSE cart_items_cursor;

 -- Сбрасываем флаг для повторного использования курсора
 SET v_finished = 0;

 -- Генерируем номер заказа
 SET p_order_number = CONCAT('ORD', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), LPAD(p_user_id, 6, '0'));

 -- Рассчитываем общую сумму заказа
 SELECT SUM(ci.quantity * p.price) INTO v_total_amount
 FROM cart_items ci
 JOIN products p ON ci.product_id = p.id
 WHERE ci.cart_id = v_cart_id;

 -- Создаем заказ
 INSERT INTO orders (user_id, order_number, total_amount, shipping_address_id)
 VALUES (p_user_id, p_order_number, v_total_amount, p_shipping_address_id);

 SET p_order_id = LAST_INSERT_ID();

 -- Вставляем элементы заказа и уменьшаем количество товаров на складе
 OPEN cart_items_cursor;

 insert_loop: LOOP
     FETCH cart_items_cursor INTO v_product_id, v_quantity, v_price;
     IF v_finished = 1 THEN
         LEAVE insert_loop;
     END IF;

     SET v_item_total = v_quantity * v_price;

     -- Вставляем элемент заказа
     INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
     VALUES (p_order_id, v_product_id, v_quantity, v_price, v_item_total);

     -- Уменьшаем количество товара на складе
     UPDATE products
     SET quantity = quantity - v_quantity
     WHERE id = v_product_id;

 END LOOP;

 CLOSE cart_items_cursor;

 -- Очищаем корзину (удаляем все элементы корзины для данного cart_id)
 DELETE FROM cart_items WHERE cart_id = v_cart_id;

 COMMIT;
 END //

DELIMITER ;