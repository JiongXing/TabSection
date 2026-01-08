# Demo 项目更新说明

本文档说明了 Demo 项目为使用 TabSection 框架所做的更改。

## 更新日期

2026-01-08

## 主要更改

### 1. 依赖配置

#### Podfile
- ✅ 添加了 `platform :ios, '15.0'`
- ✅ 添加了本地 TabSection 依赖：`pod 'TabSection', :path => '../'`

**使用方法：**
```bash
cd Demo
pod install
```

### 2. 代码更新

#### ContentView.swift ✅
- 已导入 `import TabSection`
- 使用 `TSStickyTabContainer` 替代手动布局
- 添加了 `.onTabChanged` 回调示例
- 保留完整的功能演示（头部内容、下拉刷新等）

**主要改动：**
```swift
// 原来：手动构建 LazyVStack + Section
GeometryReader { geometry in
    ScrollView {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section { ... } header: { ... }
        }
    }
}

// 现在：使用框架组件
TSStickyTabContainer(
    tabs: tabs,
    selectedIndex: $currentSelect,
    headerContent: { HeaderContentView() },
    pageContent: { tab, index in TabSectionContentView(...) }
)
```

#### TabSectionHeader.swift ✅
- 导入 `import TabSection`
- 将 `TabsView` 改为 `TSTabsView`
- 添加了说明注释

**主要改动：**
```swift
// 原来
TabsView(tabs: tabs, currentSelect: $currentSelect)

// 现在
TSTabsView(tabs: tabs, currentSelect: $currentSelect)
```

#### HeaderContentView.swift ✅
- 导入 `import TabSection`
- 更新标题文字："欢迎使用 TabSection"

#### Color+Hex.swift ✅
- 导入 `import TabSection`
- 添加说明：此扩展已由框架提供
- 保留文件仅供参考，实际可删除

#### 其他视图组件 ✅
- `TabSectionContentView.swift` - 无需修改
- `ContentCardView.swift` - 无需修改
- `EmptyDataView.swift` - 无需修改
- `FeatureButton.swift` - 无需修改

### 3. 新增示例

#### Examples/StyleDemoView.swift ⭐ 新增
全新的样式演示文件，包含：

- **StyleDemoView** - 样式演示导航页
- **DefaultStyleDemo** - 默认样式示例
- **MinimalStyleDemo** - 简约样式示例
- **RoundedStyleDemo** - 圆角样式示例
- **CustomStyleDemo** - 自定义样式示例
- **ContentListView** - 辅助内容列表组件

**特点：**
- 每个样式都是独立的完整示例
- 可以直接复制代码使用
- 包含 Preview 支持

#### Examples/BasicUsageExample.swift ✅
- 已有文件，添加了更详细的注释
- 包含 6 种基础使用场景

### 4. 新增文档

#### Demo/README.md ⭐ 新增
Demo 项目的完整使用说明，包含：

- 项目结构说明
- 运行方法（CocoaPods + SPM）
- 每个示例的详细说明
- 使用技巧
- 常见场景示例
- 故障排除
- 学习路径建议

#### Demo/CHANGES.md ⭐ 新增
本文档，记录所有更改。

## 文件清单

### 已修改的文件

| 文件 | 状态 | 主要更改 |
|------|------|----------|
| `Podfile` | ✅ 已更新 | 添加 TabSection 依赖 |
| `ContentView.swift` | ✅ 已更新 | 使用框架组件 |
| `TabSectionHeader.swift` | ✅ 已更新 | 使用 TSTabsView |
| `HeaderContentView.swift` | ✅ 已更新 | 导入框架 |
| `Color+Hex.swift` | ✅ 已更新 | 添加说明 |
| `BasicUsageExample.swift` | ✅ 已更新 | 完善注释 |

### 新增的文件

| 文件 | 说明 |
|------|------|
| `Examples/StyleDemoView.swift` | 样式演示示例 |
| `Demo/README.md` | Demo 项目文档 |
| `Demo/CHANGES.md` | 本更新说明 |

### 未修改的文件

以下文件无需修改，可以直接使用：

- `TabSectionDemoApp.swift` - 应用入口
- `TabSectionContentView.swift` - 内容视图
- `ContentCardView.swift` - 卡片组件
- `EmptyDataView.swift` - 空数据视图
- `FeatureButton.swift` - 功能按钮
- `RecommendationCard.swift` - 推荐卡片

### 可以删除的文件

使用框架后，以下文件理论上可以删除（但建议保留作为参考）：

- `Component/TabsView.swift` - 已删除（框架提供 TSTabsView）
- `Extension/Color+Hex.swift` - 可删除（框架已提供）

## 迁移前后对比

### 代码量对比

| 项目 | 迁移前 | 迁移后 | 变化 |
|------|--------|--------|------|
| ContentView.swift | ~90 行 | ~82 行 | -8 行 |
| 手动管理组件 | 需要 | 不需要 | 简化 |
| 样式定制 | 修改源码 | 配置对象 | 更灵活 |

### 功能对比

| 功能 | 迁移前 | 迁移后 |
|------|--------|--------|
| Tab 标签栏 | ✅ | ✅ |
| 吸顶效果 | ✅ | ✅ |
| 下拉刷新 | ✅ | ✅ |
| 头部内容 | ✅ | ✅ |
| 样式定制 | ❌ 需修改源码 | ✅ 配置对象 |
| 预设样式 | ❌ | ✅ 3 种 |
| Tab 切换回调 | ⚠️ 手动实现 | ✅ 内置 API |
| 独立 Tab 组件 | ❌ | ✅ |

## 验证清单

完成更新后，请验证以下功能：

- [ ] 项目可以正常编译
- [ ] Tab 标签可以点击切换
- [ ] 选中标签会自动居中
- [ ] 下划线动画流畅
- [ ] 滚动时标签栏会吸顶
- [ ] 下拉刷新可以触发
- [ ] Tab 切换时打印日志
- [ ] 不同标签显示不同数量的内容
- [ ] 空数据标签显示占位视图
- [ ] 预览（Preview）功能正常

## 下一步

### 开发阶段

1. **安装依赖**
```bash
cd Demo
pod install
```

2. **打开项目**
```bash
open TabSectionDemo.xcworkspace
```

3. **运行测试**
选择模拟器，按 `Cmd + R` 运行

### 发布阶段

当框架发布到 GitHub 后，更新 Podfile：

```ruby
# 开发阶段（本地）
pod 'TabSection', :path => '../'

# 发布后（远程）
pod 'TabSection', :git => 'https://github.com/JiongXing/TabSection.git'
# 或
pod 'TabSection', '~> 1.0.0'
```

## 相关文档

- [Demo README](README.md) - Demo 项目使用说明
- [框架 README](../README.md) - 框架功能介绍
- [API 文档](../DOCUMENTATION.md) - 完整 API 参考
- [迁移指南](../MIGRATION.md) - 详细迁移步骤

## 技术支持

如有问题：

1. 查看 [Demo README](README.md) 的故障排除部分
2. 查看 [DOCUMENTATION.md](../DOCUMENTATION.md) 的常见问题
3. 在 GitHub 上提交 Issue

---

更新完成！Demo 项目现在完全使用 TabSection 框架。🎉
