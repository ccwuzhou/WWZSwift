Pod::Spec.new do |s|
  s.name         = "WWZSwift"
  s.version      = "1.3.5"
  s.summary      = "A short description of WWZSwift."
  s.homepage     = "https://github.com/ccwuzhou/WWZSwift"
  s.license      = "MIT"
  s.author             = { "wwz" => "wwz@zgkjd.com" }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ccwuzhou/WWZSwift.git", :tag => "#{s.version}"}
  s.requires_arc = true
  s.framework  = "UIKit"

  # s.source_files = "Source/*.swift"

  s.subspec 'Extensions' do |ss|
    ss.source_files = "Source/Extensions/*.swift", "Source/*.swift"
  end
  s.subspec 'Models' do |ss|
    ss.source_files = "Source/Models/*.swift"
      # sss.dependency "Source/Extensions"
  end
  s.subspec 'Views' do |ss|
    ss.source_files = "Source/Views/*.swift"
    ss.dependency "WWZSwift/Extensions"
  end
end
