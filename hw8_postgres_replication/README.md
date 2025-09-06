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
**Настройка физической репликации:**    

Настройка на Master:   
1. Под аккаунтом postgres необходимо создать пользователя для репликации:  
``sudo -i -u postgres psql online_shop``        
``createuser --replication -P shop_repl;``    

2. Настройки в файле postgresql.conf    
Определить расположение файла конфигурации:
``psql -c 'show config_file;'``    
``mcedit /etc/postgresql/16/main/postgresql.conf``    
Добавить настройки:    
```
archive_mode = on                 
archive_command = 'cp %p /data/pg_data/archive/%f'   
max_wal_senders = 10              
wal_keep_segments = 50            
wal_level = replica                       
wal_log_hints = on
```

4. Настройки в файле pg_hba.conf    
``mcedit /etc/postgresql/16/main/pg_hba.conf``    
Добавить настройки:    
``host replication shop_repl 192.168.222.136/32 scrum-sha-265``    

5. Перезапустить postgres    
``systemctl restart postgres``      

Настройки на Slave:    
-------------------    
1. Настройки в файле postgresql.conf    
``listen_addresses = 'localhost, 192.168.1.136'``    

2. Остановить postgres:  
``systemctl stop postgresql``    

3. Удалить данные из каталога main:    
``su postgres``  
``rm -rf /var/lib/postgresql/16/main/*``    

4. Выполнить репликацию:      
``sudo -u postgres pg_basebackup -P -R -X stream -c fast -h 10.10.1.91 -U shop_repl -p 5432 -D /var/lib/postgresql/16/main -v``  
Примечание:  
Если есть табличное пространство будет ошибка:  could not create directory "/var/lib/postgresql/16/main/online_shop": File exists  
Решение: --tablespace-mapping    

6. Запустить сервис postgresql на подчинённом сервере:    
``systemctl start postgresql``

Результат выполнения комманды на мастере:  
``psql -x -c "SELECT * FROM pg_stat_replication;"``  

![stat_replication](https://github.com/thornix/otus_dba/blob/main/hw8_postgres_replication/stat_replication.jpg)

Результат выполнения комманды на мастере:  
``psql -x -c "SELECT * FROM pg_replication_slots;"``  

![slot_stanbay](https://github.com/thornix/otus_dba/blob/main/hw8_postgres_replication/slot_standby.png) 

**Ссылки:**    
https://timeweb.cloud/tutorials/postgresql/kak-nastroit-fizicheskuyu-potokovuyu-replikatsiyu-s-postgresql-12-na-ubuntu-2004  
https://habr.com/ru/companies/otus/articles/710956/  
https://serhatcelik.wordpress.com/category/postgresql/  







