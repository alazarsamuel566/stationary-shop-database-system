-- Inventory Movement
CREATE TABLE inventory_movement (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    movement_type ENUM('IN', 'OUT', 'ADJUSTMENT') NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    movement_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(255),
    CONSTRAINT fk_movement_product
        FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT fk_movement_user
        FOREIGN KEY (user_id) REFERENCES shopOwner(user_id)
) ENGINE=InnoDB;
