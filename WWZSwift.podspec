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
  s.version      = "1.0.2"
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

  s.subspec 'WWZSwift' do |ss|
    ss.source_files = "WWZSwift/WWZSwift/*.swift"
    ss.dependency "CocoaAsyncSocket"
    ss.dependency "AFNetworking"
    ss.dependency "WWZSwift/Swift+WWZ"
  end
  s.subspec 'Swift+WWZ' do |ss|
    ss.source_files = "WWZSwift/Swift+WWZ/*.swift"
    ss.dependency "CommonCrypto"
  end

end
