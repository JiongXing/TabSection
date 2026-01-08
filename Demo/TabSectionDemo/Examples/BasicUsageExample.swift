//
//  BasicUsageExample.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/8.
//  演示 TabSection 框架的各种使用场景
//

import SwiftUI
import TabSection

/// 基础使用示例
struct BasicUsageExample: View {
    let tabs = ["首页", "发现", "我的"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                VStack {
                    Text("这是 \(tab) 页面")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            }
        )
    }
}

/// 带头部内容的示例
struct WithHeaderExample: View {
    let tabs = ["推荐", "关注", "最新"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            headerContent: {
                VStack {
                    Text("自定义头部内容")
                        .font(.title)
                        .padding()
                    
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(height: 200)
                }
            },
            pageContent: { tab, index in
                Text("\(tab) 的内容")
                    .font(.headline)
                    .padding()
            }
        )
    }
}

/// 自定义样式示例
struct CustomStyleExample: View {
    let tabs = ["音乐", "视频", "直播", "电台"]
    @State private var selectedIndex = 0
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                ScrollView {
                    LazyVStack {
                        ForEach(0..<20) { i in
                            Text("\(tab) - 项目 \(i)")
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
        .tabStyle(
            TSTabStyle(
                selectedFont: .system(size: 18, weight: .bold),
                unselectedFont: .system(size: 16),
                selectedColor: Color(hex: "#FF6B6B"),
                unselectedColor: .gray,
                underlineColor: Color(hex: "#FF6B6B"),
                horizontalPadding: 24,
                underlineHeight: 3
            )
        )
    }
}

/// 预设样式示例
struct PresetStyleExample: View {
    let tabs = ["默认", "简约", "圆角"]
    @State private var selectedIndex = 0
    @State private var currentStyle: TSTabStyle = .default
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                VStack(spacing: 20) {
                    Text("当前样式: \(tab)")
                        .font(.title2)
                        .padding()
                    
                    Button("切换到默认样式") {
                        currentStyle = .default
                    }
                    .buttonStyle(.bordered)
                    
                    Button("切换到简约样式") {
                        currentStyle = .minimal
                    }
                    .buttonStyle(.bordered)
                    
                    Button("切换到圆角样式") {
                        currentStyle = .rounded
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                }
            }
        )
        .tabStyle(currentStyle)
    }
}

/// 带下拉刷新的示例
struct RefreshableExample: View {
    let tabs = ["消息", "通知", "动态"]
    @State private var selectedIndex = 0
    @State private var lastRefreshTime = Date()
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                VStack {
                    Text("最后刷新: \(lastRefreshTime.formatted())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("\(tab) 页面内容")
                        .font(.headline)
                    
                    Spacer()
                }
            }
        )
        .refreshable {
            await refreshData()
        }
    }
    
    private func refreshData() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        lastRefreshTime = Date()
    }
}

/// Tab 切换回调示例
struct TabChangedCallbackExample: View {
    let tabs = ["Tab A", "Tab B", "Tab C", "Tab D"]
    @State private var selectedIndex = 0
    @State private var switchLog: [String] = []
    
    var body: some View {
        TSStickyTabContainer(
            tabs: tabs,
            selectedIndex: $selectedIndex,
            pageContent: { tab, index in
                VStack(alignment: .leading, spacing: 12) {
                    Text("当前: \(tab)")
                        .font(.title)
                        .padding()
                    
                    Text("切换日志:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(switchLog.reversed(), id: \.self) { log in
                            Text(log)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        )
        .onTabChanged { oldIndex, newIndex in
            let log = "从 Tab \(oldIndex) 切换到 Tab \(newIndex)"
            switchLog.append(log)
            print(log)
        }
    }
}

#Preview("基础使用") {
    BasicUsageExample()
}

#Preview("带头部") {
    WithHeaderExample()
}

#Preview("自定义样式") {
    CustomStyleExample()
}

#Preview("预设样式") {
    PresetStyleExample()
}

#Preview("下拉刷新") {
    RefreshableExample()
}

#Preview("切换回调") {
    TabChangedCallbackExample()
}
