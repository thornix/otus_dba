CREATE DATABASE IF NOT EXISTS clothing_store;
USE clothing_store;

-- Таблица пользователей
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_settings JSON
);

-- Таблица категорий товаров
CREATE TABLE categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Таблица товаров
CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id BIGINT,
    size VARCHAR(10),
    color VARCHAR(50),
    image_url VARCHAR(500),
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Таблица корзины
CREATE TABLE cart_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- Таблица заказов
CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    shipping_address TEXT,
    payment_method VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Таблица элементов заказа
CREATE TABLE order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Вставка тестовых данных
INSERT INTO categories (name, description) VALUES 
('Футболки', 'Мужские и женские футболки'),
('Джинсы', 'Джинсы различных фасонов'),
('Платья', 'Элегантные платья'),
('Куртки', 'Верхняя одежда');

INSERT INTO products (name, description, price, category_id, size, color, image_url, stock_quantity) VALUES 
('Футболка хлопковая', 'Мягкая хлопковая футболка', 29.99, 1, 'M', 'Белый', '/images/tshirt1.jpg', 50),
('Джинсы slim fit', 'Облегающие джинсы', 89.99, 2, '32', 'Синий', '/images/jeans1.jpg', 30),
('Кожаная куртка', 'Натуральная кожаная куртка', 199.99, 4, 'L', 'Черный', '/images/jacket1.jpg', 15),
('Летнее платье', 'Легкое летнее платье', 59.99, 3, 'S', 'Цветочный', '/images/dress1.jpg', 25);
