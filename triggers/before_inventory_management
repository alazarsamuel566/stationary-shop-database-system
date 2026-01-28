DELIMITER $$

CREATE TRIGGER before_inventory_movement_insert
BEFORE INSERT ON inventory_movement
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Get current stock for the product
    SELECT quantity
    INTO current_stock
    FROM stock
    WHERE product_id = NEW.product_id;

    -- If no stock record exists, block operation
    IF current_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock record does not exist for this product.';
    END IF;

    -- Prevent negative stock for OUT movements
    IF NEW.movement_type = 'OUT' AND current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock: cannot remove more items than available.';
    END IF;
END$$

DELIMITER ;
