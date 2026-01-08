# TabSectionDemo - 示例项目

这是 TabSection 框架的示例项目，展示了框架的各种使用场景和功能。

## 项目结构

```
TabSectionDemo/
├── TabSectionDemoApp.swift          # 应用入口
├── ContentView.swift                # 主示例视图（完整功能展示）
├── Examples/                        # 使用示例
│   ├── BasicUsageExample.swift     # 基础用法示例
│   └── StyleDemoView.swift         # 样式演示
├── View/                           # 辅助视图组件
│   ├── HeaderContentView.swift     # 头部内容视图
│   ├── TabSectionHeader.swift      # Tab 区域头部（仅用于演示）
│   ├── TabSectionContentView.swift # Tab 内容视图
│   ├── ContentCardView.swift       # 内容卡片
│   ├── EmptyDataView.swift         # 空数据视图
│   └── FeatureButton.swift         # 功能按钮
└── Extension/
    └── Color+Hex.swift             # 框架已提供，此处保留仅供参考
```

## 运行项目

### 方式 1: 使用 CocoaPods（推荐）

1. 在 Demo 目录下运行：
```bash
cd Demo
pod install
```

2. 打开 `TabSectionDemo.xcworkspace`（不是 .xcodeproj）

3. 选择模拟器或真机，按 `Cmd + R` 运行

### 方式 2: 使用 Swift Package Manager

1. 在 Xcode 中打开 `TabSectionDemo.xcodeproj`

2. 选择 **File** → **Add Package Dependencies...**

3. 添加本地包：选择 TabSection 根目录（父目录）

4. 运行项目

## 示例说明

### 1. ContentView - 完整功能示例

主视图展示了 TabSection 框架的核心功能：

- ✅ 自定义头部内容（Banner、搜索栏、功能入口）
- ✅ 多个标签页（8 个）
- ✅ 不同数量的内容（测试高度自适应）
- ✅ 下拉刷新
- ✅ Tab 切换回调
- ✅ 吸顶效果

**关键代码：**

```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $currentSelect,
    headerContent: {
        HeaderContentView()
    },
    pageContent: { tab, index in
        TabSectionContentView(
            tab: tab,
            items: generateContentItems(for: tab)
        )
    }
)
.refreshable {
    await refreshData()
}
.onTabChanged { oldIndex, newIndex in
    print("从标签 \(oldIndex) 切换到 \(newIndex)")
}
```

### 2. BasicUsageExample - 基础用法

展示了 6 种基础使用场景：

#### 2.1 最简单的使用
```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    pageContent: { tab, index in
        Text("这是 \(tab) 页面")
    }
)
```

#### 2.2 带头部内容
```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    headerContent: {
        HeaderView()
    },
    pageContent: { tab, index in
        ContentView(tab: tab)
    }
)
```

#### 2.3 自定义样式
```swift
TSStickyTabContainer(...)
    .tabStyle(TSTabStyle(
        selectedColor: Color(hex: "#FF6B6B"),
        underlineColor: Color(hex: "#FF6B6B")
    ))
```

#### 2.4 预设样式切换
演示三种预设样式的切换：`.default`、`.minimal`、`.rounded`

#### 2.5 下拉刷新
```swift
TSStickyTabContainer(...)
    .refreshable {
        await refreshData()
    }
```

#### 2.6 Tab 切换回调
```swift
TSStickyTabContainer(...)
    .onTabChanged { oldIndex, newIndex in
        // 记录切换日志
    }
```

### 3. StyleDemoView - 样式演示

提供了 4 个独立的样式演示页面：

- **DefaultStyleDemo** - 默认蓝色风格
- **MinimalStyleDemo** - 简约风格
- **RoundedStyleDemo** - 圆角风格
- **CustomStyleDemo** - 自定义红色主题

每个页面都是独立的，可以直接作为参考代码使用。

## 辅助视图组件

### HeaderContentView
完整的头部内容示例，包含：
- Banner 区域（渐变背景）
- 搜索栏
- 功能入口按钮

### TabSectionContentView
标签页内容容器，支持：
- 列表内容展示
- 空数据占位

### ContentCardView
内容卡片组件，用于展示列表项

### EmptyDataView
空数据占位视图，友好的提示界面

### FeatureButton
功能入口按钮，圆形图标 + 文字标题

## 使用技巧

### 1. 如何调整 Tab 样式？

修改 `ContentView` 中的代码，添加 `.tabStyle()` 修饰符：

```swift
TSStickyTabContainer(...)
    .tabStyle(.minimal)  // 或 .default、.rounded
```

### 2. 如何修改头部内容？

编辑 `HeaderContentView.swift`，自定义你的头部布局。

### 3. 如何修改列表内容？

编辑 `TabSectionContentView.swift` 或直接在 `pageContent` 闭包中自定义内容。

### 4. 如何添加网络请求？

在 `ContentView` 的 `refreshData()` 方法中添加实际的网络请求代码：

```swift
private func refreshData() async {
    // 替换为真实的网络请求
    do {
        let data = try await NetworkManager.fetchData()
        // 更新数据
    } catch {
        print("加载失败: \(error)")
    }
}
```

### 5. 如何在 Tab 切换时加载数据？

使用 `.onTabChanged` 回调：

```swift
.onTabChanged { oldIndex, newIndex in
    Task {
        await loadData(for: newIndex)
    }
}
```

## 常见场景

### 新闻资讯 App

参考 `ContentView`，包含：
- 头部 Banner
- 搜索功能
- 多个频道标签
- 下拉刷新

### 个人主页

参考 `WithHeaderExample`，包含：
- 用户信息头部
- 动态/文章/收藏等标签

### 商品详情页

参考 `CustomStyleExample`，包含：
- 商品图片展示区
- 详情/评价/推荐等标签

## 预览

每个示例文件都包含 `#Preview`，可以在 Xcode 中直接预览：

1. 打开任意示例文件
2. 点击右侧的 Preview 按钮
3. 选择要预览的示例

## 故障排除

### 1. 编译错误：找不到 TabSection

**原因：** 没有正确安装依赖

**解决：**
```bash
cd Demo
pod install
```
然后使用 `TabSectionDemo.xcworkspace` 打开项目

### 2. 样式不生效

**原因：** 可能忘记调用 `.tabStyle()` 修饰符

**解决：** 确保添加了样式配置
```swift
TSStickyTabContainer(...)
    .tabStyle(.minimal)
```

### 3. 下拉刷新不工作

**原因：** 需要在真机或支持刷新的模拟器上测试

**解决：** 使用 iOS 15.0+ 的模拟器或真机

## 学习路径

建议按以下顺序学习：

1. **BasicUsageExample** - 了解基础用法
2. **ContentView** - 看完整功能如何组合
3. **StyleDemoView** - 学习样式定制
4. **自定义** - 基于示例创建自己的页面

## 更多资源

- [主文档](../README.md) - 框架功能介绍
- [API 文档](../DOCUMENTATION.md) - 完整 API 参考
- [快速开始](../QUICKSTART.md) - 5 分钟上手指南
- [迁移指南](../MIGRATION.md) - 从旧代码迁移

## 反馈

如有问题或建议，欢迎提交 Issue 或 Pull Request。

---

**Happy Coding!** 🚀
