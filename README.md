# TabSection

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2015.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)](https://cocoapods.org)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

SwiftUI 实现的多标签页滚动吸顶组件库。提供优雅的 Tab 标签栏组件、Section 吸顶效果和多分页列表管理能力。

<p align="center">
  <img src="https://via.placeholder.com/800x400/1677ff/ffffff?text=TabSection+Demo" alt="TabSection Demo" width="800"/>
</p>

## ✨ 特性

- ✅ **Tab 标签栏组件** - 横向可滚动，选中标签自动居中，流畅的动画效果
- ✅ **吸顶效果** - 标签栏滚动时自动固定在顶部
- ✅ **多分页管理** - 支持多个标签页内容切换，内容高度自适应
- ✅ **下拉刷新** - 内置下拉刷新支持
- ✅ **样式定制** - 提供预设样式和完全自定义能力
- ✅ **懒加载优化** - 使用 LazyVStack 提升性能
- ✅ **开箱即用** - 简洁的 API，5 分钟快速集成

## 📋 要求

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## 📦 安装

### Swift Package Manager

在 Xcode 中：

1. 选择 **File** → **Add Package Dependencies...**
2. 输入仓库 URL：`https://github.com/YOUR_USERNAME/TabSection.git`
3. 选择版本规则，点击 **Add Package**

或者在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/TabSection.git", from: "1.0.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'TabSection', '~> 1.0.0'
```

然后运行：

```bash
pod install
```

## 🚀 快速开始

### 基础使用

```swift
import SwiftUI
import TabSection

struct ContentView: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                // 每个 Tab 的内容
                Text("这是 \(tab) 页面")
                    .font(.title)
            }
        )
    }
}
```

### 带头部内容

```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    headerContent: {
        // 自定义头部内容（如 Banner、搜索栏等）
        HeaderView()
    },
    pageContent: { tab, index in
        // 标签页内容
        ContentView(tab: tab)
    }
)
```

### 下拉刷新

```swift
TSStickyTabContainer(...)
    .refreshable {
        await loadData()
    }
```

### Tab 切换回调

```swift
TSStickyTabContainer(...)
    .onTabChanged { oldIndex, newIndex in
        print("从 Tab \(oldIndex) 切换到 Tab \(newIndex)")
        // 可以在这里加载新页面的数据
    }
```

## 🎨 样式定制

### 预设样式

TabSection 提供三种预设样式：

```swift
// 默认蓝色风格
TSStickyTabContainer(...)
    .tabStyle(.default)

// 简约风格
TSStickyTabContainer(...)
    .tabStyle(.minimal)

// 圆角风格
TSStickyTabContainer(...)
    .tabStyle(.rounded)
```

### 完全自定义

```swift
let customStyle = TSTabStyle(
    // 字体配置
    selectedFont: .system(size: 16, weight: .semibold),
    unselectedFont: .system(size: 14, weight: .regular),
    
    // 颜色配置
    selectedColor: Color(hex: "#FF6B6B"),
    unselectedColor: .gray,
    underlineColor: Color(hex: "#FF6B6B"),
    backgroundColor: .white,
    dividerColor: Color.gray.opacity(0.2),
    
    // 布局配置
    itemSpacing: 24,
    horizontalPadding: 20,
    verticalPadding: 12,
    underlineHeight: 3,
    underlineWidth: .ratio(0.5), // 或 .fixed(30)
    
    // 动画配置
    animationDuration: 0.3,
    animationCurve: .easeInOut
)

TSStickyTabContainer(...)
    .tabStyle(customStyle)
```

## 📚 核心组件

### TSStickyTabContainer

主容器组件，负责管理整体布局和吸顶效果。

**初始化参数：**

- `tabs: [String]` - 标签数据数组
- `selectedIndex: Binding<Int>` - 当前选中的标签索引
- `tabStyle: TSTabStyle` - Tab 样式配置（可选）
- `headerContent: () -> HeaderContent` - 头部内容构建器（可选）
- `pageContent: (String, Int) -> PageContent` - 页面内容构建器

**可用修饰符：**

- `.tabStyle(_ style: TSTabStyle)` - 设置 Tab 样式
- `.refreshable(_ callback: () async -> Void)` - 设置下拉刷新回调
- `.onTabChanged(_ callback: (Int, Int) -> Void)` - 设置 Tab 切换回调
- `.enableLazyLoading(_ enabled: Bool)` - 设置是否启用懒加载（默认开启）

### TSTabsView

Tab 标签栏组件，可以单独使用。

```swift
TSTabsView(
    tabs: tabs,
    currentSelect: $selectedIndex,
    style: .default
)
```

### TSTabStyle

Tab 样式配置结构体，支持完全自定义。

**预设样式：**

- `.default` - 默认蓝色风格
- `.minimal` - 简约风格
- `.rounded` - 圆角风格

## 🏗️ 技术实现

### 吸顶效果

使用 SwiftUI 的 `LazyVStack` 和 `pinnedViews` 参数实现：

```swift
LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
    Section {
        // 内容区域
    } header: {
        // 这个 header 会被吸顶
        TSTabsView(...)
    }
}
```

### 标签切换动画

使用 `matchedGeometryEffect` 实现下划线的平滑移动：

```swift
@Namespace private var namespace

Rectangle()
    .matchedGeometryEffect(id: "underline", in: namespace)
```

### 自动居中

使用 `ScrollViewReader` 实现选中标签自动滚动到中心：

```swift
ScrollViewReader { scrollProxy in
    // ...
    scrollProxy.scrollTo(index, anchor: .center)
}
```

## 📖 完整示例

查看 `Demo` 目录获取完整的示例项目，包含：

- **ContentView.swift** - 基础使用示例
- **Examples/BasicUsageExample.swift** - 多种使用场景示例
  - 基础使用
  - 带头部内容
  - 自定义样式
  - 预设样式切换
  - 下拉刷新
  - Tab 切换回调

运行 Demo：

```bash
cd Demo
open TabSectionDemo.xcodeproj
```

## 🔧 高级用法

### 动态内容

```swift
struct DynamicContentView: View {
    @State private var tabs = ["Tab 1", "Tab 2"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                ContentListView(items: loadItems(for: index))
            }
        )
        .onTabChanged { oldIndex, newIndex in
            // 切换时加载新数据
            loadDataForTab(newIndex)
        }
    }
    
    private func loadItems(for index: Int) -> [Item] {
        // TODO: 加载数据
        []
    }
    
    private func loadDataForTab(_ index: Int) {
        // TODO: 加载数据
    }
}
```

### 网络数据加载

```swift
struct NetworkContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TSStickyTabContainer(
            tabs: viewModel.tabs,
            selectedIndex: $viewModel.selectedIndex,
            pageContent: { tab, index in
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.items) { item in
                        ItemRow(item: item)
                    }
                }
            }
        )
        .refreshable {
            await viewModel.refresh()
        }
        .onTabChanged { _, newIndex in
            Task {
                await viewModel.loadData(for: newIndex)
            }
        }
    }
}
```

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 📝 版本历史

### 1.0.0 (2026-01-08)

- ✨ 初始版本发布
- ✨ 提供 TSStickyTabContainer 核心组件
- ✨ 提供 TSTabsView 标签栏组件
- ✨ 支持三种预设样式
- ✨ 支持完全自定义样式
- ✨ 支持下拉刷新
- ✨ 支持 Tab 切换回调

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 👨‍💻 作者

**jxing**

如有问题或建议，欢迎提交 Issue 或 Pull Request。

## 🙏 致谢

感谢所有为本项目做出贡献的开发者。

---

**如果这个项目对你有帮助，请给一个 ⭐️ Star 支持一下！**
