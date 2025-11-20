**Домашнее задание**  
Восстановить таблицу из бэкапа  

Цель:  
использовать инструмент для резервного копирования и восстановления - xtrabackup;  
восстановить конкретную таблицу из сжатого и шифрованного бэкапа;  

Описание/Пошаговая инструкция выполнения домашнего задания:  
В материалах приложен файл бэкапа backup.xbs.gz.aes и дамп структуры базы world.dump.sql  
Бэкап выполнен с помощью команды:  

sudo xtrabackup --user=root --password="password"  
--backup --stream=xbstream  
--target-dir=/tmp/backup  
| gzip - | openssl aes-256-cbc -salt -pbkdf2 -k "password"  
> backup.xbs.gz.aes  

Требуется восстановить таблицу world.city из бэкапа и выполнить оператор:  

select 'city' as t_name, count() as cnt from city  
union all select 'city (RUS)', count() from city where countrycode = 'RUS'  
union all select 'country', count() from country  
union all select 'countrylanguage', count() from countrylanguage;  

Результат оператора написать в чат с преподавателем.  

Критерии оценки:  
9 баллов - задание выполнено, но есть недочеты  
10 баллов - задание выполнено в полном объеме  

Решение:  
![select_result](https://github.com/thornix/otus_dba/blob/main/hw18_mysql_backup_and_restore/select_result.png)
