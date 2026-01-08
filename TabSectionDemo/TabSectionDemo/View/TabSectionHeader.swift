//
//  TabSectionHeader.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// Tab 区域头部视图（吸顶标签栏）
struct TabSectionHeader: View {
    let tabs: [String]
    @Binding var currentSelect: Int
    
    var body: some View {
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
