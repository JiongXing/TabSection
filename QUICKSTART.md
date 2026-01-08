# TabSection 快速开始

5 分钟快速集成 TabSection 框架到你的项目。

## 安装

### 方式 1: Swift Package Manager（推荐）

1. 在 Xcode 中打开你的项目
2. 选择 **File** → **Add Package Dependencies...**
3. 输入框架 URL：`https://github.com/YOUR_USERNAME/TabSection.git`
4. 选择版本规则（建议选择 "Up to Next Major Version" 1.0.0）
5. 点击 **Add Package**

### 方式 2: CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'TabSection', '~> 1.0.0'
```

然后运行：

```bash
pod install
```

## 基础使用

### 步骤 1: 导入框架

```swift
import SwiftUI
import TabSection
```

### 步骤 2: 创建视图

```swift
struct ContentView: View {
    // 定义标签
    let tabs = ["推荐", "关注", "最新"]
    
    // 管理选中状态
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                // 每个 Tab 的内容
                Text("这是 \(tab) 页面")
                    .font(.title)
                    .padding()
            }
        )
    }
}
```

### 步骤 3: 运行

按 `Cmd + R` 运行项目，你将看到：

- ✅ 横向可滚动的 Tab 标签栏
- ✅ 点击切换标签
- ✅ 平滑的动画效果
- ✅ 滚动时标签栏会吸顶

## 添加更多功能

### 添加头部内容

```swift
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    headerContent: {
        // 自定义头部（如 Banner、搜索栏等）
        VStack {
            Text("欢迎使用 TabSection")
                .font(.title)
                .padding()
            
            Color.blue.opacity(0.3)
                .frame(height: 200)
        }
    },
    pageContent: { tab, index in
        Text("这是 \(tab) 页面")
    }
)
```

### 添加下拉刷新

```swift
TSStickyTabContainer(...)
    .refreshable {
        // 异步加载数据
        await loadData()
    }
```

### 监听 Tab 切换

```swift
TSStickyTabContainer(...)
    .onTabChanged { oldIndex, newIndex in
        print("从 Tab \(oldIndex) 切换到 Tab \(newIndex)")
        // 在这里加载新页面的数据
    }
```

### 自定义样式

#### 使用预设样式

```swift
TSStickyTabContainer(...)
    .tabStyle(.minimal)  // 简约风格
```

#### 完全自定义

```swift
TSStickyTabContainer(...)
    .tabStyle(TSTabStyle(
        selectedColor: .red,
        underlineColor: .red,
        underlineHeight: 3
    ))
```

## 完整示例

```swift
import SwiftUI
import TabSection

struct ContentView: View {
    let tabs = ["推荐", "关注", "最新", "热门"]
    @State private var selectedIndex = 0
    @State private var items: [String] = []
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            headerContent: {
                HeaderView()
            },
            pageContent: { tab, index in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        )
        .tabStyle(TSTabStyle(
            selectedColor: Color(hex: "#FF6B6B"),
            underlineColor: Color(hex: "#FF6B6B")
        ))
        .refreshable {
            await loadData()
        }
        .onTabChanged { _, newIndex in
            Task {
                await loadData(for: newIndex)
            }
        }
        .onAppear {
            Task {
                await loadData(for: selectedIndex)
            }
        }
    }
    
    private func loadData(for index: Int = 0) async {
        // 模拟网络请求
        try? await Task.sleep(nanoseconds: 500_000_000)
        items = (0..<10).map { "\(tabs[index]) - 内容 \($0 + 1)" }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("TabSection 示例")
                .font(.title)
                .padding()
            
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
        }
    }
}
```

## 样式预览

### 默认样式 (.default)

```swift
.tabStyle(.default)
```

- 蓝色主题
- 中等字体粗细
- 50% 宽度的下划线

### 简约样式 (.minimal)

```swift
.tabStyle(.minimal)
```

- 系统主题色
- 统一字体
- 全宽下划线
- 无分割线

### 圆角样式 (.rounded)

```swift
.tabStyle(.rounded)
```

- 选中时显示圆角背景
- 无下划线
- 白色文字（选中时）

## 常见使用场景

### 新闻资讯类

```swift
let tabs = ["推荐", "热点", "视频", "科技", "娱乐"]
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    pageContent: { tab, index in
        NewsList(category: tab)
    }
)
```

### 个人主页

```swift
let tabs = ["动态", "文章", "收藏", "关注"]
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    headerContent: {
        UserProfileHeader()
    },
    pageContent: { tab, index in
        UserContentList(type: tab)
    }
)
```

### 商品详情

```swift
let tabs = ["详情", "评价", "推荐"]
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $selectedIndex,
    headerContent: {
        ProductImageGallery()
    },
    pageContent: { tab, index in
        ProductInfo(tab: tab)
    }
)
```

## 下一步

- 📖 查看 [README.md](README.md) 了解更多功能
- 📚 查看 [DOCUMENTATION.md](DOCUMENTATION.md) 了解完整 API
- 💡 查看 `Demo` 目录获取更多示例
- 🔄 如果从旧代码迁移，查看 [MIGRATION.md](MIGRATION.md)

## 获取帮助

遇到问题？

1. 查看 [DOCUMENTATION.md](DOCUMENTATION.md) 的常见问题部分
2. 在 GitHub 上搜索已有的 Issues
3. 提交新的 Issue 寻求帮助

---

**开始使用 TabSection，5 分钟打造优雅的多标签页界面！** 🚀
