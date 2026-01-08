//
//  TSTabsView.swift
//  TabSection
//
//  Created by jxing on 2026/1/8.
//

import SwiftUI

/// Tab 标签栏视图组件
@available(iOS 15.0, *)
public struct TSTabsView: View {
    /// 标签数据数组
    let tabs: [String]
    /// 当前选中的标签索引（使用 @Binding 以便父视图同步状态）
    @Binding var currentSelect: Int
    /// Tab 样式配置
    var style: TSTabStyle
    /// 命名空间，用于 matchedGeometryEffect
    @Namespace private var namespace
    
    /// 初始化方法
    /// - Parameters:
    ///   - tabs: 标签数据数组
    ///   - currentSelect: 当前选中的标签索引
    ///   - style: Tab 样式配置，默认使用 .default
    public init(
        tabs: [String],
        currentSelect: Binding<Int>,
        style: TSTabStyle = .default
    ) {
        self.tabs = tabs
        self._currentSelect = currentSelect
        self.style = style
    }
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: style.itemSpacing) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        TSTabItemView(
                            title: tab,
                            isSelected: index == currentSelect,
                            namespace: namespace,
                            style: style
                        )
                        .id(index)
                        .onTapGesture {
                            withAnimation(style.animationCurve.speed(style.animationDuration)) {
                                currentSelect = index
                            }
                            // 自动滚动到选中的标签位置
                            scrollProxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width)
            }
            .background(style.backgroundColor)
            .onChange(of: currentSelect) { newValue in
                // 当外部改变选中状态时，自动滚动到对应位置
                withAnimation(style.animationCurve.speed(style.animationDuration)) {
                    scrollProxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

/// 单个标签项视图
@available(iOS 15.0, *)
struct TSTabItemView: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let style: TSTabStyle
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(isSelected ? style.selectedFont : style.unselectedFont)
                .foregroundColor(isSelected ? style.selectedColor : style.unselectedColor)
                .padding(.horizontal, style.horizontalPadding)
                .padding(.vertical, style.verticalPadding)
                .background(
                    // 圆角风格下，选中状态显示背景色
                    Group {
                        if style.underlineHeight == 0 && isSelected {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(style.selectedColor)
                        }
                    }
                )
                .animation(nil, value: UUID()) // 避免文字动画干扰
            
            // 下划线区域，保持固定高度以确保动画流畅
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // 未选中时显示透明占位符
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: style.underlineHeight)
                    
                    // 选中时显示下划线
                    if isSelected && style.underlineHeight > 0 {
                        let underlineWidth: CGFloat = {
                            switch style.underlineWidth {
                            case .fixed(let width):
                                return width
                            case .ratio(let ratio):
                                return geometry.size.width * ratio
                            }
                        }()
                        
                        Rectangle()
                            .fill(style.underlineColor)
                            .frame(width: underlineWidth, height: style.underlineHeight)
                            .matchedGeometryEffect(id: "underline", in: namespace)
                    }
                }
                .frame(width: geometry.size.width, height: style.underlineHeight, alignment: .center)
            }
            .frame(height: style.underlineHeight)
        }
    }
}
