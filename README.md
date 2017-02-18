# HSLuvSwift

[![Cocoapod compatible](https://img.shields.io/cocoapods/v/HSLuvSwift.svg)](https://cocoapods.org/pods/HSLuvSwift)
[![Carthage compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/hsluv/hsluv-swift.svg?branch=master)](https://travis-ci.org/hsluv/hsluv-swift)
[![MIT License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](LICENSE)

Swift port of [HSLuv](http://www.hsluv.org) (revision 4), courtesy 
of [Clay Smith](https://github.com/stphnclysmth)

[Explanation, demo, ports etc.](http://www.hsluv.org)


## USAGE

This framework adds a single initializer on the OS-specific color class to create a color from HSLuv parameters. The initializer takes the same parameters on both OSX and iOS.

```swift
// OSX
let color = NSColor(hue: 360.0, saturation: 100.0, lightness: 100.0, alpha: 1.0)

// iOS
let color = UIColor(hue: 360.0, saturation: 100.0, lightness: 100.0, alpha: 1.0)
```


## INSTALL

This project is compatible with CocoaPods and Carthage. (These instructions assume that your chosen method is already installed.)

### CocoaPods

Add `pod 'HSLuvSwift'` to your target. Since this is a Swift dynamic framework, you must also tell CocoaPods to `use_frameworks!` instead of static libraries.

```ruby
platform :ios, '8.0' # or, :osx, '10.10'
use_frameworks!

target 'YourProject' do
pod 'HSLuvSwift', '~> 2.0.0'
end
```

### Carthage

Add `github "hsluv/hsluv-swift" ~> 2.0.0` to your Cartfile and run `carthage bootstrap`. This builds frameworks for Mac and iOS targets. 

```sh
> echo 'github "hsluv/hsluv-swift" ~> 2.0.0' >> Cartfile
> carthage bootstrap
```


## TODO

* Finish HPLuv implementation
* Improve tests and add continuous integration testing
* Add Carthage instructions
* Add usage documentation


## License

See [License](LICENSE)
