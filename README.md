# HUSLSwift

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

The supported method of installation is via Cocoapods. Simply add `pod 'HUSLSwift'` to your target. Since this is a Swift dynamic framework, you must also tell Cocoapods to `use_frameworks!` instead of static libraries.

```ruby
platform :ios, '9.0' # or, :osx, '10.10'
use_frameworks!usl

target 'YourProject' do
pod 'HUSLSwift', '~> 1.0.0'
end
```


## TODO

* Finish HUSLP implementation
* Improve tests and add continuous integration testing
* Add Carthage instructions
* Add usage documentation


## License

See [License](LICENSE)