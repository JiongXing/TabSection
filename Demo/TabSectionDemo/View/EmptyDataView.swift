//
//  EmptyDataView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// 空数据占位视图
struct EmptyDataView: View {
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
