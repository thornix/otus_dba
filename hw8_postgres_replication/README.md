## *Домашнее задание*  
Делаем физическую и логическую репликации  

**Цель:**  
* Настраивать физическую и логическую репликации.


**Описание/Пошаговая инструкция выполнения домашнего задания:**  

**Физическая репликация:**  
**Весь стенд собирается в Docker образах или ВМ. Необходимо:**    

* Настроить физическую репликации между двумя кластерами базы данных  
* Репликация должна работать используя "слот репликации"  
* Реплика должна отставать от мастера на 5 минут  

**Логическая репликация:**  
**В стенд добавить еще один кластер Postgresql. Необходимо:**    

* Создать на первом кластере базу данных, таблицу и наполнить ее данными (на ваше усмотрение)  
* На нем же создать публикацию этой таблицы  
* На новом кластере подписаться на эту публикацию  
* Убедиться что она среплицировалась. Добавить записи в эту таблицу на основном сервере и убедиться, что они видны на логической реплике    

Версия PostgreSQL на ваше усмотрение


**Критерии оценки:**  
* Выполнение ДЗ: 10 баллов  
* плюс 2 балла за красивое решение  
* минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены  

**Решение:**  
Настроить физическую потоковую репликацию с PostgreSQL:

**Изменения на Master:**  
1. Добавить настройки в файл конфигурации:  
mcedit /etc/postgresql/16/main/postgresql.conf

```
listen_addresses = 'primary_IP'
archive_mode = on                 
archive_command = 'cp %p /data/pg_data/archive/%f'
wal_level = replica 
max_wal_senders = 2
wal_log_hints = on
max_replication_slots = 2
logging_collector = on
```  

2. Создание пользователя для репликации:  
```psql -x -c "CREATE ROLE relication_user WITH REPLICATION PASSWORD 'password' LOGIN;"```  

3. Добавить доступ для slave:  
``echo "host  replication   relication_user  replica-IP/32  md5" >> /etc/postgresql/16/main/pg_hba.conf``

4. Создать слот репликации:    
``psql -x -c "SELECT pg_create_physical_replication_slot('standby_slot');"``

5. Перезапуск кластера:     
``systemctl restart postgresql@16-main``  

 
***Изменения на Slave:***  

1. Очистить каталог данных реплики от всех файлов:  
``sudo -u postgres rm -r /var/lib/postgresql/16/main/*``   

2. Скопироть данные с мастера:  
``sudo -u postgres pg_basebackup -P -R -X stream -c fast -h primary_IP -U relication_user -p 5432 -D /var/lib/postgresql/16/main -v``

3. Перезапустить postgres:
``systemctl restart postgresql@16-main``

Результат запроса:  
``psql -x -c "SELECT * FROM pg_stat_replication;"``  

![stat_replication](https://github.com/thornix/otus_dba/blob/main/hw8_postgres_replication/stat_replication.jpg)

Результат запроса:  
``psql -x -c "SELECT * FROM pg_replication_slots;"``  

![slot_stanbay](https://github.com/thornix/otus_dba/blob/main/hw8_postgres_replication/slot_standby.png) 

Результат запроса:  
``psql -x -c "select * from pg_stat_wal_receiver;"``

![slot_stanbay](https://github.com/thornix/otus_dba/blob/main/hw8_postgres_replication/standbay_status.png) 

Команды для просмотра:  
``select * from pg_stat_replication;``  
``psql -x -c "select * from pg_replication_slots;"`` 
``psql -x -c "select * from pg_stat_wal_receiver;"``  
``show checkpoint_segments;``  
``show wal_keep_segments;``  

**Ссылки:**    
https://timeweb.cloud/tutorials/postgresql/kak-nastroit-fizicheskuyu-potokovuyu-replikatsiyu-s-postgresql-12-na-ubuntu-2004  
https://habr.com/ru/companies/otus/articles/710956/  
https://serhatcelik.wordpress.com/category/postgresql/ 

**Примечания:**  
Для включения непрерывной архивации (archive_mode) и потоковой двоичной репликации необходимо использовать уровень не ниже replica
Когда параметр archive_mode включён, полные сегменты WAL передаются в хранилище архива командой archive_command 
Чтобы запустить сервер в режиме ведомого, создайте в каталоге данных файл standby.signal
wal_log_hints = on Когда этот параметр имеет значение on, сервер PostgreSQL записывает в WAL всё содержимое каждой страницы при первом изменении этой страницы после контрольной точки, даже при второстепенных изменениях так называемых вспомогательных битов.
Слот репликации в PostgreSQL — это объект, который гарантирует, что сервер-источник сохранит все необходимые WAL-файлы (журнал упреждающей записи) до тех пор, пока их не получит и не обработает потребитель репликации.
Важно удалять неиспользуемые слоты, чтобы предотвратить накопление лишних WAL-файлов и избежать исчерпания места на диске. Существуют два основных типа: физические слоты для потоковой репликации и логические слоты для логической репликации 























