CREATE TABLE "products"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NULL,
    "supplier_id" BIGINT NOT NULL,
    "manufacturer_id" BIGINT NOT NULL,
    "price_id" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL,
    "category_id" BIGINT NOT NULL
);
CREATE INDEX "products_supplier_id_index" ON
    "products"("supplier_id");
CREATE INDEX "products_category_id_index" ON
    "products"("category_id");
CREATE INDEX "products_price_id_index" ON
    "products"("price_id");
CREATE INDEX "products_manufacturer_id_index" ON
    "products"("manufacturer_id");
ALTER TABLE
    "products" ADD PRIMARY KEY("id");
CREATE TABLE "suppliers"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL,
    "email" CHAR(255) NOT NULL
);
CREATE INDEX "suppliers_name_phone_email_index" ON
    "suppliers"("name", "phone", "email");
ALTER TABLE
    "suppliers" ADD PRIMARY KEY("id");
CREATE TABLE "orders"(
    "id" BIGINT NOT NULL,
    "customer_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    "date" BIGINT NOT NULL,
    "sum" BIGINT NOT NULL
);
CREATE INDEX "orders_date_index" ON
    "orders"("date");
CREATE INDEX "orders_customer_id_index" ON
    "orders"("customer_id");
CREATE INDEX "orders_product_id_index" ON
    "orders"("product_id");
ALTER TABLE
    "orders" ADD PRIMARY KEY("id");
CREATE TABLE "category"(
    "id" BIGINT NOT NULL,
    "name" BIGINT NOT NULL
);
CREATE INDEX "category_name_index" ON
    "category"("name");
ALTER TABLE
    "category" ADD PRIMARY KEY("id");
CREATE TABLE "customers"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "email" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL
);
CREATE INDEX "customers_name_phone_email_index" ON
    "customers"("name", "phone", "email");
ALTER TABLE
    "customers" ADD PRIMARY KEY("id");
CREATE TABLE "manufacturer"(
    "id" BIGINT NOT NULL,
    "name" CHAR(255) NOT NULL,
    "address" CHAR(255) NOT NULL,
    "phone" BIGINT NOT NULL,
    "email" BIGINT NOT NULL
);
CREATE INDEX "manufacturer_name_phone_email_index" ON
    "manufacturer"("name", "phone", "email");
ALTER TABLE
    "manufacturer" ADD PRIMARY KEY("id");
CREATE TABLE "prices"(
    "id" BIGINT NOT NULL,
    "price" BIGINT NOT NULL
);
ALTER TABLE
    "prices" ADD PRIMARY KEY("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_manufacturer_id_foreign" FOREIGN KEY("manufacturer_id") REFERENCES "manufacturer"("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_category_id_foreign" FOREIGN KEY("category_id") REFERENCES "category"("id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "customers"("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_supplier_id_foreign" FOREIGN KEY("supplier_id") REFERENCES "suppliers"("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_price_id_foreign" FOREIGN KEY("price_id") REFERENCES "prices"("id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("id");