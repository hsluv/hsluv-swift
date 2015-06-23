Pod::Spec.new do |s|
  s.name             = "HUSLSwift"

  s.version          = "1.0.0"

  s.summary          = "Swift port of HUSL, a human-friendly alternative to HSL"
  s.homepage         = "https://github.com/husl-colors/husl-swift"
  s.license          = { :type => 'MIT', :text => '@see LICENSE' }
  s.author           = { "Clay Smith" => "s.clay.smith@gmail.com", "Alexei Boronine" => "alexei@boronine.com" }
  s.source           = { :git => "https://github.com/husl-colors/husl-swift.git", :tag => "v" + s.version.to_s }
  s.default_subspecs = 'HUSL'
  s.requires_arc     = true
  s.xcconfig         = { 'SWIFT_INSTALL_OBJC_HEADER' => 'NO' }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.subspec 'HUSL' do |ss|
    ss.source_files     = 'Source/*.{swift}'
    ss.frameworks       = 'Foundation'
  end

  s.subspec 'UIKit' do |ss|
    ss.ios.source_files = 'Extensions/UIKit/*.{swift}'
    ss.dependency         'HUSLSwift/HUSL'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'AppKit' do |ss|
    ss.osx.source_files = 'Extensions/AppKit/*.{swift}'
    ss.dependency         'HUSLSwift/HUSL'
    ss.osx.frameworks   = 'AppKit'
  end
end
