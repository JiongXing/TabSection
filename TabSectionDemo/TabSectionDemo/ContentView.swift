//
//  ContentView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

struct ContentView: View {
    /// 标签数据
    let tabs = ["推荐", "关注", "最新", "热门", "视频", "科技", "娱乐", "体育"]
    /// 当前选中的标签索引
    @State private var currentSelect: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    // 头部内容区域（用于测试吸顶效果）
                    Section {
                        HeaderContentView()
                    }
                    
                    // Tab 组件作为 Section Header，实现吸顶效果
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
                .id("lazy-vstack-\(currentSelect)") // 为整个LazyVStack设置唯一id，确保内容完全刷新
            }
            .refreshable {
                // 下拉刷新功能
                await refreshData()
            }
        }
    }
    
    /// 生成内容项（用于演示）
    /// 为不同的 Tab 设置不同数量的列表卡片，用于测试高度变化
    private func generateContentItems(for tab: String) -> [String] {
        // 根据标签名称设置不同的内容数量，用于测试高度自适应
        let count: Int
        switch tab {
        case "推荐":
            count = 3  // 少量内容
        case "关注":
            count = 0
        case "最新":
            count = 10 // 中等内容
        case "热门":
            count = 15
        case "视频":
            count = 2  // 最少内容
        case "科技":
            count = 8
        case "娱乐":
            count = 20 // 大量内容，测试高度变化
        case "体育":
            count = 6
        default:
            count = 0  // 默认值
        }
        return (0..<count).map { "\(tab) - 内容 \($0 + 1)" }
    }
    
    /// 下拉刷新数据
    private func refreshData() async {
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        // 这里可以添加实际的数据刷新逻辑
    }
}

#Preview {
    ContentView()
}

