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

struct Constant {
  static var m = [
    "R": Tuple( 3.240969941904521, -1.537383177570093, -0.498610760293    ),
    "G": Tuple( -0.96924363628087,  1.87596750150772,   0.041555057407175 ),
    "B": Tuple( 0.055630079696993, -0.20397695888897,   1.056971514242878 )
  ]
  
  static var mInv = [
    "X": Tuple( 0.41239079926595,  0.35758433938387, 0.18048078840183  ),
    "Y": Tuple( 0.21263900587151,  0.71516867876775, 0.072192315360733 ),
    "Z": Tuple( 0.019330818715591, 0.11919477979462, 0.95053215224966  )
  ]
  
  // Hard-coded D65 standard illuminant
  static var refX = 0.95045592705167
  static var refY = 1.0
  static var refZ = 1.089057750759878
  
  static var refU = 0.19783000664283
  static var refV = 0.46831999493879
  
  // CIE LUV constants
  static var kappa = 903.2962962
  static var epsilon = 0.0088564516
  
  // Swift limitations
  static var maxDouble = Double(FLT_MAX)
}