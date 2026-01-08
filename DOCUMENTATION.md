# TabSection API 文档

本文档详细介绍 TabSection 框架的所有公开 API。

## 目录

- [核心组件](#核心组件)
  - [TSStickyTabContainer](#tsstickytabcontainer)
  - [TSTabsView](#tstabsview)
- [配置系统](#配置系统)
  - [TSTabStyle](#tstabstyle)
  - [TSUnderlineWidth](#tsunderlinewidth)
- [扩展工具](#扩展工具)
  - [Color+Hex](#colorhex)

---

## 核心组件

### TSStickyTabContainer

吸顶 Tab 容器视图，提供标签栏吸顶、多分页内容管理功能。

#### 初始化方法

##### 带头部内容的初始化

```swift
public init(
    tabs: [String],
    selectedIndex: Binding<Int>,
    tabStyle: TSTabStyle = .default,
    @ViewBuilder headerContent: @escaping () -> HeaderContent,
    @ViewBuilder pageContent: @escaping (String, Int) -> PageContent
)
```

**参数：**

- `tabs`: 标签数据数组
- `selectedIndex`: 当前选中的标签索引（双向绑定）
- `tabStyle`: Tab 样式配置，默认为 `.default`
- `headerContent`: 头部内容构建器，返回任意 View
- `pageContent`: 页面内容构建器，接收当前标签名称和索引，返回对应页面的 View

**示例：**

```swift
TSStickyTabContainer(
    tabs: ["推荐", "关注", "最新"],
    selectedIndex: $selectedIndex,
    headerContent: {
        VStack {
            Text("头部内容")
            SearchBar()
        }
    },
    pageContent: { tab, index in
        ContentList(tab: tab)
    }
)
```

##### 不带头部内容的初始化

```swift
public init(
    tabs: [String],
    selectedIndex: Binding<Int>,
    tabStyle: TSTabStyle = .default,
    @ViewBuilder pageContent: @escaping (String, Int) -> PageContent
) where HeaderContent == EmptyView
```

**参数：**

- `tabs`: 标签数据数组
- `selectedIndex`: 当前选中的标签索引（双向绑定）
- `tabStyle`: Tab 样式配置，默认为 `.default`
- `pageContent`: 页面内容构建器

**示例：**

```swift
TSStickyTabContainer(
    tabs: ["首页", "发现", "我的"],
    selectedIndex: $selectedIndex,
    pageContent: { tab, index in
        Text("\(tab) 页面内容")
    }
)
```

#### 视图修饰符

##### tabStyle(_:)

设置 Tab 样式。

```swift
public func tabStyle(_ style: TSTabStyle) -> TSStickyTabContainer
```

**参数：**

- `style`: Tab 样式配置对象

**返回值：** 应用了样式的容器视图

**示例：**

```swift
TSStickyTabContainer(...)
    .tabStyle(.minimal)

// 或自定义样式
TSStickyTabContainer(...)
    .tabStyle(TSTabStyle(
        selectedColor: .red,
        underlineColor: .red
    ))
```

##### refreshable(_:)

设置下拉刷新回调。

```swift
public func refreshable(_ callback: @escaping () async -> Void) -> TSStickyTabContainer
```

**参数：**

- `callback`: 异步刷新回调闭包

**返回值：** 支持下拉刷新的容器视图

**示例：**

```swift
TSStickyTabContainer(...)
    .refreshable {
        await loadData()
    }
```

##### onTabChanged(_:)

设置 Tab 切换回调。

```swift
public func onTabChanged(_ callback: @escaping (Int, Int) -> Void) -> TSStickyTabContainer
```

**参数：**

- `callback`: Tab 切换回调闭包，接收旧索引和新索引

**返回值：** 带有切换回调的容器视图

**示例：**

```swift
TSStickyTabContainer(...)
    .onTabChanged { oldIndex, newIndex in
        print("从 Tab \(oldIndex) 切换到 Tab \(newIndex)")
        loadDataForTab(newIndex)
    }
```

##### enableLazyLoading(_:)

设置是否启用懒加载。

```swift
public func enableLazyLoading(_ enabled: Bool) -> TSStickyTabContainer
```

**参数：**

- `enabled`: 是否启用懒加载，默认为 `true`

**返回值：** 应用了懒加载设置的容器视图

**示例：**

```swift
TSStickyTabContainer(...)
    .enableLazyLoading(true)
```

---

### TSTabsView

Tab 标签栏视图组件，可以独立使用。

#### 初始化方法

```swift
public init(
    tabs: [String],
    currentSelect: Binding<Int>,
    style: TSTabStyle = .default
)
```

**参数：**

- `tabs`: 标签数据数组
- `currentSelect`: 当前选中的标签索引（双向绑定）
- `style`: Tab 样式配置，默认为 `.default`

**示例：**

```swift
TSTabsView(
    tabs: ["Tab 1", "Tab 2", "Tab 3"],
    currentSelect: $selectedIndex,
    style: .minimal
)
```

---

## 配置系统

### TSTabStyle

Tab 样式配置结构体，用于定制 Tab 标签栏的外观。

#### 属性

##### 字体配置

```swift
public var selectedFont: Font          // 选中状态的字体
public var unselectedFont: Font        // 未选中状态的字体
```

##### 颜色配置

```swift
public var selectedColor: Color        // 选中状态的文字颜色
public var unselectedColor: Color      // 未选中状态的文字颜色
public var underlineColor: Color       // 下划线颜色
public var backgroundColor: Color      // 背景颜色
public var dividerColor: Color         // 分割线颜色
```

##### 布局配置

```swift
public var itemSpacing: CGFloat        // Tab 项之间的间距
public var horizontalPadding: CGFloat  // Tab 项的水平内边距
public var verticalPadding: CGFloat    // Tab 项的垂直内边距
public var underlineHeight: CGFloat    // 下划线高度
public var underlineWidth: TSUnderlineWidth  // 下划线宽度
```

##### 动画配置

```swift
public var animationDuration: Double   // 动画持续时间
public var animationCurve: Animation   // 动画曲线
```

#### 初始化方法

```swift
public init(
    selectedFont: Font = .system(size: 16, weight: .medium),
    unselectedFont: Font = .system(size: 14),
    selectedColor: Color = Color(hex: "#1677ff"),
    unselectedColor: Color = .gray,
    underlineColor: Color = Color(hex: "#1677ff"),
    backgroundColor: Color = .white,
    dividerColor: Color = Color.gray.opacity(0.2),
    itemSpacing: CGFloat = 0,
    horizontalPadding: CGFloat = 20,
    verticalPadding: CGFloat = 12,
    underlineHeight: CGFloat = 2,
    underlineWidth: TSUnderlineWidth = .ratio(0.5),
    animationDuration: Double = 0.3,
    animationCurve: Animation = .easeInOut
)
```

**参数：** 所有参数都有默认值，可以只定制需要的部分。

**示例：**

```swift
// 只修改颜色
let style = TSTabStyle(
    selectedColor: .red,
    underlineColor: .red
)

// 完全自定义
let style = TSTabStyle(
    selectedFont: .system(size: 18, weight: .bold),
    unselectedFont: .system(size: 16),
    selectedColor: Color(hex: "#FF6B6B"),
    unselectedColor: .gray,
    underlineColor: Color(hex: "#FF6B6B"),
    backgroundColor: .white,
    dividerColor: Color.gray.opacity(0.3),
    itemSpacing: 0,
    horizontalPadding: 24,
    verticalPadding: 14,
    underlineHeight: 3,
    underlineWidth: .ratio(0.6),
    animationDuration: 0.25,
    animationCurve: .spring()
)
```

#### 预设样式

##### .default

默认蓝色风格样式。

```swift
public static let `default`: TSTabStyle
```

**特点：**
- 蓝色主题色 (#1677ff)
- 中等字体粗细
- 下划线宽度为 Tab 项的 50%

**示例：**

```swift
TSStickyTabContainer(...)
    .tabStyle(.default)
```

##### .minimal

简约风格样式。

```swift
public static let minimal: TSTabStyle
```

**特点：**
- 系统主题色
- 统一字体大小
- 全宽下划线
- 无分割线
- 透明背景

**示例：**

```swift
TSStickyTabContainer(...)
    .tabStyle(.minimal)
```

##### .rounded

圆角风格样式。

```swift
public static let rounded: TSTabStyle
```

**特点：**
- 选中时显示圆角背景
- 无下划线
- 白色文字（选中时）
- 紧凑布局

**示例：**

```swift
TSStickyTabContainer(...)
    .tabStyle(.rounded)
```

---

### TSUnderlineWidth

Tab 下划线宽度配置枚举。

#### 枚举值

##### .fixed

固定宽度。

```swift
case fixed(CGFloat)
```

**参数：**
- `CGFloat`: 固定的宽度值（点）

**示例：**

```swift
let style = TSTabStyle(
    underlineWidth: .fixed(40)
)
```

##### .ratio

相对于 Tab 项宽度的比例。

```swift
case ratio(CGFloat)
```

**参数：**
- `CGFloat`: 相对比例（0.0 - 1.0）

**示例：**

```swift
let style = TSTabStyle(
    underlineWidth: .ratio(0.7)  // 70% 的 Tab 项宽度
)
```

---

## 扩展工具

### Color+Hex

为 SwiftUI Color 添加 16 进制字符串初始化支持。

#### 初始化方法

```swift
public init(hex: String)
```

**参数：**
- `hex`: 16 进制颜色字符串

**支持格式：**
- `#1677ff` - 标准 RGB（带 # 前缀）
- `1677ff` - 标准 RGB（不带 # 前缀）
- `#fff` - 短格式 RGB
- `#1677ffff` - 带透明度的 ARGB

**示例：**

```swift
let color1 = Color(hex: "#1677ff")
let color2 = Color(hex: "1677ff")
let color3 = Color(hex: "#fff")
let color4 = Color(hex: "#80FF6B6B")  // 50% 透明度的红色
```

---

## 最佳实践

### 1. 状态管理

使用 `@State` 或 `@StateObject` 管理选中索引：

```swift
struct ContentView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: ["Tab 1", "Tab 2"],
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                // ...
            }
        )
    }
}
```

### 2. 数据加载

在 `onTabChanged` 回调中加载数据：

```swift
TSStickyTabContainer(...)
    .onTabChanged { _, newIndex in
        Task {
            await loadData(for: newIndex)
        }
    }
```

### 3. 性能优化

对于大量数据，使用懒加载和分页：

```swift
pageContent: { tab, index in
    LazyVStack {
        ForEach(viewModel.items) { item in
            ItemRow(item: item)
                .onAppear {
                    // 滚动到底部时加载更多
                    if item == viewModel.items.last {
                        Task {
                            await viewModel.loadMore()
                        }
                    }
                }
        }
    }
}
```

### 4. 样式复用

定义全局样式配置：

```swift
extension TSTabStyle {
    static let myAppStyle = TSTabStyle(
        selectedColor: Color(hex: "#FF6B6B"),
        underlineColor: Color(hex: "#FF6B6B"),
        horizontalPadding: 24
    )
}

// 使用
TSStickyTabContainer(...)
    .tabStyle(.myAppStyle)
```

---

## 常见问题

### Q: 如何隐藏分割线？

A: 设置 `dividerColor` 为 `.clear`：

```swift
let style = TSTabStyle(
    dividerColor: .clear
)
```

### Q: 如何让下划线占满整个 Tab 项？

A: 使用 `.ratio(1.0)`：

```swift
let style = TSTabStyle(
    underlineWidth: .ratio(1.0)
)
```

### Q: 如何实现无下划线的 Tab？

A: 设置 `underlineHeight` 为 0：

```swift
let style = TSTabStyle(
    underlineHeight: 0
)
```

### Q: 如何获取当前选中的 Tab？

A: 使用绑定的 `selectedIndex`：

```swift
@State private var selectedIndex = 0

var body: some View {
    VStack {
        Text("当前选中: \(tabs[selectedIndex])")
        
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                // ...
            }
        )
    }
}
```

### Q: 如何在代码中切换 Tab？

A: 直接修改绑定的 `selectedIndex`：

```swift
Button("切换到第二个 Tab") {
    selectedIndex = 1
}
```

---

## 更新日志

查看 [README.md](README.md) 中的版本历史部分。
