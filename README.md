# stationary-shop-database-system

## Overview

This document describes the database schema for an Inventory Management System designed for shop owners to track products, suppliers, categories, stock levels, and inventory movements.

## Database Tables

### 1. shopOwner

Stores information about users who manage the shop.

**Table Structure:**
- `user_id` (INT, PRIMARY KEY, AUTO_INCREMENT) - Unique identifier for each user
- `full_name` (VARCHAR(100), NOT NULL) - Full name of the shop owner
- `email` (VARCHAR(100), NOT NULL, UNIQUE) - Email address (must be unique)
- `password` (VARCHAR(255), NOT NULL) - Encrypted password for authentication
- `role` (VARCHAR(50), NOT NULL) - User role (e.g., admin, manager, staff)

**Purpose:** Manages user authentication and authorization for the inventory system.

---

### 2. supplier

Stores information about product suppliers.

**Table Structure:**
- `supplier_id` (INT, PRIMARY KEY, AUTO_INCREMENT) - Unique identifier for each supplier
- `supplier_name` (VARCHAR(100), NOT NULL) - Name of the supplier
- `phone` (VARCHAR(20)) - Contact phone number
- `email` (VARCHAR(100)) - Contact email address
- `address` (VARCHAR(255)) - Physical address of the supplier

**Purpose:** Maintains supplier contact information for procurement and order management.

---

### 3. category

Organizes products into different categories.

**Table Structure:**
- `category_id` (INT, PRIMARY KEY, AUTO_INCREMENT) - Unique identifier for each category
- `category_name` (VARCHAR(100), NOT NULL, UNIQUE) - Name of the category (must be unique)
- `description` (TEXT) - Detailed description of the category

**Purpose:** Enables product classification and organization for easier inventory management.

---

### 4. product

Stores detailed information about products in the inventory.

**Table Structure:**
- `product_id` (INT, PRIMARY KEY, AUTO_INCREMENT) - Unique identifier for each product
- `product_name` (VARCHAR(150), NOT NULL) - Name of the product
- `description` (TEXT) - Detailed product description
- `purchase_price` (DECIMAL(10,2), NOT NULL) - Cost price when purchasing from supplier
- `sale_price` (DECIMAL(10,2), NOT NULL) - Selling price to customers
- `product_code` (VARCHAR(50), UNIQUE) - Unique product code/SKU
- `expiration_date` (DATE) - Expiration date for perishable items
- `low_stock_threshold` (INT, DEFAULT 5) - Minimum quantity before low stock alert
- `category_id` (INT, FOREIGN KEY) - References category table
- `supplier_id` (INT, FOREIGN KEY) - References supplier table
- `date_added` (DATETIME, DEFAULT CURRENT_TIMESTAMP) - Timestamp when product was added

**Foreign Key Constraints:**
- `fk_product_category`: Links to category table (ON DELETE SET NULL)
- `fk_product_supplier`: Links to supplier table (ON DELETE SET NULL)

**Purpose:** Central table for storing all product information including pricing, categorization, and supplier relationships.

---

### 5. stock

Tracks current quantity of each product in inventory.

**Table Structure:**
- `product_id` (INT, PRIMARY KEY) - References product table
- `quantity` (INT, NOT NULL, DEFAULT 0) - Current stock quantity
- `last_updated` (DATETIME) - Timestamp of last stock update

**Foreign Key Constraints:**
- `fk_stock_product`: Links to product table (ON DELETE CASCADE)

**Purpose:** Maintains real-time stock levels for inventory tracking and alerts.

---

### 6. inventory_movement

Records all stock movements (incoming, outgoing, and adjustments).

**Table Structure:**
- `movement_id` (INT, PRIMARY KEY, AUTO_INCREMENT) - Unique identifier for each movement
- `product_id` (INT, NOT NULL, FOREIGN KEY) - References product table
- `user_id` (INT, NOT NULL, FOREIGN KEY) - References shopOwner table
- `movement_type` (ENUM: 'IN', 'OUT', 'ADJUSTMENT', NOT NULL) - Type of movement
- `quantity` (INT, NOT NULL) - Number of units moved
- `unit_price` (DECIMAL(10,2)) - Price per unit at time of movement
- `movement_date` (DATETIME, DEFAULT CURRENT_TIMESTAMP) - Timestamp of movement
- `reason` (VARCHAR(255)) - Explanation for the movement

**Foreign Key Constraints:**
- `fk_movement_product`: Links to product table
- `fk_movement_user`: Links to shopOwner table

**Movement Types:**
- `IN`: Stock received from supplier
- `OUT`: Stock issued/sold
- `ADJUSTMENT`: Manual stock corrections

**Purpose:** Provides complete audit trail of all inventory transactions for accountability and reporting.

---

## Database Relationships

### Entity Relationship Diagram (Text Format)

```
shopOwner (1) ----< (Many) inventory_movement
supplier (1) ----< (Many) product
category (1) ----< (Many) product
product (1) ---- (1) stock
product (1) ----< (Many) inventory_movement
```

### Relationship Details

1. **shopOwner to inventory_movement**: One-to-Many
   - Each user can create multiple inventory movements
   - Each movement is created by one user

2. **supplier to product**: One-to-Many
   - Each supplier can supply multiple products
   - Each product has one supplier

3. **category to product**: One-to-Many
   - Each category can contain multiple products
   - Each product belongs to one category

4. **product to stock**: One-to-One
   - Each product has one stock record
   - Each stock record belongs to one product

5. **product to inventory_movement**: One-to-Many
   - Each product can have multiple movements
   - Each movement affects one product

---

## Key Features

### Data Integrity

1. **Foreign Key Constraints**: Ensures referential integrity between related tables
2. **Unique Constraints**: Prevents duplicate emails, category names, and product codes
3. **NOT NULL Constraints**: Ensures critical fields always have values
4. **Default Values**: Provides sensible defaults (e.g., low_stock_threshold = 5)

### Cascading Actions

1. **ON DELETE CASCADE**: When a product is deleted, its stock record is automatically removed
2. **ON DELETE SET NULL**: When a category or supplier is deleted, related products remain but the reference is set to NULL

### Audit Trail

The `inventory_movement` table provides complete tracking of:
- Who made the change (user_id)
- What was changed (product_id, quantity)
- When it happened (movement_date)
- Why it happened (reason)
- Type of change (movement_type)

---

## Usage Examples

### Adding a New Product

1. First, ensure supplier and category exist in their respective tables
2. Insert product with reference to supplier_id and category_id
3. Create corresponding stock record with initial quantity

### Recording Stock Receipt

1. Insert record into inventory_movement with:
   - movement_type = 'IN'
   - quantity = received amount
   - unit_price = purchase price
2. Update stock table to increase quantity

### Recording Stock Issue/Sale

1. Insert record into inventory_movement with:
   - movement_type = 'OUT'
   - quantity = issued amount
   - unit_price = sale price
2. Update stock table to decrease quantity

### Stock Adjustment

1. Insert record into inventory_movement with:
   - movement_type = 'ADJUSTMENT'
   - quantity = adjustment amount (positive or negative)
   - reason = explanation for adjustment
2. Update stock table accordingly

---

## Low Stock Monitoring

Products can be monitored for low stock by comparing:
- Current quantity in `stock` table
- `low_stock_threshold` in `product` table

Query example concept:
```
SELECT products with stock.quantity <= product.low_stock_threshold
```

---

## Expiration Date Tracking

For perishable items:
- `expiration_date` field in product table
- Can query products expiring soon or already expired
- Useful for inventory rotation and waste prevention

---

## Storage Engine

All tables use InnoDB engine which provides:
- ACID compliance (Atomicity, Consistency, Isolation, Durability)
- Foreign key constraint support
- Row-level locking for better concurrency
- Crash recovery capabilities

---

## Security Considerations

1. **Password Storage**: The password field should store hashed passwords, never plain text
2. **User Roles**: The role field enables role-based access control
3. **Audit Trail**: inventory_movement table tracks all changes with user accountability

---

## Maintenance Recommendations

1. **Regular Backups**: Schedule automated database backups
2. **Index Optimization**: Consider adding indexes on frequently queried fields
3. **Data Archival**: Archive old inventory_movement records periodically
4. **Stock Reconciliation**: Regularly verify physical stock matches database records

---

## Future Enhancements

Potential additions to consider:
- Customer table for sales tracking
- Sales/Orders table for transaction management
- Purchase Orders table for supplier order management
- Warehouse/Location table for multi-location inventory
- Product images or attachments
- Barcode/QR code integration
- Reporting and analytics tables

---

## Database Creation

To create this database schema, execute the provided SQL statements in order:
1. shopOwner
2. supplier
3. category
4. product
5. stock
6. inventory_movement

This order ensures foreign key references are satisfied during table creation.

---

## Version Information

- Database Schema Version: 1.0
- Engine: InnoDB
- Character Set: Default (UTF-8 recommended)
- Collation: Default (utf8mb4_unicode_ci recommended)

---

## Contribution Statement

## Overview
The database schema for this project was implemented by distributing development tasks among the team members to ensure efficiency, clarity, and balanced workload. Each team member was responsible for designing, implementing, and committing their assigned database tables as **separate `.sql` files**, in accordance with the project requirements.


## Team Contributions


- **Kidus Alemayehu**
- Designed, implemented, and committed the `ShopOwner` table
- Designed, implemented, and committed the `Supplier` table


- **Alazar Samuel**
- Designed, implemented, and committed the `Category` table
- Designed, implemented, and committed the `Stock` table


- **Tesfaye Abel**
- Designed, implemented, and committed the `Product` table


- **Nahom Torba**
- Designed, implemented, and committed the `InventoryMovement` table


## Notes
- Each database table is stored in its own `.sql` file.
- All implementations follow the agreed database design and naming conventions.
- The schema supports product management, inventory tracking, and supplier/shop relationships.
