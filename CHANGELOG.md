# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - Unreleased
### Added
- New cross-platform API with no heap allocation
- DevContainer support for development

### Removed
- **BREAKING**: UIKit/AppKit specific extensions
- CocoaPods support
- Carthage support
- SwiftLint configuration
- Xcode build automation
- Playground examples

## [2.1.0] - 2020-09-03
### Added
- Swift Package Manager support
- HPLuv color initializers
- Protocol conformances to UIColor extension

### Changed
- Updated for Xcode 12 and Swift 5

## [2.0.0] - 2017-02-19
### Changed
- **BREAKING**: Renamed project from HUSL to HSLuv
- Updated for Swift 3

## [1.2.0] - 2015-10-20
### Changed
- Updated for Xcode 7 and Swift 2
- Uses new Mirror syntax
- Fixed Xcode warnings for var arguments and 'Always Search User Paths'

## [1.1.0] - 2015-07-03
### Changed
- Removed CoreGraphics dependency
- Made NS/UIColor initialization non-optional
- Simplified CocoaPods by removing subspecs

## [1.0.1] - 2015-07-02
### Changed
- Lowered deployment target in podspec

## [1.0.0] - 2015-06-23
### Added
- Initial release of HSLuv for Swift
- NS/UIColor extensions for macOS and iOS
- CocoaPods and Carthage support
- Playground examples

[3.0.0]: https://github.com/hsluv/hsluv-swift/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/hsluv/hsluv-swift/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/hsluv/hsluv-swift/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/hsluv/hsluv-swift/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/hsluv/hsluv-swift/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/hsluv/hsluv-swift/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/hsluv/hsluv-swift/releases/tag/v1.0.0 