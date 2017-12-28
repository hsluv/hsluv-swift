//
//  Snapshot.swift
//  HSLuvSwift
//
//  Created by Clay Smith on 6/17/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation
import XCTest
@testable import HSLuvSwift

// TODO: Add HPLuv support

typealias SnapshotType = [String: [String: [Double]]]

class Snapshot {
  static var hexSamples: [String] = {
    let samples = "0123456789abcdef"
    
    var hexSamples = [String]()
    for (_, r) in samples.enumerated() {
      for (_, g) in samples.enumerated() {
        for (_, b) in samples.enumerated() {
          hexSamples.append("#\(r)\(r)\(g)\(g)\(b)\(b)")
        }
      }
    }
    
    return hexSamples
    }()
  
  static var stable: SnapshotType = {
    guard let url = Bundle(for: Snapshot.self).url(forResource: "snapshot-rev4", withExtension: "json") else {
      fatalError("Snapshot JSON file is missing")
    }
    
    let jsonData = try! Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
    let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! SnapshotType
    
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
      let hsluv = lchToHsluv(lch)
      
      current[sample] = [
        "rgb": [rgb.R, rgb.G, rgb.B],
        "xyz": [xyz.X, xyz.Y, xyz.Z],
        "luv": [luv.L, luv.U, luv.V],
        "lch": [lch.L, lch.C, lch.H],
        "hsluv": [hsluv.H, hsluv.S, hsluv.L]
      ]
    }
    
    return current
  }()
  
  static func compare(_ snapshot: SnapshotType, block: (_ hex: String, _ tag: String, _ stableTuple: [Double], _ currentTuple: [Double], _ stableChannel: Double, _ currentChannel: Double) -> ()) {
    
    hexes: for (hex, stableSamples) in stable {
      guard let currentSamples = current[hex] else {
        fatalError("Current sample is missing at \(hex)")
      }
      
      tags: for (tag, stableTuple) in stableSamples {
        if tag == "hpluv" {
          continue tags
        }
        
        guard let currentTuple = currentSamples[tag] else {
          fatalError("Current tuple is missing at \(hex):\(tag)")
        }
        
        channels: for i in [0...2] {
          guard let stableChannel = stableTuple[i].first, let currentChannel = currentTuple[i].first else {
            fatalError("Current channel is missing at \(hex):\(tag):\(i)")
          }
          
          block(hex, tag, stableTuple, currentTuple, stableChannel, currentChannel)
        }
        
      }
    }
    
  }
}
