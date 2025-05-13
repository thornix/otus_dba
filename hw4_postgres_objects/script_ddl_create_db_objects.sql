-- Создание табличного пространства:
\! mkdir /var/lib/postgresql/14/main/shopdb
\! chown postgres:postgres /var/lib/postgresql/14/main/shopdb
create TABLESPACE shopdb LOCATION '/var/lib/postgresql/14/main/shopdb';

-- Создание базы данных:
create DATABASE shopdb TABLESPACE shopdb;

-- Подключение к БД:
\с shopdb;

-- Создание ролей:
create role "read_only_role_shopdb_shopdb";
create role "read_write_role_shopdb_shopdb";

-- Создание схемы:
create schema if not exists shopdb;
set search_path to shopdb;

-- Назначение прав на схему:
GRANT select ON ALL TABLES IN SCHEMA shopdb TO read_only_role_shopdb_shopdb;
GRANT select,insert,update,delete ON ALL TABLES IN SCHEMA shopdb TO read_only_role_shopdb_shopdb;

-- Создание пользоваталей:
create user svc_backend_shopdb with PASSWORD '2222';
create user svc_reports_shopdb with PASSWORD '3333';

-- Назначение ролей:
GRANT read_write_role_shopdb TO svc_backend_shopdb;
GRANT read_only_role_shopdb TO svc_reports_shopdb;

----Создание таблиц:
create table "products"(
    "id" bigint not null,
    "name" char(255) null,
    "category_id" bigint not null,
    "supplier_id" bigint not null,
    "manufacturer_id" bigint not null,
    "price_id" bigint not null
)  tablespace shopdb;








