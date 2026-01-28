-- Product
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    purchase_price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    product_code VARCHAR(50) UNIQUE,
    expiration_date DATE,
    low_stock_threshold INT DEFAULT 5,
    category_id INT,
    supplier_id INT,
    date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES category(category_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
        ON DELETE SET NULL
) ENGINE=InnoDB;s