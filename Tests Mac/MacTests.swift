//
//  HUSLSwiftTests.swift
//  HUSLSwiftTests
//
//  Created by Clay Smith on 6/13/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import XCTest
@testable import HUSLSwiftMac

class MacTests: XCTestCase {

  let tolerance = 0.00000001
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testHUSLConsistency() {
    let (H, S, L) = rgbToHusl(RGB(0.9175225466, 0, 0.3938514752)).tuple
    
    XCTAssertEqualWithAccuracy(H, 0, accuracy: tolerance)
    XCTAssertEqualWithAccuracy(S, 100.0, accuracy: tolerance)
    XCTAssertEqualWithAccuracy(L, 50.0, accuracy: tolerance)
  }
  
  func testRGBConsistency() {
    let (R, G, B) = huslToRgb(HUSL(0, 100, 50)).tuple
    
    XCTAssertEqualWithAccuracy(R, 0.9175225466, accuracy: tolerance)
    XCTAssertEqualWithAccuracy(G, 0, accuracy: tolerance)
    XCTAssertEqualWithAccuracy(B, 0.3938514752, accuracy: tolerance)
  }
  
  func testBackAndForthConsistency() {
    let originalRgb = RGB(0.51, 0.251, 0.557)
    
    let returnedRgb = huslToRgb(rgbToHusl(originalRgb))
    
    XCTAssertEqualWithAccuracy(originalRgb.R, returnedRgb.R, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(originalRgb.G, returnedRgb.G, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(originalRgb.B, returnedRgb.B, accuracy: 0.01)
  }
  
  func testNSColorExtension() {
    let color = NSColor(hue: 0, saturation: 100, lightness: 50, alpha: 1.0)
    
    XCTAssertNotNil(color)
    
    let rgb = color!.getRGB()
    
    XCTAssertEqualWithAccuracy(rgb.red, 0.9175225466, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.green, 0, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(rgb.blue, 0.3938514752, accuracy: 0.01)
    XCTAssertEqual(rgb.alpha, 1)
  }

}
