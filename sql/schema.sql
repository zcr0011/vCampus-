CREATE DATABASE IF NOT EXISTS vcampus
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE vcampus;

CREATE TABLE IF NOT EXISTS sys_user (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    login_name VARCHAR(32) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    must_change_password BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS teacher (
    teacher_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    teacher_no VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(80),
    title VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_teacher_user
        FOREIGN KEY (user_id) REFERENCES sys_user(user_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sys_audit_log (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    operator_user_id BIGINT,
    target_user_id BIGINT,
    action VARCHAR(50) NOT NULL,
    detail VARCHAR(255),
    result VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_operator (operator_user_id),
    INDEX idx_audit_target (target_user_id),
    CONSTRAINT fk_audit_operator
        FOREIGN KEY (operator_user_id) REFERENCES sys_user(user_id),
    CONSTRAINT fk_audit_target
        FOREIGN KEY (target_user_id) REFERENCES sys_user(user_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sys_module_admin (
    module_admin_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    module_code VARCHAR(32) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_module_admin_user_module
        UNIQUE (user_id, module_code),
    CONSTRAINT fk_module_admin_user
        FOREIGN KEY (user_id) REFERENCES sys_user(user_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student (
    student_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    student_no VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    major VARCHAR(80),
    class_name VARCHAR(80),
    grade VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_user
        FOREIGN KEY (user_id) REFERENCES sys_user(user_id)
) ENGINE=InnoDB;
