USE vcampus;

CREATE TABLE IF NOT EXISTS product (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(12,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    reserved_stock INT NOT NULL DEFAULT 0,
    version INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CHECK (price >= 0),
    CHECK (stock >= 0),
    CHECK (reserved_stock >= 0),
    CHECK (reserved_stock <= stock)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS shop_order (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(64) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    client_request_no VARCHAR(64) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_biz_no VARCHAR(64) UNIQUE NULL,
    version INT NOT NULL DEFAULT 0,
    paid_at DATETIME NULL,
    cancelled_at DATETIME NULL,
    expires_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_shop_order_user_client_request
        UNIQUE (user_id, client_request_no),
    CONSTRAINT fk_shop_order_user
        FOREIGN KEY (user_id) REFERENCES sys_user(user_id),
    CHECK (total_amount >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS shop_order_item (
    item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_shop_order_item_order
        FOREIGN KEY (order_id) REFERENCES shop_order(order_id),
    CONSTRAINT fk_shop_order_item_product
        FOREIGN KEY (product_id) REFERENCES product(product_id),
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    CHECK (subtotal >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bank_account (
    account_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    version INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bank_account_user
        FOREIGN KEY (user_id) REFERENCES sys_user(user_id),
    CHECK (balance >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bank_transaction (
    txn_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    biz_no VARCHAR(64) NOT NULL UNIQUE,
    from_account_id BIGINT NULL,
    to_account_id BIGINT NULL,
    amount DECIMAL(12,2) NOT NULL,
    txn_type VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bank_transaction_from
        FOREIGN KEY (from_account_id) REFERENCES bank_account(account_id),
    CONSTRAINT fk_bank_transaction_to
        FOREIGN KEY (to_account_id) REFERENCES bank_account(account_id),
    CHECK (amount > 0)
) ENGINE=InnoDB;
