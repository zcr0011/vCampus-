USE vcampus;

-- ============================================================
-- 选课系统 + LMS 在线课堂模块建表脚本
-- ------------------------------------------------------------
-- 本文件是主框架当前公共 DTO 与服务端代码对齐后的统一版本。
-- 依赖表：
--   sys_user(user_id)   来自用户管理
--   student(student_id) 来自学籍管理
-- 外键策略：ON DELETE RESTRICT，禁止级联删除业务历史数据。
-- ============================================================

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS enroll_period (
    term VARCHAR(32) PRIMARY KEY,
    enroll_start_at DATETIME NOT NULL,
    enroll_end_at DATETIME NOT NULL,
    drop_end_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;
