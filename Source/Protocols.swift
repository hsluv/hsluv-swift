//
// The MIT License (MIT)
//
// Copyright (c) 2015 Alexei Boronine
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import CoreGraphics

// Abstracts NSColor / UIColor
public protocol Color {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    /// Convenience function to wrap the behavior of getRed(red:green:blue:alpha:)
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat)

}

extension Color {

    func getRGBTuple() -> RGBTuple {
        let (red, green, blue) = getRGB()
        return RGBTuple(Double(red), Double(green), Double(blue))
    }

}

// MARK: - Initialization protocols

public protocol HSLuvInitializable: Color {}
extension HSLuvInitializable {

    /// Initializes and returns a color object using the specified opacity and
    /// HSLuv color space component values.
    ///
    /// - parameter hue: Double
    /// - parameter saturation: Double
    /// - parameter lightness: Double
    /// - parameter alpha: Double
    public init(hue: Double, saturation: Double, lightness: Double, alpha: Double) {
        let rgb = hsluvToRgb(HSLuvTuple(hue, saturation, lightness))
        self.init(red: CGFloat(rgb.R), green: CGFloat(rgb.G), blue: CGFloat(rgb.B), alpha: CGFloat(alpha))
    }

}

public protocol HPLuvInitializable: Color {}
extension HPLuvInitializable {

    /// Initializes and returns a color object using the specified opacity and
    /// HPLuv color space component values.
    ///
    /// - parameter hue: Double
    /// - parameter pastelSaturation: Double
    /// - parameter lightness: Double
    /// - parameter alpha: Double
    public init(hue: Double, pastelSaturation: Double, lightness: Double, alpha: Double) {
        let rgb = hpluvToRgb(HSLuvTuple(hue, pastelSaturation, lightness))
        self.init(red: CGFloat(rgb.R), green: CGFloat(rgb.G), blue: CGFloat(rgb.B), alpha: CGFloat(alpha))
    }

}

// MARK: - To HSLuv HPLuv conversions

extension HSLuvTuple {

    init(_ color: Color) {
        self = rgbToHsluv(color.getRGBTuple())
    }

}

extension HPLuvTuple {

    init(_ color: Color) {
        self = rgbToHpluv(color.getRGBTuple())
    }

}

public protocol HSLuvConvertible: Color {}
extension HSLuvConvertible {

    /// Returns the HSLuv color space component values for this color.
    public func getHSLuv() -> (hue: Double, saturation: Double, lightness: Double) {
        HSLuvTuple(self).tuple
    }

}

public protocol HPLuvConvertible: Color {}
extension HPLuvConvertible {

    /// Returns the HPLuv color space component values for this color.
    public func getHPLuv() -> (hue: Double, pastelSaturation: Double, lightness: Double) {
        HPLuvTuple(self).tuple
    }

}
