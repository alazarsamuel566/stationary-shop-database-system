DELIMITER $$

CREATE TRIGGER after_product_insert
AFTER INSERT ON product
FOR EACH ROW
BEGIN
    INSERT INTO stock (product_id, quantity, last_updated)
    VALUES (NEW.product_id, 0, NOW());
END$$

DELIMITER ;
