DELIMITER $$

CREATE TRIGGER after_inventory_movement_insert
AFTER INSERT ON inventory_movement
FOR EACH ROW
BEGIN
    IF NEW.movement_type = 'IN' THEN
        UPDATE stock
        SET quantity = quantity + NEW.quantity,
            last_updated = NOW()
        WHERE product_id = NEW.product_id;

    ELSEIF NEW.movement_type = 'OUT' THEN
        UPDATE stock
        SET quantity = quantity - NEW.quantity,
            last_updated = NOW()
        WHERE product_id = NEW.product_id;

    ELSEIF NEW.movement_type = 'ADJUSTMENT' THEN
        UPDATE stock
        SET quantity = NEW.quantity,
            last_updated = NOW()
        WHERE product_id = NEW.product_id;
    END IF;
END$$

DELIMITER ;
