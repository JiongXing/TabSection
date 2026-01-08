//
//  TabContentHeightKey.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// TabContentView 内容高度 PreferenceKey
struct TabContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

