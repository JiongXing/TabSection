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
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    ContentCardView(title: item)
                }
            }
            .padding([.top, .horizontal])
            .frame(width: geometry.size.width, alignment: .top)
        }
        .border(.red, width: 2)
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

