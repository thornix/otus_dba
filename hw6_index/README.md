## *Домашнее задание*  
Индексы PostgreSQL

**<u>Цель:</u>**  
* Знать и уметь применять основные виды индексов PostgreSQL;  
* Построить и анализировать план выполнения запроса;  
* Оптимизировать запросы для с использованием индексов.  


**<u>Описание/Пошаговая инструкция выполнения домашнего задания:</u>**  
* Создать индексы на БД, которые ускорят доступ к данным.  

**<u>В данном задании тренируются навыки:</u>**  

* определения узких мест  
* написания запросов для создания индекса  
* оптимизации  

**<u>Необходимо:</u>**  

1. Создать индекс к какой-либо из таблиц вашей БД    
2. Прислать текстом результат команды explain, в которой используется данный индекс      
3. Реализовать индекс для полнотекстового поиска     
4. Реализовать индекс на часть таблицы или индекс на поле с функцией  
5. Создать индекс на несколько полей  
6. Написать комментарии к каждому из индексов    
7. Описать что и как делали и с какими проблемами столкнулись    

**<u>Критерии оценки:</n>**  

* Выполнение ДЗ: 10 баллов  
* плюс 2 балла за красивое решение    
* минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**<u>Решение:</u>**  

1. Создать индекс к какой-либо из таблиц вашей БД:   
``create index "orders_sum_index" ON "orders"("sum");``

2. Вывод explain после создания индекса для запроса:  
``explain (analyze) select * from orders where sum = 7500:``    
Вывод:    
   ``Index Scan using idx_orders_sum on orders  (cost=0.43..145115.82 rows=4966422 width=36) (actual time=3.511..3441.949 rows=5000000 loops=1)
  Index Cond: (sum = 7500)
Planning Time: 6.994 ms
JIT:
  Functions: 2
  Options: Inlining false, Optimization false, Expressions true, Deforming true
  Timing: Generation 5.732 ms, Inlining 0.000 ms, Optimization 0.000 ms, Emission 0.000 ms, Total 5.732 ms
Execution Time: 3735.060 ms``


3. Реализовать индекс для полнотекстового поиска:    
``create extension pg_trgm;``  
``create index gin_idx_products ON products USING gin (name gin_trgm_ops);``  
``explain (analyze) select * from category where name like '%73861a5e'``    
Вывод:  
``Bitmap Heap Scan on category  (cost=164.78..534.99 rows=100 width=41) (actual time=1.719..1.720 rows=1 loops=1)
  Recheck Cond: ((name)::text ~~ '%73861a5e'::text)
  Heap Blocks: exact=1
  ->  Bitmap Index Scan on category_gin_idx  (cost=0.00..164.75 rows=100 width=0) (actual time=1.327..1.328 rows=1 loops=1)
        Index Cond: ((name)::text ~~ '%73861a5e'::text)
Planning Time: 0.990 ms
Execution Time: 1.774 ms``  


4. Реализовать индекс на часть таблицы или индекс на поле с функцией:    
``create index idx_orders_id_100 on orders(id) where id < 100;``  


5. Создать индекс на несколько полей:  
``create index idx_orders_date_sum ON orders (date, sum);``


6. Написать комментарии к каждому из индексов:  
``COMMENT ON INDEX idx_orders_date_sum IS 'Этот индекс ускоряет поиск по date и sum';``


7. Описать что и как делали и с какими проблемами столкнулись:  

Задания выполнялись в Dbeaver на тестовой БД интернет магазина. Сложности были в понимаеии GIN индексов, а также в создании индекса на часть таблицы т.к требуются не изменяемые данные. Т.е так не получитсья сделать - create index idx_orders_date on orders(date) where date > to_date('2025-01-01', 'YYYY-MM-DD');
выходит ошибка - functions in index predicate must be marked IMMUTABLE
