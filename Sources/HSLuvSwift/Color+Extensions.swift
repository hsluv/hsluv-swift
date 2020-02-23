//
// The MIT License (MIT)
//
// Copyright (c) 2015 Clay Smith
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

#if os(iOS)
import UIKit

private typealias Color = UIColor
#elseif os(macOS)
import AppKit

private typealias Color = NSColor
#endif

public extension Color {
  /// Initializes and returns a color object using the specified opacity and
  /// HSLuv color space component values.
  ///
  /// - parameter hue: Double
  /// - parameter saturation: Double
  /// - parameter lightness: Double
  /// - parameter alpha: Double
  convenience init(hue: Double, saturation: Double, lightness: Double, alpha: Double) {
    let rgb = hsluvToRgb(HSLuvTuple(hue, saturation, lightness))
    self.init(red: CGFloat(rgb.R), green: CGFloat(rgb.G), blue: CGFloat(rgb.B), alpha: CGFloat(alpha))
  }
}