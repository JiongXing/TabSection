Pod::Spec.new do |s|
  s.name             = 'TabSection'
  s.version          = '1.0.0'
  s.summary          = 'SwiftUI 实现的多标签页滚动吸顶组件'
  s.description      = <<-DESC
    TabSection 是一个基于 SwiftUI 的多标签页组件库，提供：
    - Tab 标签栏组件，支持横向滚动和自动居中
    - Section 吸顶效果，标签栏可以固定在顶部
    - 多分页列表管理，支持懒加载和下拉刷新
    - 完全可自定义的样式系统
  DESC
  
  s.homepage         = 'https://github.com/JiongXing/TabSection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jxing' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/JiongXing/TabSection.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.9'
  
  s.source_files = 'Sources/TabSection/**/*.swift'
  
  s.frameworks = 'SwiftUI'
end
