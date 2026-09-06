# 模块 SQL 提交约定

各业务模块可以先提交自己的 SQL 文件，但最终由组长合并进上一级 `schema.sql` 和 `data.sql`，并按外键依赖排序。

当前建议顺序：

1. `sys_user`
2. `student`
3. `course`
4. `course_section`
5. `enroll_period`
6. `enrollment`
7. `classroom`
8. `notice`
9. `course_resource`
10. `assignment`
11. `assignment_submission`

涉及外键时不要重复创建别人负责的主表。例如选课和作业提交只引用 `student(student_id)`，不重新建 `student`。

当前已确认：

- 用户管理/学籍依赖：`user_schema.sql`
- 选课系统：`course_schema.sql`
- LMS 在线课堂：`classroom_schema.sql`
- 选课系统 + LMS 在线课堂合并版：`course_classroom_schema.sql`
- 商店 + 虚拟银行：`bank_shop_schema.sql`

字段命名以 `vcampus-common` 中公共 DTO 为准。例如：

- 课程名统一用 `course.name`，不要写成 `course_name`。
- 开课班教师统一用 `course_section.teacher_id`，引用 `sys_user(user_id)`。
- 课堂统一用 `classroom.course_id / teacher_id / title`，当前不使用 `section_id`。
- 公告发布人统一用 `notice.publisher_id`。
- 资源上传人统一用 `course_resource.uploader_id`。
- 时间字段统一使用 `created_at`，资源表不单独使用 `uploaded_at`。
