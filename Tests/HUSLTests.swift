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

class HUSLTests: XCTestCase {
  
  let tolerance = 0.00000001
  
  lazy var snapshot: NSDictionary = {
    guard let url = NSBundle(forClass: self.dynamicType).URLForResource("snapshot-rev3", withExtension: "json") else {
      fatalError("Snapshot JSON file is missing")
    }
    
    let jsonData = try! NSData(contentsOfURL: url, options: NSDataReadingOptions.DataReadingMappedIfSafe)
    let jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    
    return jsonResult
  }()
  
  lazy var hexSamples: [String] = {
    let samples = "0123456789abcdef"
    
    var hexSamples = [String]()
    for (_, r) in samples.characters.enumerate() {
      for (_, g) in samples.characters.enumerate() {
        for (_, b) in samples.characters.enumerate() {
          hexSamples.append("#\(r)\(r)\(g)\(g)\(b)\(b)")
        }
      }
    }
    
    return hexSamples
  }()
  
  private func arrayify(tuple: Tuple) -> [Double] {
    return [tuple.0, tuple.1, tuple.2]
  }
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    continueAfterFailure = false
  }
  
  func testRgbRangeTolerance() {
    for h in stride(from: 0.0, through: 360, by: 50) {
      for s in stride(from: 0.0, through: 100, by: 50) {
        for l in stride(from: 0.0, through: 100, by: 50) {
          let rgb = arrayify(HUSL(h, s, l, 1.0).RGB)
          
          for channel in rgb {
            XCTAssertGreaterThanOrEqual(channel, -tolerance)
            XCTAssertLessThanOrEqual(channel, 1 + tolerance)
          }
        }
      }
    }
  }
  
  func testHuslConsistency() {
    var hexResults = [String]()
    for fromHex in hexSamples {
      let toHex = rgbToHex(huslToRgb(rgbToHusl(hexToRgb(Hex(string: fromHex)))))
      hexResults.append(toHex.string)
    }
    
    XCTAssertEqual(hexSamples, hexResults)
  }
  
//  func testHuslPConsistency() {
//    var hexResults = [String]()
//    for fromHex in hexSamples {
//      let toHex = rgbToHex(huslToRgb(rgbToHusl(hexToRgb(Hex(string: fromHex)))))
//      hexResults.append(toHex.string)
//    }
//    
//    XCTAssertEqual(hexSamples, hexResults)
//  }
  
  
}
