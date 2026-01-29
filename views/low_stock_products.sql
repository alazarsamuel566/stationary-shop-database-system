-- low stock products view
CREATE VIEW v_low_stock_products AS
SELECT
    product.product_id,
    product.product_name,
    stock.quantity,
    product.low_stock_threshold
FROM product
JOIN stock
    ON product.product_id = stock.product_id
WHERE stock.quantity <= product.low_stock_threshold;
