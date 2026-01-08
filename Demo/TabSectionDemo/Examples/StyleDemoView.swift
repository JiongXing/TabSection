//
//  StyleDemoView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/8.
//

import SwiftUI
import TabSection

/// 样式演示视图 - 展示不同的预设样式
struct StyleDemoView: View {
    let tabs = ["默认", "简约", "圆角", "自定义"]
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 默认样式
                NavigationLink("默认样式 Demo") {
                    DefaultStyleDemo()
                }
                .buttonStyle(.bordered)
                
                // 简约样式
                NavigationLink("简约样式 Demo") {
                    MinimalStyleDemo()
                }
                .buttonStyle(.bordered)
                
                // 圆角样式
                NavigationLink("圆角样式 Demo") {
                    RoundedStyleDemo()
                }
                .buttonStyle(.bordered)
                
                // 自定义样式
                NavigationLink("自定义样式 Demo") {
                    CustomStyleDemo()
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
            .navigationTitle("样式演示")
        }
    }
}

/// 默认样式演示
struct DefaultStyleDemo: View {
    let tabs = ["推荐", "关注", "最新", "热门"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                ContentListView(title: tab, count: 15)
            }
        )
        .tabStyle(.default)
        .navigationTitle("默认样式")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 简约样式演示
struct MinimalStyleDemo: View {
    let tabs = ["全部", "文章", "视频", "问答"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                ContentListView(title: tab, count: 10)
            }
        )
        .tabStyle(.minimal)
        .navigationTitle("简约样式")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 圆角样式演示
struct RoundedStyleDemo: View {
    let tabs = ["精选", "推荐", "最新"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                ContentListView(title: tab, count: 12)
            }
        )
        .tabStyle(.rounded)
        .navigationTitle("圆角样式")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 自定义样式演示
struct CustomStyleDemo: View {
    let tabs = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    @State private var selectedIndex = 0
    
    // 自定义样式配置
    let customStyle = TSTabStyle(
        selectedFont: .system(size: 18, weight: .bold),
        unselectedFont: .system(size: 16, weight: .regular),
        selectedColor: Color(hex: "#FF6B6B"),
        unselectedColor: .gray,
        underlineColor: Color(hex: "#FF6B6B"),
        backgroundColor: .white,
        dividerColor: Color(hex: "#FFE5E5"),
        itemSpacing: 0,
        horizontalPadding: 24,
        verticalPadding: 14,
        underlineHeight: 3,
        underlineWidth: .ratio(0.7),
        animationDuration: 0.25,
        animationCurve: .spring()
    )
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            headerContent: {
                VStack {
                    Text("自定义样式示例")
                        .font(.title2)
                        .padding()
                    
                    Text("红色主题 • 粗体字 • 70% 下划线宽度")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#FFF5F5"))
            },
            pageContent: { tab, index in
                ContentListView(title: tab, count: 8)
            }
        )
        .tabStyle(customStyle)
        .navigationTitle("自定义样式")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 内容列表视图（辅助）
struct ContentListView: View {
    let title: String
    let count: Int
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(0..<count, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(title) - 内容 \(index + 1)")
                            .font(.headline)
                        
                        Text("这是 \(title) 标签页的示例内容 \(index + 1)。TabSection 框架提供了灵活的样式定制能力。")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview("样式演示") {
    StyleDemoView()
}

#Preview("默认样式") {
    DefaultStyleDemo()
}

#Preview("简约样式") {
    MinimalStyleDemo()
}

#Preview("圆角样式") {
    RoundedStyleDemo()
}

#Preview("自定义样式") {
    CustomStyleDemo()
}
