# vCampus GUI 界面统一规范 V1.4

本文档用于统一各业务模块的 Swing 页面风格。当前登录页、大厅和图书馆模块已经按此方向调整，后续学籍、选课、商店、银行、宿舍、在线课堂、BBS 都建议保持一致。

## 零、客户端外观基线

客户端统一引入 FlatLaf 浅色外观，并通过 `ClientTheme.install()` 在创建 Swing 窗口前完成初始化。

```text
入口：edu.seu.vcampus.client.view.component.ClientTheme
调用位置：ClientApplication / 各模块独立测试入口
样式原则：FlatLaf 负责基础控件质感，CampusUI 负责 vCampus 自己的颜色、按钮、表格和边框规范。
```

各模块不要单独设置另一套 LookAndFeel。需要独立测试窗口时，先调用：

```java
ClientTheme.install();
```

## 一、整体风格

```text
背景色：浅灰蓝 #F5F7FB
主色：蓝色 #2F65E7
强调蓝：#2563EB
文字主色：#0F172A
辅助文字：#64748B
边框：#E2E8F0
字体：Microsoft YaHei UI
```

页面应该保持“清爽、规整、信息清楚”的校园管理系统风格，不做花哨渐变，不做复杂装饰图。

## 二、模块页面结构

每个模块建议统一为：

```text
模块首页
  上方：模块概要信息
  下方：子功能入口按钮

子功能页面
  顶部：标题、说明、返回按钮
  中部：查询/筛选工具栏
  主体：列表、表格或详情区域
```

如果是检索类页面，例如图书馆，推荐：

```text
顶部大搜索框
左侧筛选条件
中间结果列表
右侧选中详情
```

如果是管理类页面，例如用户管理、馆藏维护、订单管理，推荐：

```text
顶部筛选工具栏
中间表格
右侧或弹窗显示编辑表单
```

## 三、按钮规范

客户端已提供公共样式类：

```text
edu.seu.vcampus.client.view.component.CampusUI
```

推荐使用：

```java
CampusUI.primaryButton("检索")
CampusUI.secondaryButton("返回")
CampusUI.neutralButton("刷新")
CampusUI.dangerButton("删除")
CampusUI.cardBorder()
CampusUI.styleTable(table)
```

按钮含义：

```text
蓝色主按钮：主要动作，例如登录、检索、新增、提交、确认
白底蓝字按钮：次要动作，例如返回、编辑、续借
白底普通按钮：低风险动作，例如刷新、清空
红色按钮：危险动作，例如删除、下架、冻结、取消授权
```

## 四、布局要求

```text
禁止 null 布局
禁止绝对坐标
优先使用 BorderLayout / GridLayout / GridBagLayout / BoxLayout
表格行高建议 34
页面边距建议 16 到 28
卡片边框统一 #E2E8F0
```

## 五、业务交互要求

```text
查询、保存、提交等慢操作使用 SwingWorker
界面不直接连数据库，只调用 ClientService
危险操作必须二次确认
操作成功要有提示
操作失败显示服务端返回的错误信息
模块子页面必须能返回模块首页或工作台
```

## 六、图书馆模块当前示范

图书馆的“图书检索”页面已经改为接近真实图书馆检索系统的布局：

```text
顶部大搜索框
左侧筛选栏
中部结果卡片
右侧图书详情
每条结果可查看详情或直接借阅
```

其他模块后续可以按这个思路做自己的真实业务页面，而不是只放一张测试表格。
