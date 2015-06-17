//
//  Snapshot.swift
//  HUSLSwift
//
//  Created by Clay Smith on 6/17/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation
import XCTest
@testable import HUSLSwift

// TODO: Add HUSLP support

class Snapshot {
  typealias SnapshotType = [String: [String: [Double]]]
  
  static var hexSamples: [String] = {
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
  
  static var stable: SnapshotType = {
    guard let url = NSBundle(forClass: Snapshot.self).URLForResource("snapshot-rev4", withExtension: "json") else {
      fatalError("Snapshot JSON file is missing")
    }
    
    let jsonData = try! NSData(contentsOfURL: url, options: NSDataReadingOptions.DataReadingMappedIfSafe)
    let jsonResult = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! SnapshotType
    
    return jsonResult
  }()
  
  static var current: SnapshotType = {
    var current = SnapshotType()
    
    for sample in Snapshot.hexSamples {
      let hex = Hex(sample)
      
      let rgb = hexToRgb(hex)
      let xyz = rgbToXyz(rgb)
      let luv = xyzToLuv(xyz)
      let lch = luvToLch(luv)
      let husl = lchToHusl(lch)
      
      current[sample] = [
        "rgb": [rgb.R, rgb.G, rgb.B],
        "xyz": [xyz.X, xyz.Y, xyz.Z],
        "luv": [luv.L, luv.U, luv.V],
        "lch": [lch.L, lch.C, lch.H],
        "husl": [husl.H, husl.S, husl.L]
      ]
    }
    
    return current
  }()
}