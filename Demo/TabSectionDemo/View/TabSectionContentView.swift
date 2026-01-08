//
//  TabSectionContentView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// Tab 区域内容视图（直接渲染当前选中的内容）
struct TabSectionContentView: View {
    let tab: String
    let items: [String]
    
    var body: some View {
        // 由于父视图的 .id() 修饰符会强制重建整个视图树
        // LazyVStack 也会完全重新创建，确保高度正确计算
        LazyVStack(spacing: 16) {
            if items.isEmpty {
                // 空数据占位视图
                EmptyDataView()
            } else {
                ForEach(items, id: \.self) { item in
                    ContentCardView(title: item)
                }
            }
        }
        .padding([.top, .horizontal])
    }
}
