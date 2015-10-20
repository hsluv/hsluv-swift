//
//  Common.swift
//  HUSLSwift
//
//  Created by Clay Smith on 6/16/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation
import XCTest
@testable import HUSLSwift

// TODO: Add HUSLP tests

class HUSLTests: XCTestCase {
  let rgbRangeTolerance = 0.00000000001
  let snapshotTolerance = 0.00000000001

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    continueAfterFailure = false
  }
  
  func testConversionConsistency() {
    for fromHex in Snapshot.hexSamples {
      let fromRgb  = hexToRgb(Hex(fromHex))
      let fromXyz  = rgbToXyz(fromRgb)
      let fromLuv  = xyzToLuv(fromXyz)
      let fromLch  = luvToLch(fromLuv)
      let fromHusl = lchToHusl(fromLch)
      
      let toLch = huslToLch(fromHusl)
      let toLuv = lchToLuv(toLch)
      let toXyz = luvToXyz(toLuv)
      let toRgb = xyzToRgb(toXyz)
      let toHex = rgbToHex(toRgb)

      XCTAssertEqualWithAccuracy(fromLch.L, toLch.L, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromLch.C, toLch.C, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromLch.H, toLch.H, accuracy: rgbRangeTolerance)
      
      XCTAssertEqualWithAccuracy(fromLuv.L, toLuv.L, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromLuv.U, toLuv.U, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromLuv.V, toLuv.V, accuracy: rgbRangeTolerance)
      
      XCTAssertEqualWithAccuracy(fromXyz.X, toXyz.X, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromXyz.Y, toXyz.Y, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromXyz.Z, toXyz.Z, accuracy: rgbRangeTolerance)
      
      XCTAssertEqualWithAccuracy(fromRgb.R, toRgb.R, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromRgb.G, toRgb.G, accuracy: rgbRangeTolerance)
      XCTAssertEqualWithAccuracy(fromRgb.B, toRgb.B, accuracy: rgbRangeTolerance)
      
      XCTAssertEqual(fromHex, toHex.string)
    }
  }
  
  func testRgbRangeTolerance() {
    for h in 0.0.stride(through: 360, by: 5) {
      for s in 0.0.stride(through: 100, by: 5) {
        for l in 0.0.stride(through: 100, by: 5) {
          let tRgb = huslToRgb(HUSLTuple(h, s, l))
          let rgb = [tRgb.R, tRgb.G, tRgb.B]
          
          for channel in rgb {
            XCTAssertGreaterThan(channel, -rgbRangeTolerance, "HUSL: \([h, s, l]) -> RGB: \(rgb)")
            XCTAssertLessThanOrEqual(channel, 1 + rgbRangeTolerance, "HUSL: \([h, s, l]) -> RGB: \(rgb)")
          }
        }
      }
    }
  }
  
  func testSnapshot() {
    Snapshot.compare(Snapshot.current) { [snapshotTolerance] hex, tag, stableTuple, currentTuple, stableChannel, currentChannel in
      let diff = abs(currentChannel - stableChannel)
      
      XCTAssertLessThan(diff, snapshotTolerance, "Snapshots for \(hex) don't match at \(tag): (stable: \(stableTuple), current: \(currentTuple)")
    }
  }
}
