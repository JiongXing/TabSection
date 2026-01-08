# TabSection

SwiftUI 实现的多标签页滚动吸顶实践项目。

## 📋 项目简介

本项目演示了如何在 SwiftUI 中实现一个包含**多标签页切换**和**标签栏吸顶**功能的滚动视图。主要特性包括：

- ✅ 支持多个标签页内容切换
- ✅ 标签栏滚动时自动吸顶
- ✅ 标签页横向滑动切换
- ✅ 下拉刷新功能
- ✅ 标签切换动画效果
- ✅ 内容高度自适应

## 🏗️ 技术架构

### 整体布局层次

```
GeometryReader (获取容器尺寸)
  └── ScrollView (垂直滚动容器)
       └── LazyVStack (懒加载垂直堆栈，支持吸顶)
            ├── Section 1: HeaderContentView (头部内容)
            └── Section 2: Tab 区域
                 ├── header: TabsView (吸顶标签栏)
                 └── body: TabView (标签页内容区域)
```

### 核心组件说明

#### 1. **ContentView.swift** - 主视图容器
- **职责**：管理整体布局结构和状态
- **关键状态**：
  - `@State currentSelect: Int` - 当前选中的标签索引
  - `@State tabContentHeight: CGFloat` - 标签页内容高度（动态获取）
- **核心实现**：
  - 使用 `LazyVStack` 的 `pinnedViews: [.sectionHeaders]` 实现吸顶效果
  - 通过 `PreferenceKey` 动态获取内容高度
  - 使用 `GeometryReader` 解决 TabView 在 Section 中高度丢失问题

#### 2. **TabsView.swift** - 标签栏组件
- **职责**：显示标签列表，处理标签切换
- **核心特性**：
  - 横向可滚动的标签列表
  - 选中标签自动居中显示
  - 使用 `matchedGeometryEffect` 实现下划线动画
  - 支持点击和外部驱动两种切换方式
- **关键技术点**：
  - `ScrollViewReader` + `scrollProxy.scrollTo()` 实现标签居中
  - `@Namespace` + `matchedGeometryEffect` 实现下划线平滑过渡动画

#### 3. **TabContentView.swift** - 标签页内容组件
- **职责**：显示单个标签页的具体内容
- **核心特性**：
  - 使用 `LazyVStack` 懒加载内容列表
  - 通过 `PreferenceKey` 向上传递内容高度
  - 支持空数据占位视图
- **关键技术点**：
  - 使用 `GeometryReader` 获取内容实际高度
  - 通过 `TabContentHeightKey` 向父视图传递高度值

#### 4. **PreferenceKey 系列** - 数据传递机制

##### TabContentHeightKey
- **用途**：向上传递标签页内容高度
- **实现**：使用 `max()` 取最大值，确保高度足够显示所有内容

##### TabsHeaderHeightKey
- **用途**：传递标签栏高度（预留，当前未使用）

##### ScrollOffsetPreferenceKey
- **用途**：传递滚动偏移量（预留，可用于实现更复杂的滚动效果）

#### 5. **辅助组件**

##### Color+Hex.swift
- **功能**：通过 16 进制字符串初始化 SwiftUI Color
- **支持格式**：`#1677ff`、`1677ff`、`#fff`、`#ffffffff` 等

##### ScrollBounceBehaviorModifier.swift
- **功能**：兼容不同 iOS 版本的滚动弹性行为
- **实现**：iOS 17+ 使用 `.basedOnSize`，低版本保持默认行为

## 🔑 核心技术点

### 1. 吸顶实现原理

使用 SwiftUI 的 `Section` 和 `pinnedViews` 参数：

```swift
LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
    Section {
        // 普通内容
    }
    
    Section {
        // TabView 内容
    } header: {
        // 这个 header 会被吸顶
        TabsView(...)
    }
}
```

当滚动时，Section 的 `header` 会自动固定在顶部。

### 2. 标签页切换机制

使用 `TabView` + `@Binding` 实现双向绑定：

```swift
TabView(selection: $currentSelect) {
    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
        TabContentView(...)
            .tag(index)
    }
}
.tabViewStyle(.page(indexDisplayMode: .never))
```

- `selection: $currentSelect` 绑定当前选中索引
- `.tag(index)` 标识每个标签页
- `.page` 样式支持横向滑动手势切换

### 3. 高度自适应实现

**问题**：TabView 在 Section 中可能丢失高度信息

**解决方案**：
1. 使用 `GeometryReader` 包裹 TabView 获取尺寸
2. 在 `TabContentView` 中使用 `PreferenceKey` 传递实际内容高度
3. 在父视图中监听高度变化，动态设置 `frame(height:)`

```swift
// 在 TabContentView 中传递高度
.background(
    GeometryReader { geometry in
        Color.clear
            .preference(
                key: TabContentHeightKey.self,
                value: geometry.size.height
            )
    }
)

// 在 ContentView 中接收高度
.onPreferenceChange(TabContentHeightKey.self) { height in
    tabContentHeight = height
}
.frame(height: tabContentHeight > 0 ? tabContentHeight : geometry.size.height)
```

### 4. 标签切换动画

使用 `matchedGeometryEffect` 实现下划线的平滑移动：

```swift
@Namespace private var namespace

// 选中标签的下划线
if isSelected {
    Rectangle()
        .matchedGeometryEffect(id: "underline", in: namespace)
}
```

当 `currentSelect` 改变时，下划线会平滑过渡到新选中的标签下方。

### 5. 标签自动居中

使用 `ScrollViewReader` 实现选中标签自动滚动到中心：

```swift
ScrollViewReader { scrollProxy in
    ScrollView(.horizontal) {
        // 标签列表
    }
    .onChange(of: currentSelect) { newValue in
        withAnimation {
            scrollProxy.scrollTo(newValue, anchor: .center)
        }
    }
}
```

## 📁 项目结构

```
TabSectionDemo/
├── TabSectionDemo/
│   ├── Component/
│   │   └── TabsView.swift              # 标签栏组件
│   ├── View/
│   │   ├── TabContentView.swift        # 标签页内容组件
│   │   ├── TabContentHeightKey.swift   # 内容高度 PreferenceKey
│   │   ├── TabsHeaderHeightKey.swift   # 标签栏高度 PreferenceKey
│   │   ├── ScrollOffsetPreferenceKey.swift  # 滚动偏移 PreferenceKey
│   │   └── ScrollBounceBehaviorModifier.swift  # 滚动弹性行为修饰符
│   ├── Extension/
│   │   └── Color+Hex.swift             # Color 扩展（16进制初始化）
│   ├── ContentView.swift               # 主视图
│   └── TabSectionDemoApp.swift         # App 入口
```

## 🚀 使用方法

### 基本使用

```swift
struct ContentView: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var currentSelect: Int = 0
    @State private var tabContentHeight: CGFloat = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                // 头部内容
                Section {
                    HeaderView()
                }
                
                // Tab 区域
                Section {
                    GeometryReader { _ in
                        TabView(selection: $currentSelect) {
                            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                                TabContentView(title: tab, items: [])
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .frame(height: tabContentHeight > 0 ? tabContentHeight : 500)
                } header: {
                    TabsView(tabs: tabs, currentSelect: $currentSelect)
                }
            }
        }
    }
}
```

## 🎯 技术要点总结

1. **吸顶效果**：通过 `LazyVStack` 的 `pinnedViews` 参数实现
2. **状态管理**：使用 `@State` 和 `@Binding` 实现父子组件状态同步
3. **数据传递**：使用 `PreferenceKey` 机制向上传递尺寸信息
4. **动画效果**：使用 `matchedGeometryEffect` 实现平滑过渡动画
5. **高度自适应**：通过 `GeometryReader` + `PreferenceKey` 动态计算内容高度

## 📝 注意事项

1. **TabView 高度问题**：TabView 在嵌套结构中可能丢失高度，需要使用 `GeometryReader` + `PreferenceKey` 解决
2. **性能优化**：使用 `LazyVStack` 和 `LazyVStack` 进行懒加载，避免一次性渲染大量内容
3. **iOS 版本兼容**：部分 API 需要 iOS 17+，低版本需要做兼容处理（如 `ScrollBounceBehaviorModifier`）

## 📄 许可证

详见 LICENSE 文件
