**Домашнее задание**  
Анализ и профилирование запроса  

Цель:  
Проанализировать план выполнения запроса, оценить, на чем теряется время.  


Описание/Пошаговая инструкция выполнения домашнего задания:  
возьмите сложную выборку из предыдущих ДЗ с несколькими join и подзапросами  

постройте EXPLAIN в 3 формата  

оцените план прохождения запроса, найдите самые тяжелые места  

Задание со *:  
оптимизировать запрос (можно использовать индексы, хинты, сбор статистики, гистограммы)  

все действия и результаты опишите в README.md  

Критерии оценки:  
Выполнение ДЗ: 10 баллов  
плюс 5 баллов за задание со *  
плюс 2 балла за красивое решение  
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

Решение:  
Постройте EXPLAIN в 3 формата:  
Для анализа взят запрос:  
```
SELECT count(os.order_id),b.name FROM orders os join order_items oi 
on os.order_id = oi.order_id join products ps on ps.product_id = 
oi.order_id join categories c on ps.category_id = c.category_id 
join brands b on b.brand_id = ps.brand_id where os.created_at < 
(SUBTIME(NOW(), '168:00:00')) group by b.name;
```
EXPLAIN:  
![EXPLAIN](https://github.com/thornix/otus_dba/blob/main/hw17_performance_optimization_profiling_monitoring_in_mysql/EXPLAIN.png)

EXPLAIN format=JSON:  
![EXPLAIN_JSON](https://github.com/thornix/otus_dba/blob/main/hw17_performance_optimization_profiling_monitoring_in_mysql/EXPLAIN_json.png)

EXPLAIN format=TREE:  
![EXPLAIN_TREE](https://github.com/thornix/otus_dba/blob/main/hw17_performance_optimization_profiling_monitoring_in_mysql/EXPLAIN_tree1.jpg)
