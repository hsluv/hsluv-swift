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

// TODO: Add HUSLP struct

public struct HUSL {
  private let husl: HUSLTuple
  public let alpha: Double

  public var hue: Double { return husl.H }
  public var saturation: Double { return husl.S }
  public var lightness: Double { return husl.L }
  
  public init(hue: Double, saturation: Double, lightness: Double, alpha: Double = 1.0) {
    self.alpha = alpha
    
    self.husl = HUSLTuple(hue, saturation, lightness)
  }
  
  public init(_ hue: Double, _ saturation: Double, _ lightness: Double, _ alpha: Double = 1.0) {
    self.init(hue: hue, saturation: saturation, lightness: lightness, alpha: alpha)
  }
  
  public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
    let husl = rgbToHusl(RGBTuple(red, green, blue))
    self.init(hue: husl.H, saturation: husl.S, lightness: husl.L, alpha: alpha)
  }
  
  public init(hex: String, alpha: Double = 1.0) {
    let hex = HUSLSwift.Hex(hex)
    let husl = rgbToHusl(hexToRgb(hex))
    self.init(hue: husl.H, saturation: husl.S, lightness: husl.L, alpha: alpha)
  }

  // MARK: - Conversion  
  public var RGB: (R: Double, G: Double, B: Double) {
    let rgb = huslToRgb(husl)
    return (rgb.R, rgb.G, rgb.B)
  }
  
  public var LCH: (L: Double, C: Double, H: Double) {
    let lch = huslToLch(husl)
    return (lch.L, lch.C, lch.H)
  }
  
  public var LUV: (L: Double, U: Double, V: Double) {
    let luv = lchToLuv(huslToLch(husl))
    return (luv.L, luv.U, luv.V)
  }
  
  public var XYZ: (X: Double, Y: Double, Z: Double) {
    let xyz = rgbToXyz(huslToRgb(husl))
    return (xyz.X, xyz.Y, xyz.Z)
  }
  
  public var Hex: String {
    return rgbToHex(huslToRgb(husl)).string
  }
}

extension HUSL: CustomStringConvertible {
  public var description: String {
    return "HUSLA(\(hue), \(saturation), \(lightness), \(alpha))"
  }
}