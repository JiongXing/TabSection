//
//  TabContentHeightKey.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/7.
//

import SwiftUI

/// 单个 Tab 内容高度数据
struct TabHeightData: Equatable {
    let index: Int
    let height: CGFloat
}

/// TabContentView 内容高度 PreferenceKey
/// 收集所有 tab 的高度信息，使用字典存储
struct TabContentHeightKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        // 合并所有 tab 的高度信息
        value.merge(nextValue()) { _, new in new }
    }
}
