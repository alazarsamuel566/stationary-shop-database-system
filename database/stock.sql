CREATE TABLE stock (
    product_id INT PRIMARY KEY,
    quantity INT NOT NULL DEFAULT 0,
    last_updated DATETIME,
    CONSTRAINT fk_stock_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;