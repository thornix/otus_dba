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

<u> Решение: </u>
1) Для таблицы - ORDERS возможна кардинальность полей - customer_id, product_id, date:  
Поля - customer_id, product_id используются для выгрузок вида:  
*select * from orders where customer_id = 1 or product_id = 1 and date between to_date('29042025','DDMMYYYY') and to_date('29042025','DDMMYYYY');*  
Создание индексов:     
*CREATE INDEX "orders_customer_id_index" ON "orders"("customer_id");*  
*CREATE INDEX "orders_product_id_index" ON "orders"("product_id");*    
*CREATE INDEX "orders_date_index" ON "orders"("date");*  

3) Для таблицы - CUSTOMERS возможна кардинальность полей - FirstName, LastName, Phone, Email:   
*CREATE INDEX "customers_firstname_lastname_index" ON "customers"("FirstName", "LastName");*  
*CREATE INDEX "customers_email_index" ON "customers"("Email");*  
*CREATE INDEX "customers_phone_index" ON "customers"("Phone");*  

4) Для таблицы - PRODUCTS возможна кардинальность полей - name, supplier_id, manufacturer_id, price_id, category_id:  
*CREATE INDEX "products_name_index" ON "products"("name");*    
*CREATE INDEX "products_category_id_index" ON "products"("category_id");*    
*CREATE INDEX "products_supplier_id_index" ON "products"("supplier_id");*    
*CREATE INDEX "products_price_id_index" ON "products"("price_id");*  

5) Для таблицы - MANUFACTURER возможна кардинальность полей - name, phone, email:  
*CREATE INDEX "manufacturer_name_index" ON "manufacturer"("name");*   
*CREATE INDEX "manufacturer_phone_index" ON "manufacturer"("phone");*  
*CREATE INDEX "manufacturer_email_index" ON "manufacturer"("email");*

6) Для таблицы - PRICES возможна кардинальность поля - price:  
*CREATE INDEX "prices_price_index" ON "prices"("price");*

7) Для таблицы - CATEGORY возможна кардинальность поля - name:   
*CREATE INDEX "category_name_index" ON "category"("name");*
  



