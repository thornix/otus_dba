**Домашнее задание**  
Настроить репликацию MySQL  

Цель:  
Научиться настраивать репликацию MySQL Source - Replica и отслеживать ее состояние  

Описание/Пошаговая инструкция выполнения домашнего задания:  
Необходимо запустить репликацию двух серверов MySQL по топологии Source-Replica (Master-Slave), также можно использовать MariaDB или Percona Server for MySQL.  

Запустить и показать работу асинхронной репликации на основе GTID.  
Загрузить данные на Master-сервер.  
Replica (Slave) должен быть в режиме read-only.  

Задание со звездочкой* Запустить реплику сразу с начальным данными (БД).  
Задание со звездочкой* Настроить выборочную репликацию — исключить несколько БД или таблиц.  

Критерии оценки:  
Для получения статуса “Принято” (10 баллов) достаточно выполнения пунктов 1-3 с документацией по статусам Master и Slave, а также приведения конфигурации и команд по настройке в git-репозитории.  
При выполнении дополнительных заданий (4-5), дополнительно 2 балла за каждый пункт.  

Решение:  

Source configuration:   
1. my.cnf  
```
[mysqld]
user                    = mysql
pid-file                = /var/run/mysqld/mysqld.pid
socket                  = /var/run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
language                = /usr/share/mysql/english
bind-address            = 0.0.0.0

server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
relay_log = /var/log/mysql/relay-bin.log
read_only = OFF
gtid_mode = on
```
2.
```
CREATE USER 'replication_user'@'10.10.1.87' IDENTIFIED WITH mysql_native_password BY 'password';  
GRANT REPLICATION SLAVE ON *. * TO 'replication_user'@'10.10.1.87';
```   
```
SET GLOBAL read_only = 1;
```
4
```
SHOW MASTER STATUS;  
+------------------+----------+--------------+------------------+----------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                      |
+------------------+----------+--------------+------------------+----------------------------------------+
| mysql-bin.000011 |      312 |              |                  | 16aa198f-c723-11f0-9420-000c2921d56d:1 |
+------------------+----------+--------------+------------------+----------------------------------------+
```
Replica configuration: 

1. my.cnf:  
```
[mysqld]
user                    = mysql
pid-file                = /var/run/mysqld/mysqld.pid
socket                  = /var/run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
language                = /usr/share/mysql/english
bind-address            = 0.0.0.0

server-id = 2
relay-log = /var/log/mysql/relay.log
log-bin = /var/lib/mysql/bin.log
read-only = on
gtid-mode = on
enforce-gtid-consistency
log-replica-updates
```
2.
```
CREATE DATABASE online_store_db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
```
3.
```
mysql -u root -p online_store_db < online_store_db.sql
```
4.
```
SHOW MASTER STATUS;  
mysql-bin.000011 |      312 |              |                  | 16aa198f-c723-11f0-9420-000c2921d56d:1
```
5.
```
CHANGE MASTER TO MASTER_HOST = '10.10.1.91', MASTER_USER = 'replication_user', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000011', MASTER_LOG_POS = 312;
```
6.
```
START REPLICA;
```
7.
```
SHOW REPLICA STATUS\G;
```
8. Выполнить на мастере:
```
SET GLOBAL read_only = 0;
```  

Help: 
```
show variables like "%gtid%";
```



   
