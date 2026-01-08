//
//  TabsView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

struct TabsView: View {
    /// 标签数据数组
    let tabs: [String]
    /// 当前选中的标签索引（使用 @Binding 以便父视图同步状态）
    @Binding var currentSelect: Int
    /// 命名空间，用于 matchedGeometryEffect
    @Namespace private var namespace
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        TabItemView(
                            title: tab,
                            isSelected: index == currentSelect,
                            namespace: namespace
                        )
                        .id(index)
                        .onTapGesture {
                            currentSelect = index
                            // 自动滚动到选中的标签位置
                            scrollProxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width)
            }
            .onChange(of: currentSelect) { newValue in
                // 当外部改变选中状态时，自动滚动到对应位置
                withAnimation {
                    scrollProxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

/// 单个标签项视图
private struct TabItemView: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(isSelected ? .system(size: 16, weight: .medium) : .system(size: 14))
                .foregroundColor(isSelected ? Color(hex: "#1677ff") : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .animation(nil, value: UUID()) // 避免文字动画干扰
            
            // 下划线区域，保持固定高度以确保动画流畅
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // 未选中时显示透明占位符
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                    
                    // 选中时显示下划线，宽度为 TabItem 的一半，居中显示
                    if isSelected {
                        Rectangle()
                            .fill(Color(hex: "#1677ff"))
                            .frame(width: geometry.size.width * 0.5, height: 2)
                            .matchedGeometryEffect(id: "underline", in: namespace)
                    }
                }
                .frame(width: geometry.size.width, height: 2, alignment: .center)
            }
            .frame(height: 2)
        }
    }
}
