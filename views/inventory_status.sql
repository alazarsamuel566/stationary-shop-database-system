-- View to monitor inventory status
CREATE VIEW v_inventory_status AS
SELECT
    product.product_id,
    product.product_name,
    category.category_name,
    stock.quantity,
    product.low_stock_threshold
FROM product
JOIN stock
    ON product.product_id = stock.product_id
LEFT JOIN category
    ON product.category_id = category.category_id;
