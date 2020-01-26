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
}

public protocol HSLuvInitializable: Color {}

public extension HSLuvInitializable {

    /// Initializes and returns a color object using the specified opacity and
    /// HSLuv color space component values.
    ///
    /// - parameter hue: Double
    /// - parameter saturation: Double
    /// - parameter lightness: Double
    /// - parameter alpha: Double
    init(hue: Double, saturation: Double, lightness: Double, alpha: Double) {
        let rgb = hsluvToRgb(HSLuvTuple(hue, saturation, lightness))
        self.init(red: CGFloat(rgb.R), green: CGFloat(rgb.G), blue: CGFloat(rgb.B), alpha: CGFloat(alpha))
    }

    /// Initializes and returns a color object using the specified HSLuv tuple
    ///
    /// - parameter hsluv: HSLuvTuple
    /// - parameter alpha: Double
    init(_ hsluv: HSLuvTuple, alpha: Double = 1) {
        self.init(hue: hsluv.H, saturation: hsluv.S, lightness: hsluv.L, alpha: alpha)
    }

}

public protocol HPLuvInitializable: Color {}

public extension HSLuvInitializable {

    /// Initializes and returns a color object using the specified opacity and
    /// HPLuv color space component values.
    ///
    /// - parameter hue: Double
    /// - parameter pastelSaturation: Double
    /// - parameter lightness: Double
    /// - parameter alpha: Double
    init(hue: Double, pastelSaturation: Double, lightness: Double, alpha: Double) {
        let rgb = hpluvToRgb(HSLuvTuple(hue, pastelSaturation, lightness))
        self.init(red: CGFloat(rgb.R), green: CGFloat(rgb.G), blue: CGFloat(rgb.B), alpha: CGFloat(alpha))
    }

    /// Initializes and returns a color object using the specified HPLuv tuple
    ///
    /// - parameter hsluv: HPLuvTuple
    /// - parameter alpha: Double
    init(_ hpluv: HPLuvTuple, alpha: Double = 1) {
        self.init(hue: hpluv.H, saturation: hpluv.P, lightness: hpluv.L, alpha: alpha)
    }

}
