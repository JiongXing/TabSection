//
//  TabsHeaderHeightKey.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// TabsView Header 高度 PreferenceKey
struct TabsHeaderHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 50 // 默认高度，包含安全边距
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

