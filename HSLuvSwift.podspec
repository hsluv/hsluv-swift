Pod::Spec.new do |s|
  s.name             = "HSLuvSwift"

  s.version          = "2.2.0"

  s.summary          = "Swift port of HSLuv, a human-friendly alternative to HSL"
  s.homepage         = "https://github.com/hsluv/hsluv-swift"
  s.license          = { :type => 'MIT', :text => '@see LICENSE' }
  s.author           = { "Clay Smith" => "s.clay.smith@gmail.com", "Alexei Boronine" => "alexei@boronine.com" }
  s.source           = { :git => "https://github.com/hsluv/hsluv-swift.git", :tag => "v" + s.version.to_s }
  s.requires_arc     = true
  s.xcconfig         = { 'SWIFT_INSTALL_OBJC_HEADER' => 'NO' }

  s.source_files     = 'Sources/HSLuvSwift/*.{swift}'
  s.frameworks       = 'Foundation'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '10.0'
  s.ios.frameworks   = 'UIKit'

  s.osx.deployment_target = '10.11'
  s.osx.frameworks   = 'AppKit'
end
