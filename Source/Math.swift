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

import Foundation


// MARK: - Vector math
typealias Vector = (Double, Double)

/// For a given lightness, return a list of 6 lines in slope-intercept
/// form that represent the bounds in CIELUV, stepping over which will
/// push a value out of the RGB gamut
///
/// - parameter lightness: Double
func getBounds(lightness L: Double) -> [Vector] {
  let sub1: Double = pow(L + 16, 3) / 1560896
  let sub2 = sub1 > Constant.epsilon ? sub1 : L / Constant.kappa
  
  var result = [Vector]()
  
  let mirror = Mirror(reflecting: Constant.m)
  for (_, value) in mirror.children {
    let (m1, m2, m3) = value as! Tuple
   
    for t in [0.0, 1.0] {
      let top1 = (284517 * m1 - 94839 * m3) * sub2
      let top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * L * sub2 - 769860 * t * L
      let bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t
      
      result.append((top1 / bottom, top2 / bottom))
    }
  }
  
  return result
}

func intersectLine(line1: Vector, line line2: Vector) -> Double {
  return (line1.1 - line2.1) / (line2.0 - line1.0)
}

func distanceFromPole(point: Vector) -> Double {
  return sqrt(pow(point.0, 2) + pow(point.1, 2))
}

func lengthOfRayUntilIntersect(theta: Double, line: Vector) -> Double? {
  // theta  -- angle of ray starting at (0, 0)
  // m, b   -- slope and intercept of line
  // x1, y1 -- coordinates of intersection
  // len    -- length of ray until it intersects with line
  //
  // b + m * x1        = y1
  // len              >= 0
  // len * cos(theta)  = x1
  // len * sin(theta)  = y1
  //
  //
  // b + m * (len * cos(theta)) = len * sin(theta)
  // b = len * sin(hrad) - m * len * cos(theta)
  // b = len * (sin(hrad) - m * cos(hrad))
  // len = b / (sin(hrad) - m * cos(hrad))
  
  let (m1, b1) = line
  let len = b1 / (sin(theta) - m1 * cos(theta))
  
  if len < 0 {
    return nil
  }
  
  return len
}


// MARK: RGB methods

/// For given lightness, returns the maximum chroma. Keeping the chroma value
/// below this number will ensure that for any hue, the color is within the RGB
/// gamut.
func maxChroma(lightness L: Double) -> Double {
  var lengths = [Double]()
  
  for (m1, b1) in getBounds(lightness: L) {
    // x where line intersects with perpendicular running though (0, 0)
    let x = intersectLine((m1, b1), line: (-1 / m1, 0))
    lengths.append(distanceFromPole((x, b1 + x * m1)))
  }
  
  return lengths.reduce(Constant.maxDouble) { min($0, $1) }
}

/// For a given lightness and hue, return the maximum chroma that fits in
/// the RGB gamut.
func maxChroma(lightness L: Double, hue H: Double) -> Double {
  let hrad = H / 360 * M_PI * 2
  
  var lengths = [Double]()
  for line in getBounds(lightness: L) {
    if let l = lengthOfRayUntilIntersect(hrad, line: line) {
      lengths.append(l)
    }
  }
  
  return lengths.reduce(Constant.maxDouble) { min($0, $1) }
}

func dotProduct<T: TupleConverter>(a: Tuple, b: T) -> Double {
  let b = b.tuple

  var ret = 0.0
    
  ret += a.0 * b.0
  ret += a.1 * b.1
  ret += a.2 * b.2
  
  return ret
}

// Used for RGB conversions
func fromLinear(c: Double) -> Double {
  if c <= 0.0031308 {
    return 12.92 * c
  }
  
  return 1.055 * pow(c, 1 / 2.4) - 0.055
}

func toLinear(c: Double) -> Double {
  let a = 0.055
  if c > 0.04045 {
    return pow((c + a) / (1 + a), 2.4)
  }
  
  return c / 12.92
}


// MARK: - CIELUVTuple

// In these formulas, Yn refers to the reference white point. We are using
// illuminant D65, so Yn (see refY in Maxima file) equals 1. The formula is
// simplified accordingly.

func yToL(Y: Double) -> Double {
  if Y <= Constant.epsilon {
    return Y * Constant.kappa
  }
  
  return 116 * pow(Y, 1/3) - 16
}

func lToY(L: Double) -> Double {
  if L <= 8 {
    return L / Constant.kappa
  }
  
  return pow((L + 16) / 116, 3)
}


// MARK: - XYZ/RGB Conversion

func xyzToRgb(xyz: XYZTuple) -> RGBTuple {
  let R = fromLinear(dotProduct(Constant.m.R, b: xyz))
  let G = fromLinear(dotProduct(Constant.m.G, b: xyz))
  let B = fromLinear(dotProduct(Constant.m.B, b: xyz))
  
  return RGBTuple(R, G, B)
}

func rgbToXyz(rgb: RGBTuple) -> XYZTuple {
  let rgbl = RGBTuple(toLinear(rgb.R), toLinear(rgb.G), toLinear(rgb.B))
  
  let X = dotProduct(Constant.mInv.X, b: rgbl)
  let Y = dotProduct(Constant.mInv.Y, b: rgbl)
  let Z = dotProduct(Constant.mInv.Z, b: rgbl)
  
  return XYZTuple(X, Y, Z)
}


// MARK: - XYZ/LUV Conversion

func xyzToLuv(xyz: XYZTuple) -> LUVTuple {
  let varU = (4 * xyz.X) / (xyz.X + (15 * xyz.Y) + (3 * xyz.Z))
  let varV = (9 * xyz.Y) / (xyz.X + (15 * xyz.Y) + (3 * xyz.Z))
  
  let L = yToL(xyz.Y)
  
  guard L != 0 else {
    // Black will create a divide-by-zero error
    return LUVTuple(0, 0, 0)
  }
  
  let U = 13 * L * (varU - Constant.refU)
  let V = 13 * L * (varV - Constant.refV)
  
  return LUVTuple(L, U, V)
}

func luvToXyz(luv: LUVTuple) -> XYZTuple {
  guard luv.L != 0 else {
    // Black will create a divide-by-zero error
    return XYZTuple(0, 0, 0)
  }
  
  let varU = luv.U / (13 * luv.L) + Constant.refU
  let varV = luv.V / (13 * luv.L) + Constant.refV
  
  let Y = lToY(luv.L)
  let X = 0 - (9 * Y * varU) / ((varU - 4) * varV - varU * varV)
  let Z = (9 * Y - (15 * varV * Y) - (varV * X)) / (3 * varV)
  
  return XYZTuple(X, Y, Z)
}


// MARK: - LUV/LCH Conversion

func luvToLch(luv: LUVTuple) -> LCHTuple {
  let C = sqrt(pow(luv.U, 2) + pow(luv.V, 2))
  
  guard C >= 0.00000001 else {
    // Greys: disambiguate hue
    return LCHTuple(luv.L, C, 0)
  }
  
  let Hrad = atan2(luv.V, luv.U)
  var H = Hrad * 360 / 2 / M_PI
  
  if H < 0 {
    H = 360 + H
  }
  
  return LCHTuple(luv.L, C, H)
}

func lchToLuv(lch: LCHTuple) -> LUVTuple {
  let Hrad = lch.H / 360 * 2 * M_PI
  let U = cos(Hrad) * lch.C
  let V = sin(Hrad) * lch.C
  
  return LUVTuple(lch.L, U, V)
}


// MARK: - HUSL/LCH Conversion

func huslToLch(husl: HUSLTuple) -> LCHTuple {
  guard husl.L <= 99.9999999 && husl.L >= 0.00000001 else {
    // White and black: disambiguate chroma
    return LCHTuple(husl.L, 0, husl.H)
  }
  
  let max = maxChroma(lightness: husl.L, hue: husl.H)
  let C = max / 100 * husl.S
  
  return LCHTuple(husl.L, C, husl.H)
}

func lchToHusl(lch: LCHTuple) -> HUSLTuple {
  guard lch.L <= 99.9999999 && lch.L >= 0.00000001 else {
    // White and black: disambiguate saturation
    return HUSLTuple(lch.H, 0, lch.L)
  }
  
  let max = maxChroma(lightness: lch.L, hue: lch.H)
  let S = lch.C / max * 100
  
  return HUSLTuple(lch.H, S, lch.L)
}


// MARK: - Pastel HUSL/LCH Conversion

func huslpToLch(husl: HUSLTuple) -> LCHTuple {
  guard husl.L <= 99.9999999 && husl.L >= 0.00000001 else {
    // White and black: disambiguate chroma
    return LCHTuple(husl.L, 0, husl.H)
  }
  
  let max = maxChroma(lightness: husl.L)
  let C = max / 100 * husl.S
  
  return LCHTuple(husl.L, C, husl.H)
}

func lchToHuslp(lch: LCHTuple) -> HUSLTuple {
  guard lch.L <= 99.9999999 && lch.L >= 0.00000001 else {
    // White and black: disambiguate saturation
    return HUSLTuple(lch.H, 0, lch.L)
  }
  
  let max = maxChroma(lightness: lch.L)
  let S = lch.C / max * 100

  return HUSLTuple(lch.H, S, lch.L)
}

// MARK: - RGB/Hex Conversion
func round(value: Double, places: Double) -> Double {
  let divisor = pow(10.0, places)
  return round(value * divisor) / divisor
}

func getHexString(channel channel: Double) -> String {
  var ch = round(channel, places: 6)
  
  if ch < 0 || ch > 1 {
    // TODO: Implement Swift thrown errors
    fatalError("Illegal RGB value: \(ch)")
  }
  
  ch = round(ch * 255.0)
  
  return String(Int(ch), radix: 16, uppercase: false).stringByPaddingToLength(2, withString: "0", startingAtIndex: 0)
}

func rgbToHex(rgb: RGBTuple) -> Hex {
  let R = getHexString(channel: rgb.R)
  let G = getHexString(channel: rgb.G)
  let B = getHexString(channel: rgb.B)
  
  return Hex("#\(R)\(G)\(B)")
}

// This function is based on a comment by mehawk on gist arshad/de147c42d7b3063ef7bc.
// It is so flippin' elegant.
func hexToRgb(hex: Hex) -> RGBTuple {
  let string = hex.string.stringByReplacingOccurrencesOfString("#", withString: "")

  var rgbValue:UInt32 = 0
  NSScanner(string: string).scanHexInt(&rgbValue)
  
  return RGBTuple(
    Double((rgbValue & 0xFF0000) >> 16) / 255.0,
    Double((rgbValue & 0x00FF00) >> 8)  / 255.0,
    Double( rgbValue & 0x0000FF)        / 255.0
  )
}

// MARK: - Conversion shortcuts

func huslToRgb(hsl: HUSLTuple) -> RGBTuple {
  return xyzToRgb(luvToXyz(lchToLuv(huslToLch(hsl))))
}

func rgbToHusl(rgb: RGBTuple) -> HUSLTuple {
  return lchToHusl(luvToLch(xyzToLuv(rgbToXyz(rgb))))
}



