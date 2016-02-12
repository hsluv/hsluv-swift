# HUSLSwift

[![Cocoapod compatible](https://img.shields.io/cocoapods/v/HUSLSwift.svg)](https://cocoapods.org/pods/HUSLSwift)
[![Carthage compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](LICENSE)

Swift port of [HUSL](http://www.husl-colors.org) (revision 4), courtesy 
of [Clay Smith](https://github.com/stphnclysmth)

[Explanation, demo, ports etc.](http://www.husl-colors.org)


## USAGE

This framework adds a single initializer on the OS-specific color class to create a color from HUSL parameters. The initializer takes the same parameters on both OSX and iOS.

```swift
// OSX
let color = NSColor(hue: 360.0, saturation: 100.0, lightness: l00.0, alpha: 1.0)

// iOS
let color = UIColor(hue: 360.0, saturation: 100.0, lightness: l00.0, alpha: 1.0)
```


## INSTALL

This project is compatible with CocoaPods and Carthage. (These instructions assume that your chosen method is already installed.)

### CocoaPods

Add `pod 'HUSLSwift'` to your target. Since this is a Swift dynamic framework, you must also tell CocoaPods to `use_frameworks!` instead of static libraries.

```ruby
platform :ios, '8.0' # or, :osx, '10.10'
use_frameworks!

target 'YourProject' do
pod 'HUSLSwift', '~> 1.1.0'
end
```

### Carthage

Add `github "husl-colors/husl-swift" ~> 1.1.0` to your Cartfile and run `carthage bootstrap`. This builds frameworks for Mac and iOS targets. 

```sh
> echo 'github "husl-colors/husl-swift" ~> 1.1.0' >> Cartfile
> carthage bootstrap
```


## TODO

* Finish HUSLP implementation
* Improve tests and add continuous integration testing
* Add Carthage instructions
* Add usage documentation


## License

See [License](LICENSE)