#
#  Be sure to run `pod spec lint WWZSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "WWZSwift"
  s.version      = "1.0.0"
  s.summary      = "A short description of WWZSwift."

  s.homepage     = "https://github.com/ccwuzhou/WWZSwift"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "wwz" => "wwz@zgkjd.com" }

  s.platform     = :ios

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/ccwuzhou/WWZSwift.git", :tag => "#{s.version}"}

  # s.public_header_files  = "WWZSwift/WWZSwift.h"

  # s.source_files = "WWZSwift/WWZSwift.h"

  s.requires_arc = true

  s.framework  = "UIKit"
  # s.default_subspecs = 'Model'
  s.dependency "CocoaAsyncSocket", "AFNetworking"

  s.subspec 'WWZSwift' do |ss|
      ss.source_files = "WWZSwift/WWZSwift/*.swift"
    ss.subspec 'Model' do |sss|
      sss.source_files = "WWZSwift/WWZSwift/Model/*.swift"
    end
    ss.subspec 'Controller' do |sss|
      sss.source_files = "WWZSwift/WWZSwift/Controller/*.swift"
    end
    ss.subspec 'View' do |sss|
      sss.source_files = "WWZSwift/WWZSwift/View/*.swift"
      sss.dependency "WWZSwift/WWZSwift/Model"
    end
    ss.subspec 'Cell' do |sss|
      sss.source_files = "WWZSwift/WWZSwift/Cell/*.swift"
    end
  end
  
  s.subspec 'WWZSwift+WWZ' do |ss|
    ss.source_files = "WWZSwift/WWZSwift+WWZ/*.swift"
  end

end
