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

import Foundation

public struct HUSL {
  public let hue: Double
  public let saturation: Double
  public let lightness: Double
  public let alpha: Double
  private let husl: HUSLTuple
  
  public init(hue: Double, saturation: Double, lightness: Double, alpha: Double = 1.0) {
    self.hue = hue
    self.saturation = saturation
    self.lightness = lightness
    self.alpha = alpha
    
    self.husl = HUSLTuple(hue, saturation, lightness)
  }
  
  public init(_ hue: Double, _ saturation: Double, _ lightness: Double, _ alpha: Double = 1.0) {
    self.init(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
  }
  
  public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
    let (hue, saturation, lightness) = rgbToHusl(RGBTuple(red, green, blue)).tuple
    self.init(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
  }

  // MARK: - Conversion
  public var RGB: (R: Double, G: Double, B: Double) {
    return huslToRgb(husl).tuple
  }
  
  public var LCH: (L: Double, C: Double, H: Double) {
    return huslToLch(husl).tuple
  }
  
  public var LUV: (L: Double, U: Double, V: Double) {
    return lchToLuv(huslToLch(husl)).tuple
  }
  
  public var XYZ: (X: Double, Y: Double, Z: Double) {
    return  rgbToXyz(huslToRgb(husl)).tuple
  }
}

extension HUSL: CustomStringConvertible {
  public var description: String {
    return "HUSLA(\(hue), \(saturation), \(lightness), \(alpha))"
  }
}