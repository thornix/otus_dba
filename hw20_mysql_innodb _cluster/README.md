Домашнее задание  
Развернуть кластер MySQL  

Цель:  
Научиться разворачивать кластер MySQL отслеживать его состояние;  

Описание/Пошаговая инструкция выполнения домашнего задания:  
Необходимо развернуть кластер Percona XtraDB Cluster (PXC) или InnoDB Cluster.  

развернуть кластер из трех серверов (нод, узлов) и продемонстрировать его работу (предоставить статус кластера на каждой ноде)  
загрузить данные и продемонстрировать содержимое БД (show tables и count одной из таблииц на каждой ноде)  

Задание со звездочкой *  
Продемонстрировать работу кластера в режиме отказа одной из нод, при этом кластер должен продолжать работать и выполнять запросы.  
Можно воспользоваться инструментами для проксирования запросов к кластеру (например, ProxySQL или MySQL Router) и инструментом нагрузочного тестирования (например, sysbench).  

Критерии оценки:  
Для получения статуса “Принято” (10 баллов) достаточно выполнения пунктов 1-2 с документацией в git-репозитории конфигурации и команд по настройке кластера, а также снимки экранов со статусом кластера и содержимым БД на каждой ноде.  
При выполнении дополнительного задания (*) - дополнительно 4 балла.  

Решение:  
Конфигурация InnoDB Cluster на Ubuntu 24.04.3 LTS + 8.0.44-0ubuntu0.24.04.1:  
1. Конфигурация сети на всех нодах:
```
1.1 Добавить конфинг для netplan(все остальные конфиги можно удалить):  
cat << EOF >> /etc/netplan/00-static.yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 10.10.1.11/24
      routes:
        - to: default
          via: 10.10.1.1
          metric: 100
      nameservers:
          addresses: [10.10.1.1, 8.8.8.8]
EOF
1.2 Установить права и проверить конфиг:
chmod 600 /etc/netplan/00-static.yaml && netplan generate
1.3 Применить конфиг:
netplan apply
1.4 Добавить адреса в hosts:
cat << EOF >> /etc/hosts
10.10.1.11   ic-1
10.10.1.12   ic-2
10.10.1.13   ic-3
EOF
```

2. Установить софт:
```
apt update -y && apt install mysql-server -y && apt install mysql-router -y && apt install mysql-client -y && apt install mysql-shell -y
```
3. Пользователь для кластера на всех нодах:
```
mysql
> create user 'root'@'%' identified by 'password';
> grant all privileges on *.* to 'root'@'%' with grant option;
> flush privileges;
> \q
```
4. Конфигурация my.cnf на IC-1:
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0
port            = 3301
symbolic-links=0
# Replication part
server_id=1
gtid_mode=ON
enforce_gtid_consistency=ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
binlog_checksum=NONE
log_slave_updates=ON
log_bin=binlog
binlog_format=ROW
# Group replication part
transaction_write_set_extraction=XXHASH64
loose-group_replication_group_name="inno-db-cluster-1"
loose-group_replication_start_on_boot=off
loose-group_replication_local_address= "10.10.1.11:33061"
loose-group_replication_group_seeds= "10.10.1.11:33061,10.10.1.12:33061,10.10.1.13:33061"
```
4.1 Конфигурация my.cnf на IC-2:
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0
port            = 3301
symbolic-links=0
# Replication part
server_id=2
gtid_mode=ON
enforce_gtid_consistency=ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
binlog_checksum=NONE
log_slave_updates=ON
log_bin=binlog
binlog_format=ROW
# Group replication part
transaction_write_set_extraction=XXHASH64
loose-group_replication_group_name="inno-db-cluster-1"
loose-group_replication_start_on_boot=off
loose-group_replication_local_address= "10.10.1.12:33061"
loose-group_replication_group_seeds= "10.10.1.11:33061,10.10.1.12:33061,10.10.1.13:33061"
```
4.2 Конфигурация my.cnf на IC-3:  
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
log-error       = /var/log/mysql/error.log
bind-address    = 0.0.0.0
port            = 3301
symbolic-links=0
# Replication part
server_id=3
gtid_mode=ON
enforce_gtid_consistency=ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
binlog_checksum=NONE
log_slave_updates=ON
log_bin=binlog
binlog_format=ROW
# Group replication part
transaction_write_set_extraction=XXHASH64
loose-group_replication_group_name="inno-db-cluster-1"
loose-group_replication_start_on_boot=off
loose-group_replication_local_address= "10.10.1.13:33061"
loose-group_replication_group_seeds= "10.10.1.11:33061,10.10.1.12:33061,10.10.1.13:33061"
```
5. Зайти на каждой ноде в mysqlsh и выполнить:
```
IC-1:
mysqlsh
shell.connect('root@ic-1:3301')
dba.configure_instance('ic-1:3301')
IC-2:
mysqlsh
shell.connect('root@ic-2:3301')
dba.configure_instance('ic-2:3301')
IC-3:
mysqlsh
shell.connect('root@ic-3:3301')
dba.configure_instance('ic-3:3301')
```
6. Создать кластер:
```
cl=dba.create_cluster('ic')
```
7. Делаем дамп и воостанавливаем на нодах:
```
mysqldump --all-databases  --triggers --routines --events > dump.sql
mysql < dump.sql
```
8. Добавляем ноды в кластер на IC-1:
```
musqlsh
cl.add_instance('root@ic-1:3301')
cl.add_instance('root@ic-2:3301')
cl.add_instance('root@ic-3:3301')
```
После восстановления БД online_store_db из дампа на IC-1, база автоматом появилась на IC-2, IC-3, последующие изменения также реплицируются.  
Результат:  



P.S:  
Возможно понадобиться выполнить mysqlsh --classic --dba enableXProtocol  


