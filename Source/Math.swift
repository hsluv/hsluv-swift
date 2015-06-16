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

func getBounds(L: Double) -> [Vector] {
  let sub1: Double = pow(L + 16, 3) / 1560896
  let sub2 = sub1 > Constant.epsilon ? sub1 : L / Constant.kappa
  
  var result = [Vector]()
  for channel in Constant.m.keys {
    let (m1, m2, m3) = Constant.m[channel]!

    for t in [0.0, 1.0] {
      let top1 = (284517 * m1 - 94839 * m3) * sub2
      let top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * L * sub2 - 769860 * t * L
      let bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t
      
      let bound = (top1 / bottom, top2 / bottom)
      result.append(bound)
    }
  }
  
  return result
}

func intersectLine(line0: Vector, line line1: Vector) -> Double {
  return (line0.1 - line1.1) / (line1.0 - line0.0)
}

func distanceFromPole(point: Vector) -> Double {
  return sqrt(pow(point.0, 2) + pow(point.1, 2))
}

func lengthOfRayUntilIntersect(theta: Double, line: Vector) -> Double? {
  let len = line.1 / (sin(theta) - line.0 * cos(theta))
  
  if len < 0 {
    return nil
  }
  
  return len
}

// MARK: RGBTuple chroma methods

/// For given lightness, returns the maximum chroma. Keeping the chroma value
/// below this number will ensure that for any hue, the color is within the RGBTuple
/// gamut.
func maxChroma(lightness L: Double) -> Double {
  var lengths = [Double]()
  
  for bound in getBounds(L) {
    // x where line intersects with perpendicular running though (0, 0)
    let x = intersectLine(bound, line: (-1 / bound.1, 0))
    lengths.append(distanceFromPole((x, bound.0 + x * bound.1)))
  }
  
  return lengths.reduce(Constant.maxDouble) { min($0, $1) }
}

/// For a given lightness and hue, return the maximum chroma that fits in
/// the RGBTuple gamut.
func maxChroma(lightness L: Double, hue H: Double) -> Double {
  let hrad = H / 360 * M_2_PI
  
  var lengths = [Double]()
  for line in getBounds(L) {
    if let l = lengthOfRayUntilIntersect(hrad, line: line) {
      lengths.append(l)
    }
  }
  
  return lengths.reduce(Constant.maxDouble) { min($0, $1) }
}

func dotProduct<T: Deconstructable>(a: Tuple, b: T) -> Double {
  let b = b.tuple

  var ret = 0.0
  
  ret += a.0 * b.0
  ret += a.1 * b.1
  ret += a.2 * b.2
  
  return ret
}

// Used for RGBTuple conversions
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
func yToL(Y: Double) -> Double {
  if Y <= Constant.epsilon {
    return (Y / Constant.refY) * Constant.kappa
  }
  
  return 116 * pow((Y / Constant.refY), 1/3) - 16
}

func lToY(L: Double) -> Double {
  if L <= 8 {
    return Constant.refY * L / Constant.kappa
  }
  
  return Constant.refY * pow((L + 16) / 116, 3)
}

// MARK: - HUSL/RGB Conversion
func huslToRgb(hsl: HUSLTuple) -> RGBTuple {
  let tuple = xyzToRgb(luvToXyz(lchToLuv(huslToLch(hsl))))
  return RGBTuple(tuple.0, tuple.1, tuple.2)
}

func rgbToHusl(rgb: RGBTuple) -> HUSLTuple {
  return lchToHusl(luvToLch(xyzToLuv(rgbToXyz(rgb))))
}

// MARK: - XYZ/RGB Conversion
func xyzToRgb(xyz: XYZTuple) -> Tuple {
  let R = fromLinear(dotProduct(Constant.m["R"]!, b: xyz))
  let G = fromLinear(dotProduct(Constant.m["G"]!, b: xyz))
  let B = fromLinear(dotProduct(Constant.m["B"]!, b: xyz))
  
  return Tuple(R,  G, B)
}

func rgbToXyz(rgb: RGBTuple) -> XYZTuple {
  let (R, G, B) = rgb.tuple
  let rgbl = RGBTuple(toLinear(R), toLinear(G), toLinear(B))
  
  let X = dotProduct(Constant.mInv["X"]!, b: rgbl)
  let Y = dotProduct(Constant.mInv["Y"]!, b: rgbl)
  let Z = dotProduct(Constant.mInv["Z"]!, b: rgbl)
  
  return XYZTuple(X, Y, Z)
}

// MARK: - LUV/XYZ Conversion
func luvToXyz(luv: LUVTuple) -> XYZTuple {
  let (L, U, V) = luv.tuple
  
  if L == 0 {
    return XYZTuple(0, 0, 0)
  }
  
  let varU = U / (13 * L) + Constant.refU
  let varV = V / (13 * L) + Constant.refV
  
  let Y = lToY(L)
  let X = 0 - (9 * Y * varU) / ((varU - 4) * varV - varU * varV)
  let Z = (9 * Y - (15 * varV * Y) - (varV * X)) / (3 * varV)
  
  return XYZTuple(X, Y, Z)
}

func xyzToLuv(xyz: XYZTuple) -> LUVTuple {
  let (X, Y, Z) = xyz.tuple
  
  let varU = (4 * X) / (X + (15 * Y) + (3 * Z))
  let varV = (9 * Y) / (X + (15 * Y) + (3 * Z))
  
  let L = yToL(Y)
  
  if L == 0 {
    return LUVTuple(0, 0, 0)
  }
  
  let U = 13 * L * (varU - Constant.refU)
  let V = 13 * L * (varV - Constant.refV)
  
  return LUVTuple(L, U, V)
}

// MARK: - LCH/LUV Conversion
func lchToLuv(lch: LCHTuple) -> LUVTuple {
  let (L, C, H) = lch.tuple
  
  let Hrad = H / 360 * 2 * M_PI
  let U = cos(Hrad) * C
  let V = sin(Hrad) * C
  
  return LUVTuple(L, U, V)
}

func luvToLch(luv: LUVTuple) -> LCHTuple {
  let (L, U, V) = luv.tuple
  
  let C = pow(pow(U, 2) + pow(V, 2), 1 / 2)
  let Hrad = atan2(V, U)
  var H = Hrad * 360 / 2 / M_PI
  
  if H < 0 {
    H = 360 + H
  }
  
  return LCHTuple(L, C, H)
}

// MARK: - HUSL/LCH Conversion
func huslToLch(husl: HUSLTuple) -> LCHTuple {
  let (H, S, L) = husl.tuple
  
  let max = maxChroma(lightness: L, hue: H)
  let C = max / 100 * S
  
  return LCHTuple(L, C, H)
}

func lchToHusl(lch: LCHTuple) -> HUSLTuple {
  let (L, C, H) = lch.tuple
  
  let max = maxChroma(lightness: L, hue: H)
  let S = C / max * 100
  
  return HUSLTuple(H, S, L)
}

// MARK: - Pastel HUSL/LCH Conversion
func huslpToLch(husl: HUSLTuple) -> LCHTuple {
  let (H, S, L) = husl.tuple
  
  let max = maxChroma(lightness: L)
  let C = max / 100 * S
  
  return LCHTuple(L, C, H)
}

func lchToHuslp(lch: LCHTuple) -> HUSLTuple {
  let (L, C, H) = lch.tuple
  
  let max = maxChroma(lightness: L)
  let S = C / max * 100

  return HUSLTuple(H, S, L)
}



