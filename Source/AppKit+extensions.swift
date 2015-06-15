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

import AppKit

public extension NSColor {
  /// Initializes and returns a color object using the specified opacity and
  /// HUSL color space component values.
  ///
  /// - parameter hue: CGFLoat
  /// - parameter saturation: CGFloat
  /// - parameter lightness: CGFloat
  /// - parameter alpha: CGFloat
  convenience init?(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
    if let color = huslToCGColor(Double(hue), S: Double(saturation), L: Double(lightness), alpha: Double(alpha)) {
      self.init(CGColor: color)
    } else {
      return nil
    }
  }
  
  /// Convenience function to wrap the behavior of getRed(red:green:blue:alpha:)
  ///
  /// - returns: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
  func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    return (red: red, green: green, blue: blue, alpha: alpha)
  }
}