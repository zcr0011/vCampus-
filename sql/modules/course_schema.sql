-- ============================================================
-- 选课系统模块建表脚本（已与主框架公共 DTO 对齐）
-- 表：course / course_section / enroll_period / enrollment
-- ------------------------------------------------------------
-- 依赖（本文件不重复创建）：
--   sys_user(user_id)   用户管理模块
--   student(student_id) 学籍模块
-- 建表顺序：course -> course_section -> enroll_period -> enrollment
-- 外键策略：ON DELETE RESTRICT，禁止级联删除业务历史数据。
-- ============================================================

USE vcampus;

CREATE TABLE IF NOT EXISTS course (
    course_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credit VARCHAR(20) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course_section (
    section_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    term VARCHAR(32) NOT NULL,
    capacity INT NOT NULL,
    selected_count INT NOT NULL DEFAULT 0,
    week_day TINYINT NOT NULL COMMENT '星期：1=周一 ... 7=周日',
    start_period TINYINT NOT NULL COMMENT '开始节次（含）',
    end_period TINYINT NOT NULL COMMENT '结束节次（含）',
    location VARCHAR(100),
    enroll_start DATETIME,
    enroll_end DATETIME,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_section_course
        FOREIGN KEY (course_id) REFERENCES course(course_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_course_section_teacher
        FOREIGN KEY (teacher_id) REFERENCES sys_user(user_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS enroll_period (
    term VARCHAR(32) PRIMARY KEY,
    enroll_start_at DATETIME NOT NULL,
    enroll_end_at DATETIME NOT NULL,
    drop_end_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS enrollment (
    enrollment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    section_id BIGINT NOT NULL,
    term VARCHAR(32) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ENROLLED',
    enrolled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_enrollment_student_section
        UNIQUE (student_id, section_id),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_enrollment_section
        FOREIGN KEY (section_id) REFERENCES course_section(section_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
