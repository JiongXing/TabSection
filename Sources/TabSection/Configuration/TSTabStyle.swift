//
//  TSTabStyle.swift
//  TabSection
//
//  Created by jxing on 2026/1/8.
//

import SwiftUI

/// Tab 下划线宽度配置
@available(iOS 15.0, *)
public enum TSUnderlineWidth {
    /// 固定宽度
    case fixed(CGFloat)
    /// 相对于 Tab 项宽度的比例
    case ratio(CGFloat)
}

/// Tab 样式配置
@available(iOS 15.0, *)
public struct TSTabStyle {
    // MARK: - 字体配置
    
    /// 选中状态的字体
    public var selectedFont: Font
    /// 未选中状态的字体
    public var unselectedFont: Font
    
    // MARK: - 颜色配置
    
    /// 选中状态的文字颜色
    public var selectedColor: Color
    /// 未选中状态的文字颜色
    public var unselectedColor: Color
    /// 下划线颜色
    public var underlineColor: Color
    /// 背景颜色
    public var backgroundColor: Color
    /// 分割线颜色
    public var dividerColor: Color
    
    // MARK: - 布局配置
    
    /// Tab 项之间的间距（实际上是每个 Tab 项的左右 padding）
    public var itemSpacing: CGFloat
    /// Tab 项的水平内边距
    public var horizontalPadding: CGFloat
    /// Tab 项的垂直内边距
    public var verticalPadding: CGFloat
    /// 下划线高度
    public var underlineHeight: CGFloat
    /// 下划线宽度
    public var underlineWidth: TSUnderlineWidth
    
    // MARK: - 动画配置
    
    /// 动画持续时间
    public var animationDuration: Double
    /// 动画曲线
    public var animationCurve: Animation
    
    // MARK: - 初始化方法
    
    /// 自定义初始化
    public init(
        selectedFont: Font = .system(size: 16, weight: .medium),
        unselectedFont: Font = .system(size: 14),
        selectedColor: Color = Color(hex: "#1677ff"),
        unselectedColor: Color = .gray,
        underlineColor: Color = Color(hex: "#1677ff"),
        backgroundColor: Color = .white,
        dividerColor: Color = Color.gray.opacity(0.2),
        itemSpacing: CGFloat = 0,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 12,
        underlineHeight: CGFloat = 2,
        underlineWidth: TSUnderlineWidth = .ratio(0.5),
        animationDuration: Double = 0.3,
        animationCurve: Animation = .easeInOut
    ) {
        self.selectedFont = selectedFont
        self.unselectedFont = unselectedFont
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.underlineColor = underlineColor
        self.backgroundColor = backgroundColor
        self.dividerColor = dividerColor
        self.itemSpacing = itemSpacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.underlineHeight = underlineHeight
        self.underlineWidth = underlineWidth
        self.animationDuration = animationDuration
        self.animationCurve = animationCurve
    }
    
    // MARK: - 预设样式
    
    /// 默认蓝色风格
    public static let `default` = TSTabStyle()
    
    /// 简约风格
    public static let minimal = TSTabStyle(
        selectedFont: .system(size: 15, weight: .regular),
        unselectedFont: .system(size: 15, weight: .regular),
        selectedColor: .primary,
        unselectedColor: .secondary,
        underlineColor: .primary,
        backgroundColor: Color(.systemBackground),
        dividerColor: .clear,
        horizontalPadding: 16,
        verticalPadding: 10,
        underlineHeight: 1,
        underlineWidth: .ratio(1.0)
    )
    
    /// 圆角风格
    public static let rounded = TSTabStyle(
        selectedFont: .system(size: 14, weight: .semibold),
        unselectedFont: .system(size: 14, weight: .regular),
        selectedColor: .white,
        unselectedColor: .primary,
        underlineColor: .clear,
        backgroundColor: Color(.systemBackground),
        dividerColor: Color.gray.opacity(0.1),
        horizontalPadding: 16,
        verticalPadding: 8,
        underlineHeight: 0,
        underlineWidth: .fixed(0)
    )
}
