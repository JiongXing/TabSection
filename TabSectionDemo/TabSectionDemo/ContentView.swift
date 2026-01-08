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
    /// TabContentView 内容高度（从 PreferenceKey 获取，用于动态设置 TabView 高度）
    @State private var tabContentHeight: CGFloat = 0
    
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
                        // TabView 内容区域
                        // 使用 GeometryReader 解决 TabView 在 Section 中高度丢失的问题
                        GeometryReader { _ in
                            TabView(selection: $currentSelect) {
                                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                                    TabContentView(
                                        title: tab,
                                        items: generateContentItems(for: tab)
                                    )
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                        }
                        .frame(height: tabContentHeight > 0 ? tabContentHeight : geometry.size.height)
                        .onPreferenceChange(TabContentHeightKey.self) { height in
                            tabContentHeight = height
                        }
                    } header: {
                        VStack(spacing: 0) {
                            // 顶部分割线
                            Divider()
                                .background(Color.gray.opacity(0.2))
                            
                            TabsView(
                                tabs: tabs,
                                currentSelect: $currentSelect
                            )
                            .background(.white)
                            
                            // 底部分割线
                            Divider()
                                .background(Color.gray.opacity(0.2))
                        }
                    }
                }
            }
            .refreshable {
                // 下拉刷新功能
                await refreshData()
            }
        }
    }
    
    /// 生成内容项（用于演示）
    private func generateContentItems(for tab: String) -> [String] {
        return (1..<10).map { "\(tab) - 内容 \($0)" }
    }
    
    /// 下拉刷新数据
    private func refreshData() async {
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        // 这里可以添加实际的数据刷新逻辑
    }
}

/// 头部内容视图（用于测试吸顶效果）
private struct HeaderContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Banner 区域
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#1677ff"), Color(hex: "#69b1ff")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("欢迎使用 Tabs 组件")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("向下滚动查看吸顶效果")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.vertical, 40)
            }
            .frame(height: 200)
            
            // 搜索栏区域
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                Text("搜索内容...")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // 功能入口区域
            HStack(spacing: 20) {
                FeatureButton(icon: "bell.fill", title: "通知", color: .red)
                FeatureButton(icon: "heart.fill", title: "收藏", color: .pink)
                FeatureButton(icon: "bookmark.fill", title: "书签", color: .blue)
                FeatureButton(icon: "person.fill", title: "我的", color: .green)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
    }
}

/// 功能按钮
private struct FeatureButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// 推荐内容卡片
private struct RecommendationCard: View {
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 缩略图
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#1677ff").opacity(0.6), Color(hex: "#69b1ff").opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 80)
                .overlay(
                    Image(systemName: "photo.fill")
                        .foregroundColor(.white)
                )
            
            // 内容
            VStack(alignment: .leading, spacing: 6) {
                Text("推荐内容 \(index)")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("这是第 \(index) 条推荐内容，用于测试吸顶效果。当你向下滚动时，Tab 标签栏会固定在顶部。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label("1.2k", systemImage: "eye.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label("202", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}

