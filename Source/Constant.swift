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
  static var m = (
    R: Tuple(  3.2409699419045214,   -1.5373831775700935,  -0.49861076029300328  ),
    G: Tuple( -0.96924363628087983,   1.8759675015077207,   0.041555057407175613 ),
    B: Tuple(  0.055630079696993609, -0.20397695888897657,  1.0569715142428786   )
  )
  
  static var mInv = (
    X: Tuple( 0.41239079926595948, 0.35758433938387796, 0.18048078840183429  ),
    Y: Tuple( 0.21263900587151036, 0.71516867876775593, 0.072192315360733715 ),
    Z: Tuple( 0.019330818715591851, 0.11919477979462599, 0.95053215224966058 )
  )
  
  // Hard-coded D65 standard illuminant
  static var refU = 0.19783000664283681
  static var refV = 0.468319994938791
  
  // CIE LUV constants
  static var kappa = 903.2962962962963
  static var epsilon = 0.0088564516790356308
  
  // Swift limitations
  static var maxDouble = Double.greatestFiniteMagnitude
}
