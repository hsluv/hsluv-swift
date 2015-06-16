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
import XCTest
import HUSLSwift

class UIKitTests: XCTestCase {
  
  let tolerance = 0.00000001
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testUIColorExtension() {
    let color = UIColor(hue: 0, saturation: 100, lightness: 50, alpha: 1.0)
    
    XCTAssertNotNil(color)
    
    let rgb = color!.getRGB()

    XCTAssertEqualWithAccuracy(rgb.red, 0.9175225466, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.green, 0, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.blue, 0.3938514752, accuracy: 0.01)
    XCTAssertEqual(rgb.alpha, 1)
  }
  
  func testUIColorFromHUSLExtension() {
    let husl = HUSL(0.0, 100.0, 50.0, 1.0)
    let color = husl.UIColor
    
    let rgb = color!.getRGB()
    
    XCTAssertEqualWithAccuracy(rgb.red, 0.9175225466, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.green, 0, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.blue, 0.3938514752, accuracy: 0.01)
    XCTAssertEqual(rgb.alpha, 1)
  }
}
