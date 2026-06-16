/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Clay Smith
 * Copyright (c) 2015, 2025 Alexei Boronine
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Foundation

public class Hsluv {
    private static let hexChars: String = "0123456789abcdef"
    private static let refY: Double = 1.0
    private static let refU: Double = 0.19783000664283
    private static let refV: Double = 0.46831999493879
    private static let kappa: Double = 903.2962962
    private static let epsilon: Double = 0.0088564516
    private static let m_r0: Double = 3.240969941904521
    private static let m_r1: Double = -1.537383177570093
    private static let m_r2: Double = -0.498610760293
    private static let m_g0: Double = -0.96924363628087
    private static let m_g1: Double = 1.87596750150772
    private static let m_g2: Double = 0.041555057407175
    private static let m_b0: Double = 0.055630079696993
    private static let m_b1: Double = -0.20397695888897
    private static let m_b2: Double = 1.056971514242878
    
    // RGB
    public var hex: String = "#000000"
    public var rgb_r: Double = 0
    public var rgb_g: Double = 0
    public var rgb_b: Double = 0
    
    // CIE XYZ
    public var xyz_x: Double = 0
    public var xyz_y: Double = 0
    public var xyz_z: Double = 0
    
    // CIE LUV
    public var luv_l: Double = 0
    public var luv_u: Double = 0
    public var luv_v: Double = 0
    
    // CIE LUV LCh
    public var lch_l: Double = 0
    public var lch_c: Double = 0
    public var lch_h: Double = 0
    
    // HSLuv
    public var hsluv_h: Double = 0
    public var hsluv_s: Double = 0
    public var hsluv_l: Double = 0
    
    // HPLuv
    public var hpluv_h: Double = 0
    public var hpluv_p: Double = 0
    public var hpluv_l: Double = 0
    
    // 6 lines in slope-intercept format: R < 0, R > 1, G < 0, G > 1, B < 0, B > 1
    public var r0s: Double = 0
    public var r0i: Double = 0
    public var r1s: Double = 0
    public var r1i: Double = 0
    
    public var g0s: Double = 0
    public var g0i: Double = 0
    public var g1s: Double = 0
    public var g1i: Double = 0
    
    public var b0s: Double = 0
    public var b0i: Double = 0
    public var b1s: Double = 0
    public var b1i: Double = 0
    
    public init() {}
    
    private static func fromLinear(_ c: Double) -> Double {
        if c <= 0.0031308 {
            return 12.92 * c
        } else {
            return 1.055 * pow(c, 1 / 2.4) - 0.055
        }
    }
    
    private static func toLinear(_ c: Double) -> Double {
        if c > 0.04045 {
            return pow((c + 0.055) / 1.055, 2.4)
        } else {
            return c / 12.92
        }
    }
    
    private static func yToL(_ Y: Double) -> Double {
        if Y <= epsilon {
            return Y / refY * kappa
        } else {
            return 116 * pow(Y / refY, 1 / 3) - 16
        }
    }
    
    private static func lToY(_ L: Double) -> Double {
        if L <= 8 {
            return refY * L / kappa
        } else {
            return refY * pow((L + 16) / 116, 3)
        }
    }
    
    private static func rgbChannelToHex(_ chan: Double) -> String {
        let c = Int(round(chan * 255))
        let digit2 = c % 16
        let digit1 = (c - digit2) / 16
        let char1 = hexChars[hexChars.index(hexChars.startIndex, offsetBy: digit1)]
        let char2 = hexChars[hexChars.index(hexChars.startIndex, offsetBy: digit2)]
        return String(char1) + String(char2)
    }
    
    private static func hexToRgbChannel(_ hex: String, _ offset: Int) -> Double {
        let char1 = hex[hex.index(hex.startIndex, offsetBy: offset)]
        let char2 = hex[hex.index(hex.startIndex, offsetBy: offset + 1)]
        let digit1 = hexChars.firstIndex(of: char1)!.utf16Offset(in: hexChars)
        let digit2 = hexChars.firstIndex(of: char2)!.utf16Offset(in: hexChars)
        let n = digit1 * 16 + digit2
        return Double(n) / 255.0
    }
    
    private static func distanceFromOriginAngle(_ slope: Double, _ intercept: Double, _ angle: Double) -> Double {
        let d = intercept / (sin(angle) - slope * cos(angle))
        if d < 0 {
            return Double.infinity
        } else {
            return d
        }
    }
    
    private static func distanceFromOrigin(_ slope: Double, _ intercept: Double) -> Double {
        return abs(intercept) / sqrt(pow(slope, 2) + 1)
    }
    
    private static func min6(_ f1: Double, _ f2: Double, _ f3: Double, _ f4: Double, _ f5: Double, _ f6: Double) -> Double {
        return min(f1, min(f2, min(f3, min(f4, min(f5, f6)))))
    }
    
    public func rgbToHex() {
        hex = "#"
        hex += Hsluv.rgbChannelToHex(rgb_r)
        hex += Hsluv.rgbChannelToHex(rgb_g)
        hex += Hsluv.rgbChannelToHex(rgb_b)
    }
    
    public func hexToRgb() {
        let lowercaseHex = hex.lowercased()
        rgb_r = Hsluv.hexToRgbChannel(lowercaseHex, 1)
        rgb_g = Hsluv.hexToRgbChannel(lowercaseHex, 3)
        rgb_b = Hsluv.hexToRgbChannel(lowercaseHex, 5)
    }
    
    public func xyzToRgb() {
        rgb_r = Hsluv.fromLinear(Hsluv.m_r0 * xyz_x + Hsluv.m_r1 * xyz_y + Hsluv.m_r2 * xyz_z)
        rgb_g = Hsluv.fromLinear(Hsluv.m_g0 * xyz_x + Hsluv.m_g1 * xyz_y + Hsluv.m_g2 * xyz_z)
        rgb_b = Hsluv.fromLinear(Hsluv.m_b0 * xyz_x + Hsluv.m_b1 * xyz_y + Hsluv.m_b2 * xyz_z)
    }
    
    public func rgbToXyz() {
        let lr = Hsluv.toLinear(rgb_r)
        let lg = Hsluv.toLinear(rgb_g)
        let lb = Hsluv.toLinear(rgb_b)
        xyz_x = 0.41239079926595 * lr + 0.35758433938387 * lg + 0.18048078840183 * lb
        xyz_y = 0.21263900587151 * lr + 0.71516867876775 * lg + 0.072192315360733 * lb
        xyz_z = 0.019330818715591 * lr + 0.11919477979462 * lg + 0.95053215224966 * lb
    }
    
    public func xyzToLuv() {
        let divider = xyz_x + 15 * xyz_y + 3 * xyz_z
        var varU = 4 * xyz_x
        var varV = 9 * xyz_y
        if divider != 0 {
            varU /= divider
            varV /= divider
        } else {
            varU = Double.nan
            varV = Double.nan
        }
        luv_l = Hsluv.yToL(xyz_y)
        if luv_l == 0 {
            luv_u = 0
            luv_v = 0
        } else {
            luv_u = 13 * luv_l * (varU - Hsluv.refU)
            luv_v = 13 * luv_l * (varV - Hsluv.refV)
        }
    }
    
    public func luvToXyz() {
        if luv_l == 0 {
            xyz_x = 0
            xyz_y = 0
            xyz_z = 0
            return
        }
        let varU = luv_u / (13 * luv_l) + Hsluv.refU
        let varV = luv_v / (13 * luv_l) + Hsluv.refV
        xyz_y = Hsluv.lToY(luv_l)
        xyz_x = 0 - 9 * xyz_y * varU / ((varU - 4) * varV - varU * varV)
        xyz_z = (9 * xyz_y - 15 * varV * xyz_y - varV * xyz_x) / (3 * varV)
    }
    
    public func luvToLch() {
        lch_l = luv_l
        lch_c = sqrt(luv_u * luv_u + luv_v * luv_v)
        if lch_c < 0.00000001 {
            lch_h = 0
        } else {
            let hrad = atan2(luv_v, luv_u)
            lch_h = hrad * 180.0 / Double.pi
            if lch_h < 0 {
                lch_h = 360 + lch_h
            }
        }
    }
    
    public func lchToLuv() {
        let hrad = lch_h / 180.0 * Double.pi
        luv_l = lch_l
        luv_u = cos(hrad) * lch_c
        luv_v = sin(hrad) * lch_c
    }
    
    public func calculateBoundingLines(_ l: Double) {
        let sub1 = pow(l + 16, 3) / 1560896
        let sub2 = sub1 > Hsluv.epsilon ? sub1 : l / Hsluv.kappa
        let s1r = sub2 * (284517 * Hsluv.m_r0 - 94839 * Hsluv.m_r2)
        let s2r = sub2 * (838422 * Hsluv.m_r2 + 769860 * Hsluv.m_r1 + 731718 * Hsluv.m_r0)
        let s3r = sub2 * (632260 * Hsluv.m_r2 - 126452 * Hsluv.m_r1)
        let s1g = sub2 * (284517 * Hsluv.m_g0 - 94839 * Hsluv.m_g2)
        let s2g = sub2 * (838422 * Hsluv.m_g2 + 769860 * Hsluv.m_g1 + 731718 * Hsluv.m_g0)
        let s3g = sub2 * (632260 * Hsluv.m_g2 - 126452 * Hsluv.m_g1)
        let s1b = sub2 * (284517 * Hsluv.m_b0 - 94839 * Hsluv.m_b2)
        let s2b = sub2 * (838422 * Hsluv.m_b2 + 769860 * Hsluv.m_b1 + 731718 * Hsluv.m_b0)
        let s3b = sub2 * (632260 * Hsluv.m_b2 - 126452 * Hsluv.m_b1)
        r0s = s1r / s3r
        r0i = s2r * l / s3r
        r1s = s1r / (s3r + 126452)
        r1i = (s2r - 769860) * l / (s3r + 126452)
        g0s = s1g / s3g
        g0i = s2g * l / s3g
        g1s = s1g / (s3g + 126452)
        g1i = (s2g - 769860) * l / (s3g + 126452)
        b0s = s1b / s3b
        b0i = s2b * l / s3b
        b1s = s1b / (s3b + 126452)
        b1i = (s2b - 769860) * l / (s3b + 126452)
    }
    
    public func calcMaxChromaHpluv() -> Double {
        let r0 = Hsluv.distanceFromOrigin(r0s, r0i)
        let r1 = Hsluv.distanceFromOrigin(r1s, r1i)
        let g0 = Hsluv.distanceFromOrigin(g0s, g0i)
        let g1 = Hsluv.distanceFromOrigin(g1s, g1i)
        let b0 = Hsluv.distanceFromOrigin(b0s, b0i)
        let b1 = Hsluv.distanceFromOrigin(b1s, b1i)
        return Hsluv.min6(r0, r1, g0, g1, b0, b1)
    }
    
    public func calcMaxChromaHsluv(_ h: Double) -> Double {
        let hueRad = h / 360 * Double.pi * 2
        let r0 = Hsluv.distanceFromOriginAngle(r0s, r0i, hueRad)
        let r1 = Hsluv.distanceFromOriginAngle(r1s, r1i, hueRad)
        let g0 = Hsluv.distanceFromOriginAngle(g0s, g0i, hueRad)
        let g1 = Hsluv.distanceFromOriginAngle(g1s, g1i, hueRad)
        let b0 = Hsluv.distanceFromOriginAngle(b0s, b0i, hueRad)
        let b1 = Hsluv.distanceFromOriginAngle(b1s, b1i, hueRad)
        return Hsluv.min6(r0, r1, g0, g1, b0, b1)
    }
    
    public func hsluvToLch() {
        if hsluv_l > 99.9999999 {
            lch_l = 100
            lch_c = 0
        } else if hsluv_l < 0.00000001 {
            lch_l = 0
            lch_c = 0
        } else {
            lch_l = hsluv_l
            calculateBoundingLines(hsluv_l)
            let max = calcMaxChromaHsluv(hsluv_h)
            lch_c = max / 100 * hsluv_s
        }
        lch_h = hsluv_h
    }
    
    public func lchToHsluv() {
        if lch_l > 99.9999999 {
            hsluv_s = 0
            hsluv_l = 100
        } else if lch_l < 0.00000001 {
            hsluv_s = 0
            hsluv_l = 0
        } else {
            calculateBoundingLines(lch_l)
            let max = calcMaxChromaHsluv(lch_h)
            hsluv_s = lch_c / max * 100
            hsluv_l = lch_l
        }
        hsluv_h = lch_h
    }
    
    public func hpluvToLch() {
        if hpluv_l > 99.9999999 {
            lch_l = 100
            lch_c = 0
        } else if hpluv_l < 0.00000001 {
            lch_l = 0
            lch_c = 0
        } else {
            lch_l = hpluv_l
            calculateBoundingLines(hpluv_l)
            let max = calcMaxChromaHpluv()
            lch_c = max / 100 * hpluv_p
        }
        lch_h = hpluv_h
    }
    
    public func lchToHpluv() {
        if lch_l > 99.9999999 {
            hpluv_p = 0
            hpluv_l = 100
        } else if lch_l < 0.00000001 {
            hpluv_p = 0
            hpluv_l = 0
        } else {
            calculateBoundingLines(lch_l)
            let max = calcMaxChromaHpluv()
            hpluv_p = lch_c / max * 100
            hpluv_l = lch_l
        }
        hpluv_h = lch_h
    }
    
    public func hsluvToRgb() {
        hsluvToLch()
        lchToLuv()
        luvToXyz()
        xyzToRgb()
    }
    
    public func hpluvToRgb() {
        hpluvToLch()
        lchToLuv()
        luvToXyz()
        xyzToRgb()
    }
    
    public func hsluvToHex() {
        hsluvToRgb()
        rgbToHex()
    }
    
    public func hpluvToHex() {
        hpluvToRgb()
        rgbToHex()
    }
    
    public func rgbToHsluv() {
        rgbToXyz()
        xyzToLuv()
        luvToLch()
        lchToHpluv()
        lchToHsluv()
    }
    
    public func rgbToHpluv() {
        rgbToXyz()
        xyzToLuv()
        luvToLch()
        lchToHpluv()
    }
    
    public func hexToHsluv() {
        hexToRgb()
        rgbToHsluv()
    }
    
    public func hexToHpluv() {
        hexToRgb()
        rgbToHpluv()
    }
}

/// Clamps a value between 0 and 1
private func clamp(_ value: Double) -> Double {
    return max(0.0, min(1.0, value))
}

/// Converts HSLuv color values to RGB tuple
/// - Parameters:
///   - h: Hue in degrees (0-360)
///   - s: Saturation percentage (0-100)
///   - l: Lightness percentage (0-100)
/// - Returns: Named tuple with red, green, blue values in range 0-1
public func hsluvToRgb(_ h: Double, _ s: Double, _ l: Double) -> (red: Double, green: Double, blue: Double) {
    let converter = Hsluv()
    converter.hsluv_h = h
    converter.hsluv_s = s
    converter.hsluv_l = l
    converter.hsluvToRgb()
    
    return (
        red: clamp(converter.rgb_r),
        green: clamp(converter.rgb_g),
        blue: clamp(converter.rgb_b)
    )
}

/// Converts HPLuv color values to RGB tuple
/// - Parameters:
///   - h: Hue in degrees (0-360)
///   - p: Pastel percentage (0-100)
///   - l: Lightness percentage (0-100)
/// - Returns: Named tuple with red, green, blue values in range 0-1
public func hpluvToRgb(_ h: Double, _ p: Double, _ l: Double) -> (red: Double, green: Double, blue: Double) {
    let converter = Hsluv()
    converter.hpluv_h = h
    converter.hpluv_p = p
    converter.hpluv_l = l
    converter.hpluvToRgb()
    
    return (
        red: clamp(converter.rgb_r),
        green: clamp(converter.rgb_g),
        blue: clamp(converter.rgb_b)
    )
}
