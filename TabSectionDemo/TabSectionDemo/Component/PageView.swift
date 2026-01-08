//
//  PageView.swift
//  TabSectionDemo
//
//  Created by jxing on 2026/1/8.
//

import SwiftUI
import UIKit

/// 自定义分页视图，使用 UIPageViewController 实现
/// 提供真正的滑动结束回调，替代 SwiftUI TabView
struct PageView<Content: View>: UIViewControllerRepresentable {
    /// 总页数
    let pageCount: Int
    /// 当前选中的页面索引
    @Binding var currentIndex: Int
    /// 滑动结束回调（真正的滑动结束，不是 selection 变化）
    var onScrollEnded: ((Int) -> Void)?
    /// 页面内容构建器
    let content: (Int) -> Content
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        // 设置初始页面
        if let initialVC = context.coordinator.viewController(at: currentIndex) {
            pageViewController.setViewControllers(
                [initialVC],
                direction: .forward,
                animated: false
            )
        }
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // 当外部改变 currentIndex 时（如点击 tab 切换），同步更新页面
        guard let currentVC = pageViewController.viewControllers?.first as? PageHostingController<Content>,
              currentVC.pageIndex != currentIndex else {
            return
        }
        
        let direction: UIPageViewController.NavigationDirection = currentIndex > currentVC.pageIndex ? .forward : .reverse
        
        if let targetVC = context.coordinator.viewController(at: currentIndex) {
            // 标记这是程序触发的切换，不是用户滑动
            context.coordinator.isProgrammaticChange = true
            pageViewController.setViewControllers(
                [targetVC],
                direction: direction,
                animated: true
            ) { _ in
                context.coordinator.isProgrammaticChange = false
                // 程序触发的切换完成后也回调
                self.onScrollEnded?(self.currentIndex)
            }
        }
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let parent: PageView
        /// 是否是程序触发的页面切换（非用户滑动）
        var isProgrammaticChange = false
        /// 缓存的 ViewController
        private var viewControllerCache: [Int: PageHostingController<Content>] = [:]
        
        init(_ parent: PageView) {
            self.parent = parent
        }
        
        /// 获取指定索引的 ViewController
        func viewController(at index: Int) -> PageHostingController<Content>? {
            guard index >= 0 && index < parent.pageCount else {
                return nil
            }
            
            // 使用缓存避免重复创建
            if let cached = viewControllerCache[index] {
                return cached
            }
            
            let vc = PageHostingController(
                rootView: parent.content(index),
                pageIndex: index
            )
            viewControllerCache[index] = vc
            return vc
        }
        
        // MARK: - UIPageViewControllerDataSource
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let hostingVC = viewController as? PageHostingController<Content> else {
                return nil
            }
            return self.viewController(at: hostingVC.pageIndex - 1)
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let hostingVC = viewController as? PageHostingController<Content> else {
                return nil
            }
            return self.viewController(at: hostingVC.pageIndex + 1)
        }
        
        // MARK: - UIPageViewControllerDelegate
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            // 这个方法在用户滑动完成后调用
            guard completed,
                  let currentVC = pageViewController.viewControllers?.first as? PageHostingController<Content> else {
                return
            }
            
            let newIndex = currentVC.pageIndex
            
            // 更新 binding
            if parent.currentIndex != newIndex {
                parent.currentIndex = newIndex
            }
            
            // 回调滑动结束事件
            parent.onScrollEnded?(newIndex)
            
            #if DEBUG
            print("📱 PageView 滑动结束，当前页: \(newIndex)")
            #endif
        }
    }
}

/// 承载 SwiftUI 内容的 UIViewController
final class PageHostingController<Content: View>: UIHostingController<Content> {
    /// 当前页面索引
    let pageIndex: Int
    
    init(rootView: Content, pageIndex: Int) {
        self.pageIndex = pageIndex
        super.init(rootView: rootView)
        // 设置背景透明，让 SwiftUI 视图背景生效
        view.backgroundColor = .clear
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
