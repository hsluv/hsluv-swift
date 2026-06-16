# HSLuv.swift

[![Build Status](https://github.com/hsluv/hsluv-swift/actions/workflows/ci.yml/badge.svg)](https://github.com/hsluv/hsluv-swift/actions/workflows/ci.yml)

Swift port of [HSLuv](http://www.hsluv.org) (revision 4). Supports Swift 5+ on Apple platforms, Linux and Windows.

[Explanation, demo, etc.](http://www.hsluv.org)

## INSTALL

Install HSLuv using [Swift Package Manager](https://www.swift.org/documentation/package-manager/) by adding the following to your [`Package.swift`](https://developer.apple.com/documentation/packagedescription):

```swift
.package(url: "https://github.com/hsluv/hsluv-swift.git", from: "3.0.0"),
```

CocoaPods and Carthage are no longer supported, but we recommend you simply vendor the [source file](./Sources/HSLuv.swift) if SPM is not available.

## USAGE

The API is designed to avoid heap allocation. The `HSLuv` class defines the following public fields:

- RGB: `hex:String`, `rgb_r:Float` [0;1], `rgb_g:Float` [0;1], `rgb_r:Float` [0;1]
- CIE XYZ: `xyz_x:Float`, `xyz_y:Float`, `xyz_z:Float`
- CIE LUV: `luv_l:Float`, `luv_u:Float`, `luv_v:Float`
- CIE LUV LCh: `lch_l:Float`, `lch_c:Float`, `lch_h:Float`
- HSLuv: `hsluv_h:Float` [0;360], `hsluv_s:Float` [0;100], `hsluv_l:Float` [0;100]
- HPLuv: `hpluv_h:Float` [0;360], `hpluv_p:Float` [0;100], `hpluv_l:Float` [0;100]

To convert between color spaces, simply set the properties of the source color space, run the
conversion methods, then read the properties of the target color space.

Use the following methods to convert to and from RGB:

- HSLuv: `hsluvToRgb()`, `hsluvToHex()`, `rgbToHsluv()`, `hexToHsluv()`
- HPLuv: `hpluvToRgb()`, `hpluvToHex()`, `rgbToHpluv()`, `hexToHpluv()`

Use the following methods to do step-by-step conversion:

- Forward: `hsluvToLch()` (or `hpluvToLch()`), `lchToLuv()`, `luvToXyz()`, `xyzToRgb()`, `rgbToHex()`
- Backward: `hexToRgb()`, `rgbToXyz()`, `xyzToLuv()`, `luvToLch()`, `lchToHsluv()` (or `lchToHpluv()`)

For advanced usage, we also export the [bounding lines](https://www.hsluv.org/math/) in slope-intercept
format, two for each RGB channel representing the limit of the gamut.

- R < 0: `r0s`, `r0i`
- R > 1: `r1s`, `r1i`
- G < 0: `g0s`, `g0i`
- G > 1: `g1s`, `g1i`
- B < 0: `b0s`, `b0i`
- B > 1: `b1s`, `b1i`

Example:

```swift
let conv = Hsluv()
conv.hsluv_h = 10
conv.hsluv_s = 75
conv.hsluv_l = 65
conv.hsluvToHex()
print(conv.hex) // Will print "#ec7d82"
```

## CHANGELOG

See [CHANGELOG](CHANGELOG.md) for version history and release notes.

## LICENSE

See [LICENSE](LICENSE)
