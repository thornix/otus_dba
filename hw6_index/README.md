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

* Создать индекс к какой-либо из таблиц вашей БД  
* Прислать текстом результат команды explain,
в которой используется данный индекс  
* Реализовать индекс для полнотекстового поиска   
* Реализовать индекс на часть таблицы или индекс
на поле с функцией  
* Создать индекс на несколько полей  
* Написать комментарии к каждому из индексов  
* Описать что и как делали и с какими проблемами
столкнулись  

**<u>Критерии оценки:</n>**  

* Выполнение ДЗ: 10 баллов  
* плюс 2 балла за красивое решение    
* минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**<u>Решение:</u>**  

1. Создание индекса:  
    ``CREATE INDEX "orders_sum_index" ON "orders"("sum");``


2. Вывод explain до создания индекса для запроса: explain select count(*) from orders where sum = 1800:  
``Aggregate  (cost=17935.15..17935.16 rows=1 width=8)
->  Seq Scan on orders  (cost=0.00..17651.36 rows=113516 width=0)
Filter: (sum = 1800)``  


3. Вывод explain после создания индекса для запроса: explain select count(*) from orders where sum = 1800:  
   ``Finalize Aggregate  (cost=6086.76..6086.77 rows=1 width=8)
   ->  Gather  (cost=6086.54..6086.75 rows=2 width=8)
   Workers Planned: 2
   ->  Partial Aggregate  (cost=5086.54..5086.55 rows=1 width=8)
   ->  Parallel Index Only Scan using orders_sum_index on orders  (cost=0.29..4841.55 rows=97996 width=0)
   Index Cond: (sum = 1800)``