//
//  TabSectionHeader.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//  Updated on 2026/1/8 to use TabSection framework
//

import SwiftUI
import TabSection

/// Tab 区域头部视图（吸顶标签栏）
/// 注意：此组件仅用于演示，实际使用时建议直接使用 TSStickyTabContainer
struct TabSectionHeader: View {
    let tabs: [String]
    @Binding var currentSelect: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部分割线
            Divider()
                .background(Color.gray.opacity(0.2))
            
            TSTabsView(
                tabs: tabs,
                currentSelect: $currentSelect
            )
            .background(Color.white)
            
            // 底部分割线
            Divider()
                .background(Color.gray.opacity(0.2))
        }
    }
}
