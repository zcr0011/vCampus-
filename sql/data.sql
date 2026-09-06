USE vcampus;

INSERT INTO sys_user (
    login_name,
    password_hash,
    real_name,
    role,
    status,
    must_change_password
) VALUES (
    'A000001',
    'sha256$AQIDBAUGBwgJCgsMDQ4PEA$X9ydvzf6Cc1JqAwyN6rwJM5J0Cv3BlQCciogKAaB6x8',
    '系统管理员',
    'ADMIN',
    'ACTIVE',
    FALSE
) ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    real_name = VALUES(real_name),
    role = VALUES(role),
    status = VALUES(status),
    must_change_password = VALUES(must_change_password);

INSERT INTO sys_user (
    login_name,
    password_hash,
    real_name,
    role,
    status,
    must_change_password
) VALUES (
    'T20260001',
    'sha256$AQIDBAUGBwgJCgsMDQ4PEA$X9ydvzf6Cc1JqAwyN6rwJM5J0Cv3BlQCciogKAaB6x8',
    '测试教师',
    'TEACHER',
    'ACTIVE',
    FALSE
) ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    real_name = VALUES(real_name),
    role = VALUES(role),
    status = VALUES(status),
    must_change_password = VALUES(must_change_password);

INSERT INTO sys_user (
    login_name,
    password_hash,
    real_name,
    role,
    status,
    must_change_password
) VALUES (
    'S20260001',
    'sha256$AQIDBAUGBwgJCgsMDQ4PEA$X9ydvzf6Cc1JqAwyN6rwJM5J0Cv3BlQCciogKAaB6x8',
    '测试学生',
    'STUDENT',
    'ACTIVE',
    FALSE
) ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    real_name = VALUES(real_name),
    role = VALUES(role),
    status = VALUES(status),
    must_change_password = VALUES(must_change_password);

INSERT INTO student (
    user_id,
    student_no,
    name,
    major,
    class_name,
    grade,
    status
) SELECT
    user_id,
    '20260001',
    '测试学生',
    '软件工程',
    '软件工程一班',
    '2026',
    'ACTIVE'
FROM sys_user
WHERE login_name = 'S20260001'
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    major = VALUES(major),
    class_name = VALUES(class_name),
    grade = VALUES(grade),
    status = VALUES(status);

INSERT INTO teacher (
    user_id,
    teacher_no,
    name,
    department,
    title,
    status
) SELECT
    user_id,
    'T20260001',
    '测试教师',
    '计算机科学与工程学院',
    '讲师',
    'ACTIVE'
FROM sys_user
WHERE login_name = 'T20260001'
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    department = VALUES(department),
    title = VALUES(title),
    status = VALUES(status);
