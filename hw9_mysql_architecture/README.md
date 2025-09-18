**Домашнее задание**  
Создаем базу данных MySQL в докере  

**Цель:**  
Упаковать скрипы создания БД в контейнер.  


Описание/Пошаговая инструкция выполнения домашнего задания:  
забрать стартовый репозиторий https://github.com/aeuge/otus-mysql-docker  
прописать sql скрипт для создания своей БД в init.sql  
проверить запуск и работу контейнера следуя описанию в репозитории  

**Задания повышенной сложности***    

прописать кастомный конфиг - настроить innodb_buffer_pool и другие параметры по желанию  
протестить сисбенчем - результат теста приложить в README  

**Возможные проблемы:**  

не подключается к БД - https://stackoverflow.com/questions/19101243/error-1130-hy000-host-is-not-allowed-to-connect-to-this-mysql-server  

на m1 не запускается - https://stackoverflow.com/questions/65456814/docker-apple-silicon-m1-preview-mysql-no-matching-
manifest-for-linux-arm64-v8  

**Критерии оценки:**    
10 - контейнер с базой запускается, база создается  
плюс 2 балла - также реализован кастомный конфиг  
плюс 3 балла - приложены результаты сисбенча 


**Решение:** 

Создание тестовых данных:  
``sysbench --db-driver=mysql --mysql-user=root --mysql-password=12345 --mysql-host=10.10.1.52 --mysql-port=3309 --mysql-db=online_store --range_size=100 --table_size=1000000 --tables=2 --threads=1 --events=0 --time=60 --rand-type=uniform /usr/share/sysbench/oltp_read_only.lua prepare``  

Тестирование:  
``sysbench --db-driver=mysql --mysql-user=root --mysql-password=12345 --mysql-host=10.10.1.52 --mysql-port=3309 --mysql-db=online_store --range_size=100 --table_size=1000000 --tables=2 --threads=8 --events=0 --time=60 --rand-type=uniform /usr/share/sysbench/oltp_read_only.lua run``  

Результат тестирования до применения настроек оптимизации СУБД:  
![before](https://github.com/thornix/otus_dba/blob/main/hw9_mysql_architecture/before_tuning.png)  


Результат тестирования после применения настроек оптимизации СУБД(Latency уменьшилось): 
![after](https://github.com/thornix/otus_dba/blob/main/hw9_mysql_architecture/After_tuning.jpg)   


Файл конфигурации:  
![settings](https://github.com/thornix/otus_dba/blob/main/hw9_mysql_architecture/my_settings.png)  


Проект запущен в docker compose, база создана через скрипт:  
![project_run](https://github.com/thornix/otus_dba/blob/main/hw9_mysql_architecture/project_run.jpg)




