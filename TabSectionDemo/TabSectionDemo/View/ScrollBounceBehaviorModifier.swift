//
//  ScrollBounceBehaviorModifier.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// ScrollView Bouncing 行为修饰符（兼容不同 iOS 版本）
struct ScrollBounceBehaviorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            // iOS 17+ 使用 .basedOnSize，根据内容大小决定是否显示 bouncing
            content.scrollBounceBehavior(.basedOnSize)
        } else {
            // iOS 16 及以下，保持默认行为
            content
        }
    }
}

extension View {
    /// 根据 iOS 版本设置 ScrollView bouncing 行为
    func scrollBounceBehaviorModifier() -> some View {
        modifier(ScrollBounceBehaviorModifier())
    }
}

