## *Домашнее задание*  
Делаем физическую и логическую репликации  

**Цель:**  
* Настраивать физическую и логическую репликации.


**Описание/Пошаговая инструкция выполнения домашнего задания:**  

**Физическая репликация:**  
**Весь стенд собирается в Docker образах или ВМ. Необходимо:**    

* Настроить физическую репликации между двумя кластерами базы данных  
* Репликация должна работать использую "слот репликации"  
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
Логическая репликация на примере БД - otus:
-------------------------------------------
1. Необходимо в файле postgresql.conf сменить значение параметра wal_level:
wal_level = logical

2. В файле pg_hba.conf на мастере добавляем строку с IP адресом подчиненного сервера:
host otus postgres 192.168.222.136/32 trust

3. Делаем дамп всей БД и дамп схемы базы otus:
pg_dumpall --database=otus --host=192.168.222.136 --no-password --globals-only --no-privileges | psql
pg_dump --dbname otus --host=192.168.222.136 --no-password --create --schema-only | psql

4. Cоздать публикацию на стороне сервера мастер:
CREATE PUBLICATION db_pub FOR ALL TABLES;

5. Добавляем подписку на стороне подчиненного сервера:
CREATE SUBSCRIPTION db_sub CONNECTION 'host=192.168.222.136 dbname=otus' PUBLICATION db_sub;

**Настройка физической репликации:**  
apt install postgresql postgresql-contrib  

Настройки MAster:  
-----------------  
1. Под аккаунтом postgres необходимо создать пользователя для репликации:  
sudo -i -u postgres  
psql  
createuser --replication -P rep_user  

2. Настройки в файл postgresql.conf  
Где файл конфигурации: psql -c 'show config_file;'  
mcedit /etc/postgresql/14/main/postgresql.conf  
Добавить настройки:  
archive_mode = on                 
archive_command = 'cp %p /oracle/pg_data/archive/%f'   
max_wal_senders = 10              
wal_keep_segments = 50            
wal_level = replica                       
wal_log_hints = on  

3. Настройки в файл pg_hba.conf  
mcedit /etc/postgresql/14/main/pg_hba.conf  
Добавить настройки:  
host replication rep_user 192.168.222.136/32 scrum-sha-265  

4. Перезапустить postgres  
systemctl restart postgres  

Настройки на Slave:  
-------------------  
1. Настройки в файл postgresql.conf  
listen_addresses = 'localhost, 192.168.1.136'  

2.systemctl stop postgresql  

3. Удалить данные из каталога main  
su postgres  
rm -rf /var/lib/postgresql/14/main/*  

4. Проверка работы репликации:  
su postgres  
pg_basebackup -R -h 192.168.222.142 -U rep_user -D /var/lib/postgresql/14/main -P  

5. Запустить сервис postgresql на подчинённом сервере:  
systemctl start postgresql

