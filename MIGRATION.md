# 迁移指南

本文档帮助你将现有的 TabSectionDemo 代码迁移到使用 TabSection 框架。

## 概述

TabSection 框架将原 Demo 项目的核心功能抽取为独立的开源库，提供更简洁的 API 和更强大的定制能力。

## 主要变化

### 1. 组件重命名

| 原组件名 | 新组件名 | 说明 |
|---------|---------|------|
| `TabsView` | `TSTabsView` | Tab 标签栏组件 |
| `TabSectionHeader` | 已整合到 `TSStickyTabContainer` | 不再需要单独使用 |
| `TabSectionContentView` | 由 `pageContent` 闭包替代 | 更灵活的内容定制 |
| 无对应组件 | `TSStickyTabContainer` | 新增的主容器组件 |

### 2. 包名变化

```swift
// 原来
import SwiftUI

// 现在
import SwiftUI
import TabSection  // 新增
```

### 3. API 变化

#### 原来的实现

```swift
struct ContentView: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var currentSelect: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    // 头部内容区域
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
}
```

#### 现在的实现

```swift
import TabSection

struct ContentView: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var currentSelect: Int = 0
    
    var body: some View {
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
    }
}
```

## 详细迁移步骤

### 步骤 1: 安装框架

#### Swift Package Manager

在 Xcode 中：
1. **File** → **Add Package Dependencies...**
2. 输入框架 URL
3. 选择版本并添加

#### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'TabSection', '~> 1.0.0'
```

### 步骤 2: 导入框架

在使用 TabSection 的文件顶部添加导入语句：

```swift
import TabSection
```

### 步骤 3: 替换组件

#### 3.1 替换 TabsView

**原来：**

```swift
TabsView(
    tabs: tabs,
    currentSelect: $currentSelect
)
```

**现在：**

```swift
TSTabsView(
    tabs: tabs,
    currentSelect: $currentSelect,
    style: .default  // 可选的样式配置
)
```

#### 3.2 替换整体结构

**原来：**

```swift
GeometryReader { geometry in
    ScrollView {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section {
                HeaderContentView()
            }
            
            Section {
                // 内容
            } header: {
                TabSectionHeader(tabs: tabs, currentSelect: $currentSelect)
            }
        }
        .id("lazy-vstack-\(currentSelect)")
    }
}
```

**现在：**

```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $currentSelect,
    headerContent: {
        HeaderContentView()
    },
    pageContent: { tab, index in
        // 内容
    }
)
```

### 步骤 4: 迁移样式配置

如果你自定义了 Tab 样式，可以使用 `TSTabStyle`：

**原来：** 直接修改 TabsView 内部代码

**现在：** 使用配置对象

```swift
let customStyle = TSTabStyle(
    selectedFont: .system(size: 16, weight: .medium),
    selectedColor: Color(hex: "#1677ff"),
    underlineColor: Color(hex: "#1677ff"),
    horizontalPadding: 20,
    underlineHeight: 2
)

TSStickyTabContainer(...)
    .tabStyle(customStyle)
```

### 步骤 5: 删除旧组件

迁移完成后，可以删除以下旧文件：

- `Component/TabsView.swift` - 已被 `TSTabsView` 替代
- `View/TabSectionHeader.swift` - 已整合到框架
- `View/TabSectionContentView.swift` - 已由 `pageContent` 闭包替代
- `Extension/Color+Hex.swift` - 框架已包含（如果没有其他用途）

**注意：** 如果你的项目中还有其他地方使用这些组件，请谨慎删除。

## 功能对比

### 原 Demo 功能

- ✅ Tab 标签栏
- ✅ 吸顶效果
- ✅ 标签切换
- ✅ 下拉刷新
- ✅ 自定义头部内容
- ✅ 内容高度自适应

### 框架新增功能

- ✨ **样式系统** - 预设样式和完全自定义
- ✨ **Tab 切换回调** - `.onTabChanged { ... }`
- ✨ **懒加载控制** - `.enableLazyLoading(...)`
- ✨ **链式 API** - 更流畅的代码风格
- ✨ **独立 Tab 组件** - `TSTabsView` 可单独使用
- ✨ **完善的文档** - API 文档和示例

## 示例对比

### 示例 1: 基础使用

#### 原来

```swift
struct ContentView: View {
    let tabs = ["Tab 1", "Tab 2"]
    @State private var currentSelect = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    Text("内容")
                } header: {
                    VStack(spacing: 0) {
                        Divider()
                        TabsView(tabs: tabs, currentSelect: $currentSelect)
                        Divider()
                    }
                }
            }
        }
    }
}
```

#### 现在

```swift
import TabSection

struct ContentView: View {
    let tabs = ["Tab 1", "Tab 2"]
    @State private var currentSelect = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $currentSelect,
            pageContent: { tab, index in
                Text("内容")
            }
        )
    }
}
```

**优势：** 代码量减少 50%，结构更清晰

### 示例 2: 样式定制

#### 原来

需要修改 `TabsView.swift` 源码：

```swift
// 在 TabsView.swift 中修改
.foregroundColor(isSelected ? Color(hex: "#1677ff") : .gray)
```

#### 现在

使用配置对象，无需修改源码：

```swift
TSStickyTabContainer(...)
    .tabStyle(TSTabStyle(
        selectedColor: Color(hex: "#FF6B6B"),
        underlineColor: Color(hex: "#FF6B6B")
    ))
```

**优势：** 无需修改源码，支持多种样式并存

### 示例 3: Tab 切换监听

#### 原来

需要手动在 ContentView 中监听 `currentSelect` 变化：

```swift
var body: some View {
    // ...
    .onChange(of: currentSelect) { newValue in
        print("切换到 \(newValue)")
    }
}
```

#### 现在

使用内置的回调：

```swift
TSStickyTabContainer(...)
    .onTabChanged { oldIndex, newIndex in
        print("从 \(oldIndex) 切换到 \(newIndex)")
    }
```

**优势：** API 更清晰，同时提供旧索引和新索引

## 常见迁移问题

### Q1: 迁移后 Tab 没有显示？

**原因：** 可能忘记导入框架。

**解决：** 确保在文件顶部添加 `import TabSection`。

### Q2: 样式和原来不一样？

**原因：** 框架使用默认样式，可能与你自定义的不同。

**解决：** 创建自定义 `TSTabStyle` 并应用：

```swift
let style = TSTabStyle(
    selectedColor: Color(hex: "#1677ff"),
    // ... 其他配置
)

TSStickyTabContainer(...)
    .tabStyle(style)
```

### Q3: 如何保持原来的行为？

**解决：** 参考 Demo 中的实现，框架提供了相同的功能：

```swift
// 原 Demo 的完整实现
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $currentSelect,
    tabStyle: .default,  // 使用默认样式
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
```

### Q4: 迁移后编译错误？

**常见错误：**

1. **'TabsView' cannot be found in scope**
   - 解决：改为 `TSTabsView` 并导入框架

2. **'Color' initializer 'init(hex:)' requires that 'Color' conform to 'StringProtocol'**
   - 解决：确保导入了 `TabSection`，框架提供了 `Color(hex:)` 扩展

3. **Value of type 'TSStickyTabContainer' has no member 'id'**
   - 解决：不再需要手动添加 `.id()`，框架内部已处理

## 迁移检查清单

完成迁移后，请检查以下项目：

- [ ] 已安装 TabSection 框架
- [ ] 所有使用 Tab 组件的文件已导入 `import TabSection`
- [ ] 已将 `TabsView` 替换为 `TSTabsView`
- [ ] 已使用 `TSStickyTabContainer` 替换手动布局
- [ ] 自定义样式已迁移到 `TSTabStyle`
- [ ] 下拉刷新功能正常工作
- [ ] Tab 切换动画流畅
- [ ] 吸顶效果正常
- [ ] 已删除不再使用的旧组件文件（可选）
- [ ] 已测试所有 Tab 页面
- [ ] 已在真机上测试（如果需要）

## 获取帮助

如果在迁移过程中遇到问题：

1. 查看 [README.md](README.md) 快速开始部分
2. 查看 [DOCUMENTATION.md](DOCUMENTATION.md) API 文档
3. 参考 `Demo` 目录中的示例代码
4. 在 GitHub 上提交 Issue

---

迁移愉快！如有任何问题欢迎反馈。
