//
//  TabContentView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// 标签页内容视图
struct TabContentView: View {
    /// 标签标题
    let title: String
    /// 内容数据（用于演示）
    let items: [String]
    /// 当前标签页的索引（用于标识高度信息）
    let index: Int
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(spacing: 16) {
                if items.isEmpty {
                    // 空数据占位视图，确保高度不为 0
                    EmptyDataView()
                } else {
                    ForEach(items, id: \.self) { item in
                        ContentCardView(title: item)
                    }
                }
            }
            .padding([.top, .horizontal])
            .frame(width: geometry.size.width, alignment: .top)
            .background(
                GeometryReader { contentGeometry in
                    Color.clear
                        .preference(
                            key: TabContentHeightKey.self,
                            // 发送当前 tab 的索引和高度信息
                            value: [index: contentGeometry.size.height]
                        )
                }
            )
        }
    }
}

/// 内容卡片视图
private struct ContentCardView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("这是 \(title) 标签页的内容示例。你可以在这里放置任何内容，比如文章列表、图片、视频等。")
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

/// 空数据占位视图
private struct EmptyDataView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("暂无内容")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("该标签页暂时没有内容")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
