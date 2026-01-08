# TabSection

SwiftUI 实现的多标签页滚动吸顶实践项目。

## 📋 项目简介

本项目演示了如何在 SwiftUI 中实现一个包含**多标签页切换**和**标签栏吸顶**功能的滚动视图。主要特性包括：

- ✅ 支持多个标签页内容切换（点击标签切换）
- ✅ 标签栏滚动时自动吸顶
- ✅ 标签横向可滚动，选中标签自动居中
- ✅ 下拉刷新功能
- ✅ 标签切换动画效果（下划线平滑过渡）
- ✅ 内容高度自适应
- ✅ 组件化设计，代码结构清晰

## 🏗️ 技术架构

### 整体布局层次

```
GeometryReader (获取容器尺寸)
  └── ScrollView (垂直滚动容器)
       └── LazyVStack (懒加载垂直堆栈，支持吸顶)
            ├── Section 1: HeaderContentView (头部内容)
            └── Section 2: Tab 区域
                 ├── header: TabSectionHeader (吸顶标签栏容器)
                 │    └── TabsView (标签栏组件)
                 └── body: TabSectionContentView (标签页内容区域)
                      └── LazyVStack (内容列表，根据当前选中标签动态渲染)
```

### 核心组件说明

#### 1. **ContentView.swift** - 主视图容器
- **职责**：管理整体布局结构和状态
- **关键状态**：
  - `@State currentSelect: Int` - 当前选中的标签索引
- **核心实现**：
  - 使用 `LazyVStack` 的 `pinnedViews: [.sectionHeaders]` 实现吸顶效果
  - 通过 `.id()` 修饰符强制重建视图，实现标签切换时的内容刷新
  - 直接根据 `currentSelect` 渲染对应的内容，无需 TabView
  - 支持下拉刷新功能（`refreshable`）

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

#### 3. **TabSectionContentView.swift** - 标签页内容组件
- **职责**：显示当前选中标签页的具体内容
- **核心特性**：
  - 使用 `LazyVStack` 懒加载内容列表
  - 根据传入的 `items` 动态渲染内容卡片
  - 支持空数据占位视图（`EmptyDataView`）
- **关键技术点**：
  - 父视图通过 `.id()` 修饰符强制重建，确保切换标签时内容正确更新
  - 使用 `ForEach` 遍历内容项，渲染 `ContentCardView`

#### 4. **TabSectionHeader.swift** - Tab 区域头部视图
- **职责**：包装标签栏组件，提供分割线样式
- **核心特性**：
  - 包含顶部分割线和底部分割线
  - 内部使用 `TabsView` 组件显示标签栏
  - 作为 Section 的 `header`，实现吸顶效果

#### 5. **HeaderContentView.swift** - 头部内容视图
- **职责**：显示页面头部区域内容
- **核心特性**：
  - Banner 区域（渐变背景）
  - 搜索栏区域
  - 功能入口区域（使用 `FeatureButton` 组件）

#### 6. **辅助视图组件**

##### ContentCardView.swift
- **功能**：内容卡片视图，显示单个内容项
- **特性**：标题、描述文本、卡片样式

##### EmptyDataView.swift
- **功能**：空数据占位视图
- **特性**：图标、提示文字，用于无数据时的友好提示

##### FeatureButton.swift
- **功能**：功能入口按钮组件
- **特性**：图标、标题、可自定义颜色

##### RecommendationCard.swift
- **功能**：推荐内容卡片（预留，当前未使用）

#### 7. **扩展和工具组件**

##### Color+Hex.swift
- **功能**：通过 16 进制字符串初始化 SwiftUI Color
- **支持格式**：`#1677ff`、`1677ff`、`#fff`、`#ffffffff` 等

## 🔑 核心技术点

### 1. 吸顶实现原理

使用 SwiftUI 的 `Section` 和 `pinnedViews` 参数：

```swift
LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
    Section {
        // 头部内容（如 HeaderContentView）
    }
    
    Section {
        // Tab 内容区域（如 TabSectionContentView）
    } header: {
        // 这个 header 会被吸顶（如 TabSectionHeader）
        TabSectionHeader(...)
    }
}
```

当滚动时，Section 的 `header` 会自动固定在顶部。

### 2. 标签页切换机制

使用 `.id()` 修饰符强制重建视图，实现内容切换：

```swift
Section {
    TabSectionContentView(
        tab: tabs[currentSelect],
        items: generateContentItems(for: tabs[currentSelect])
    )
} header: {
    TabSectionHeader(tabs: tabs, currentSelect: $currentSelect)
}
```

- 当 `currentSelect` 改变时，LazyVStack 的 `.id()` 会改变
- SwiftUI 检测到 id 变化，会完全重建整个 LazyVStack
- 新的 `TabSectionContentView` 会渲染对应标签的内容
- 这种方式比 TabView 更灵活，适合内容高度差异较大的场景

### 3. 内容更新机制

**实现方式**：使用 `.id()` 修饰符强制视图重建

当切换标签时，通过改变 LazyVStack 的 id，SwiftUI 会完全重建整个视图树：

```swift
LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
    Section {
        HeaderContentView()
    }
    
    Section {
        TabSectionContentView(
            tab: tabs[currentSelect],
            items: generateContentItems(for: tabs[currentSelect])
        )
    } header: {
        TabSectionHeader(tabs: tabs, currentSelect: $currentSelect)
    }
}
.id("lazy-vstack-\(currentSelect)") // 关键：id 随 currentSelect 变化，强制重建
```

**优势**：
- 简单直接，不需要复杂的高度计算
- 每次切换都会完全刷新，避免状态残留
- 内容高度自动适应，无需手动管理

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
│   │   └── TabsView.swift                    # 标签栏组件
│   ├── View/
│   │   ├── HeaderContentView.swift           # 头部内容视图
│   │   ├── TabSectionHeader.swift            # Tab 区域头部视图（吸顶标签栏）
│   │   ├── TabSectionContentView.swift       # Tab 区域内容视图
│   │   ├── ContentCardView.swift             # 内容卡片视图
│   │   ├── EmptyDataView.swift               # 空数据占位视图
│   │   ├── FeatureButton.swift               # 功能按钮组件
│   │   └── RecommendationCard.swift          # 推荐内容卡片（预留）
│   ├── Extension/
│   │   └── Color+Hex.swift                   # Color 扩展（16进制初始化）
│   ├── ContentView.swift                     # 主视图
│   └── TabSectionDemoApp.swift               # App 入口
```

## 🚀 使用方法

### 基本使用

```swift
struct ContentView: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var currentSelect: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    // 头部内容
                    Section {
                        HeaderContentView()
                    }
                    
                    // Tab 区域
                    Section {
                        TabSectionContentView(
                            tab: tabs[currentSelect],
                            items: generateContentItems(for: tabs[currentSelect])
                        )
                    } header: {
                        TabSectionHeader(
                            tabs: tabs,
                            currentSelect: $currentSelect
                        )
                    }
                }
                .id("lazy-vstack-\(currentSelect)")
            }
            .refreshable {
                await refreshData()
            }
        }
    }
    
    private func generateContentItems(for tab: String) -> [String] {
        // 根据标签生成对应的内容项
        // ...
    }
    
    private func refreshData() async {
        // 下拉刷新逻辑
        // ...
    }
}
```

## 🎯 技术要点总结

1. **吸顶效果**：通过 `LazyVStack` 的 `pinnedViews: [.sectionHeaders]` 参数实现
2. **状态管理**：使用 `@State` 和 `@Binding` 实现父子组件状态同步
3. **视图更新**：使用 `.id()` 修饰符强制重建视图，实现标签切换时的内容刷新
4. **动画效果**：使用 `matchedGeometryEffect` 实现标签下划线的平滑过渡动画
5. **懒加载**：使用 `LazyVStack` 实现内容的懒加载，提升性能
6. **组件化**：每个视图组件独立文件，职责清晰，便于维护

## 📝 注意事项

1. **视图重建机制**：使用 `.id()` 修饰符时，需要确保 id 唯一且随状态变化，否则可能导致视图不更新
2. **性能优化**：使用 `LazyVStack` 进行懒加载，避免一次性渲染大量内容；标签切换时会重建整个 LazyVStack，对于内容较多的场景需要考虑性能影响
3. **代码组织**：项目采用组件化设计，每个视图组件都有独立的文件，遵循单一职责原则，便于维护和复用
4. **iOS 版本兼容**：主要功能基于 SwiftUI 基础 API，兼容性较好

## 📄 许可证

详见 LICENSE 文件
