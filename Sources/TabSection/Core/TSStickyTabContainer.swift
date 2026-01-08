//
//  TSStickyTabContainer.swift
//  TabSection
//
//  Created by jxing on 2026/1/8.
//

import SwiftUI

/// 吸顶 Tab 容器视图
/// 提供标签栏吸顶、多分页内容管理功能
@available(iOS 15.0, *)
public struct TSStickyTabContainer<HeaderContent: View, PageContent: View>: View {
    /// 标签数据数组
    let tabs: [String]
    /// 当前选中的标签索引
    @Binding var selectedIndex: Int
    /// Tab 样式配置
    var tabStyle: TSTabStyle
    /// 是否启用懒加载
    var enableLazyLoading: Bool
    /// Tab 切换回调
    var onTabChanged: ((Int, Int) -> Void)?
    /// 刷新回调
    var onRefresh: (() async -> Void)?
    /// 头部内容构建器
    let headerContent: (() -> HeaderContent)?
    /// 页面内容构建器
    let pageContent: (String, Int) -> PageContent
    
    /// 内部状态：上一次选中的索引，用于 onTabChanged 回调
    @State private var previousIndex: Int = 0
    
    /// 初始化方法（带头部内容）
    /// - Parameters:
    ///   - tabs: 标签数据数组
    ///   - selectedIndex: 当前选中的标签索引
    ///   - tabStyle: Tab 样式配置
    ///   - headerContent: 头部内容构建器
    ///   - pageContent: 页面内容构建器，接收当前标签名称和索引
    public init(
        tabs: [String],
        selectedIndex: Binding<Int>,
        tabStyle: TSTabStyle = .default,
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        @ViewBuilder pageContent: @escaping (String, Int) -> PageContent
    ) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.tabStyle = tabStyle
        self.enableLazyLoading = true
        self.headerContent = headerContent
        self.pageContent = pageContent
        self._previousIndex = State(initialValue: selectedIndex.wrappedValue)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    // 头部内容区域
                    if let headerContent = headerContent {
                        Section {
                            headerContent()
                        }
                    }
                    
                    // Tab 区域
                    Section {
                        pageContent(tabs[selectedIndex], selectedIndex)
                            .frame(minHeight: geometry.size.height - 50) // 确保内容至少占满屏幕
                    } header: {
                        VStack(spacing: 0) {
                            // 顶部分割线
                            Divider()
                                .background(tabStyle.dividerColor)
                            
                            TSTabsView(
                                tabs: tabs,
                                currentSelect: $selectedIndex,
                                style: tabStyle
                            )
                            
                            // 底部分割线
                            Divider()
                                .background(tabStyle.dividerColor)
                        }
                    }
                }
                .id("ts-container-\(selectedIndex)") // 强制重建视图，确保内容正确更新
            }
            .modifier(RefreshableModifier(onRefresh: onRefresh))
            .onChange(of: selectedIndex) { newValue in
                // 触发 Tab 切换回调
                if let onTabChanged = onTabChanged {
                    onTabChanged(previousIndex, newValue)
                }
                previousIndex = newValue
            }
        }
    }
}

// MARK: - 不带头部内容的便捷初始化方法

@available(iOS 15.0, *)
extension TSStickyTabContainer where HeaderContent == EmptyView {
    /// 初始化方法（不带头部内容）
    /// - Parameters:
    ///   - tabs: 标签数据数组
    ///   - selectedIndex: 当前选中的标签索引
    ///   - tabStyle: Tab 样式配置
    ///   - pageContent: 页面内容构建器，接收当前标签名称和索引
    public init(
        tabs: [String],
        selectedIndex: Binding<Int>,
        tabStyle: TSTabStyle = .default,
        @ViewBuilder pageContent: @escaping (String, Int) -> PageContent
    ) {
        self.tabs = tabs
        self._selectedIndex = selectedIndex
        self.tabStyle = tabStyle
        self.enableLazyLoading = true
        self.headerContent = nil
        self.pageContent = pageContent
        self._previousIndex = State(initialValue: selectedIndex.wrappedValue)
    }
}

// MARK: - 视图修饰符扩展

@available(iOS 15.0, *)
extension TSStickyTabContainer {
    /// 设置 Tab 样式
    /// - Parameter style: Tab 样式配置
    /// - Returns: 修改后的视图
    public func tabStyle(_ style: TSTabStyle) -> TSStickyTabContainer {
        var view = self
        view.tabStyle = style
        return view
    }
    
    /// 设置是否启用懒加载
    /// - Parameter enabled: 是否启用
    /// - Returns: 修改后的视图
    public func enableLazyLoading(_ enabled: Bool) -> TSStickyTabContainer {
        var view = self
        view.enableLazyLoading = enabled
        return view
    }
    
    /// 设置 Tab 切换回调
    /// - Parameter callback: 回调闭包，接收旧索引和新索引
    /// - Returns: 修改后的视图
    public func onTabChanged(_ callback: @escaping (Int, Int) -> Void) -> TSStickyTabContainer {
        var view = self
        view.onTabChanged = callback
        return view
    }
    
    /// 设置下拉刷新回调
    /// - Parameter callback: 刷新回调闭包
    /// - Returns: 修改后的视图
    public func refreshable(_ callback: @escaping () async -> Void) -> TSStickyTabContainer {
        var view = self
        view.onRefresh = callback
        return view
    }
}

// MARK: - 辅助视图修饰符

/// 刷新修饰符，用于支持下拉刷新
@available(iOS 15.0, *)
private struct RefreshableModifier: ViewModifier {
    let onRefresh: (() async -> Void)?
    
    func body(content: Content) -> some View {
        if let onRefresh = onRefresh {
            content.refreshable {
                await onRefresh()
            }
        } else {
            content
        }
    }
}
