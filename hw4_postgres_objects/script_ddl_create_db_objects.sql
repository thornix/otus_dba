-- Создаём базу данных:
CREATE DATABASE shopdb;

-- Создаём администратора для БД shopdb:
CREATE USER shopdb_adm WITH PASSWORD '1111' CREATEROLE;

-- Назначаем права:
ALTER DATABASE shopdb OWNER TO shopdb_adm;
GRANT ALL PRIVILEGES ON DATABASE shopdb TO shopdb_adm;

-- Подключение к shopdb от пользователя shopdb_adm:
psql -U shopdb_adm -p 5432 -h localhost shopdb

----Создаём схему:
CREATE SCHEMA online_shop;

-- Создаём роли:
CREATE ROLE "read_only_role_shopdb";
CREATE ROLE "read_write_role_shopdb";

-- Назначаем права на схему для ролей:
GRANT SELECT ON ALL TABLES IN SCHEMA online_shop TO read_only_role_shopdb;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA online_shop TO read_write_role_shopdb;

-- Создаём пользоваталей:
CREATE USER svc_backend WITH PASSWORD '2222';
CREATE USER svc_reports WITH PASSWORD '3333';

-- Назначаем роли:
GRANT read_write_role_shopdb TO svc_backend;
GRANT read_only_role_shopdb TO svc_reports;

----Создаём таблицы:







