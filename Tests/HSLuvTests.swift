//
//  Common.swift
//  HSLuvSwift
//
//  Created by Clay Smith on 6/16/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation
import XCTest
@testable import HSLuvSwift

// TODO: Add HPLuv tests

class HSLuvTests: XCTestCase {
  let rgbRangeTolerance = 0.000000001
  let snapshotTolerance = 0.000000001

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
      let fromHsluv = lchToHsluv(fromLch)
      
      let toLch = hsluvToLch(fromHsluv)
      let toLuv = lchToLuv(toLch)
      let toXyz = luvToXyz(toLuv)
      let toRgb = xyzToRgb(toXyz)
      let toHex = rgbToHex(toRgb)

        XCTAssertEqual(fromLch.L, toLch.L, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromLch.C, toLch.C, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromLch.H, toLch.H, accuracy: rgbRangeTolerance)
      
        XCTAssertEqual(fromLuv.L, toLuv.L, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromLuv.U, toLuv.U, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromLuv.V, toLuv.V, accuracy: rgbRangeTolerance)
      
        XCTAssertEqual(fromXyz.X, toXyz.X, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromXyz.Y, toXyz.Y, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromXyz.Z, toXyz.Z, accuracy: rgbRangeTolerance)
      
        XCTAssertEqual(fromRgb.R, toRgb.R, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromRgb.G, toRgb.G, accuracy: rgbRangeTolerance)
        XCTAssertEqual(fromRgb.B, toRgb.B, accuracy: rgbRangeTolerance)
      
      XCTAssertEqual(fromHex, toHex.string)
    }
  }
  
  func testRgbRangeTolerance() {
    for h in stride(from: 0.0, through: 360, by: 5) {
      for s in stride(from: 0.0, through: 100, by: 5) {
        for l in stride(from: 0.0, through: 100, by: 5) {
          let tRgb = hsluvToRgb(HSLuvTuple(h, s, l))
          let rgb = [tRgb.R, tRgb.G, tRgb.B]
          
          for channel in rgb {
            XCTAssertGreaterThan(channel, -rgbRangeTolerance, "HSLuv: \([h, s, l]) -> RGB: \(rgb)")
            XCTAssertLessThanOrEqual(channel, 1 + rgbRangeTolerance, "HSLuv: \([h, s, l]) -> RGB: \(rgb)")
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
