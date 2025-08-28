-- Создание табличного пространства:
\! mkdir /var/lib/postgresql/14/main/online_shop
\! chown postgres:postgres /var/lib/postgresql/14/main/online_shop
create TABLESPACE online_shop LOCATION '/var/lib/postgresql/14/main/online_shop';

-- Создание базы данных:
create DATABASE online_shop TABLESPACE online_shop;

-- Подключение к БД:
\c shopdb

-- Создание ролей:
create role "read_only_role_online_shop";
create role "read_write_role_online_shop";

-- Создание схемы:
create schema if not exists online_shop;
ALTER DATABASE online_shop SET search_path TO online_shop;

-- Назначение прав на схему:
GRANT SELECT ON ALL TABLES IN SCHEMA online_shop TO read_only_role_online_shop;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA online_shop TO read_write_role_online_shop;

-- Создание пользоваталей:
create user svc_backend with PASSWORD '2222';
create user svc_reports with PASSWORD '3333';

-- Назначение ролей:
GRANT read_write_role_online_shop TO svc_backend;
GRANT read_only_role_online_shop TO svc_reports;

----Создание таблиц:
CREATE TABLE if not exists "online_shop.products"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NULL,
    "category_id" BIGINT NOT NULL,
    "supplier_id" BIGINT NOT NULL,
    "manufacturer_id" BIGINT NOT NULL,
    "price_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.products" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.suppliers"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL,
    "email" CHAR(255) NOT NULL,
    "protuct_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.suppliers" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.orders"(
    "id" BIGINT NOT NULL,
    "customer_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    "purcase_date" BIGINT NOT NULL,
    "purchase_amount" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.orders" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.category"(
    "id" BIGINT NOT NULL,
    "name" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.category" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.customers"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "email" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL,
    "order_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.customers" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.manufacturer"(
    "id" BIGINT NOT NULL,
    "namebigint" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL,
    "email" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.manufacturer" ADD PRIMARY KEY("id");
CREATE TABLE if not exists "online_shop.prices"(
    "id" BIGINT NOT NULL,
    "price" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL
) tablespace online_shop;
ALTER TABLE
    "online_shop.prices" ADD PRIMARY KEY("id");
ALTER TABLE
    "online_shop.products" ADD CONSTRAINT "products_manufacturer_id_foreign" FOREIGN KEY("manufacturer_id") REFERENCES "online_shop.manufacturer"("id");
ALTER TABLE
    "online_shop.customers" ADD CONSTRAINT "customers_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "online_shop.orders"("id");
ALTER TABLE
    "online_shop.manufacturer" ADD CONSTRAINT "manufacturer_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "online_shop.products"("id");
ALTER TABLE
    "online_shop.products" ADD CONSTRAINT "products_supplier_id_foreign" FOREIGN KEY("supplier_id") REFERENCES "online_shop.suppliers"("id");
ALTER TABLE
    "online_shop.suppliers" ADD CONSTRAINT "suppliers_protuct_id_foreign" FOREIGN KEY("protuct_id") REFERENCES "online_shop.products"("id");
ALTER TABLE
    "online_shop.category" ADD CONSTRAINT "category_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "online_shop.products"("id");
ALTER TABLE
    "online_shop.products" ADD CONSTRAINT "products_price_id_foreign" FOREIGN KEY("price_id") REFERENCES "online_shop.prices"("id");
ALTER TABLE
    "online_shop.products" ADD CONSTRAINT "products_category_id_foreign" FOREIGN KEY("category_id") REFERENCES "online_shop.category"("id");
ALTER TABLE
    "online_shop.prices" ADD CONSTRAINT "prices_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "online_shop.products"("id");
ALTER TABLE
    "online_shop.orders" ADD CONSTRAINT "orders_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "online_shop.products"("id");
ALTER TABLE
    "online_shop.orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "online_shop.customers"("id");
