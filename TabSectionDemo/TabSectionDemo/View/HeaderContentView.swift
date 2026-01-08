//
//  HeaderContentView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// 头部内容视图（用于测试吸顶效果）
struct HeaderContentView: View {
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
