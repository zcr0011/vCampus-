-- ============================================================
-- 在线课堂（LMS）模块建表脚本（已与主框架公共 DTO 对齐）
-- 表：classroom / notice / course_resource / assignment / assignment_submission
-- ------------------------------------------------------------
-- 依赖（本文件不重复创建）：
--   sys_user(user_id)   用户管理模块
--   student(student_id) 学籍模块
--   course(course_id)   选课系统模块
-- 建表顺序：classroom -> notice -> course_resource -> assignment -> assignment_submission
-- 外键策略：ON DELETE RESTRICT，禁止级联删除业务历史数据。
-- ============================================================

USE vcampus;

CREATE TABLE IF NOT EXISTS classroom (
    classroom_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT NULL,
    teacher_id BIGINT NOT NULL,
    title VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_classroom_course
        FOREIGN KEY (course_id) REFERENCES course(course_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_classroom_teacher
        FOREIGN KEY (teacher_id) REFERENCES sys_user(user_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS notice (
    notice_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    classroom_id BIGINT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    publisher_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    CONSTRAINT fk_notice_classroom
        FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_notice_publisher
        FOREIGN KEY (publisher_id) REFERENCES sys_user(user_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course_resource (
    resource_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    classroom_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    file_type VARCHAR(100),
    storage_path VARCHAR(500) NOT NULL,
    uploader_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_resource_classroom
        FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_course_resource_uploader
        FOREIGN KEY (uploader_id) REFERENCES sys_user(user_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS assignment (
    assignment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    classroom_id BIGINT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT,
    deadline DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_assignment_classroom
        FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS assignment_submission (
    submission_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assignment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    content TEXT,
    score INT,
    comment TEXT,
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'SUBMITTED',
    CONSTRAINT uk_assignment_submission_student
        UNIQUE (assignment_id, student_id),
    CONSTRAINT fk_assignment_submission_assignment
        FOREIGN KEY (assignment_id) REFERENCES assignment(assignment_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_assignment_submission_student
        FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
