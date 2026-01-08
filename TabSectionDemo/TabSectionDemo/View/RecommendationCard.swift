//
//  RecommendationCard.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// 推荐内容卡片
struct RecommendationCard: View {
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
