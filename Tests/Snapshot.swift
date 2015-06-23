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
  
  static var currentAPI: SnapshotType = {
    var current = SnapshotType()
    
    for sample in Snapshot.hexSamples {
      let color = HUSL(hex: sample)
      
      let rgb = color.RGB
      let xyz = color.XYZ
      let luv = color.LUV
      let lch = color.LCH
      
      current[sample] = [
        "rgb": [rgb.R, rgb.G, rgb.B],
        "xyz": [xyz.X, xyz.Y, xyz.Z],
        "luv": [luv.L, luv.U, luv.V],
        "lch": [lch.L, lch.C, lch.H],
        "husl": [color.hue, color.saturation, color.lightness]
      ]
    }
    
    return current
  }()
  
  static func compare(snapshot: SnapshotType, block: (hex: String, tag: String, stableTuple: [Double], currentTuple: [Double], stableChannel: Double, currentChannel: Double) -> ()) {
    
    hexes: for (hex, stableSamples) in stable {
      guard let currentSamples = current[hex] else {
        fatalError("Current sample is missing at \(hex)")
      }
      
      tags: for (tag, stableTuple) in stableSamples {
        if tag == "huslp" {
          continue tags
        }
        
        guard let currentTuple = currentSamples[tag] else {
          fatalError("Current tuple is missing at \(hex):\(tag)")
        }
        
        channels: for i in [0...2] {
          guard let stableChannel = stableTuple[i].first, currentChannel = currentTuple[i].first else {
            fatalError("Current channel is missing at \(hex):\(tag):\(i)")
          }
          
          block(hex: hex, tag: tag, stableTuple: stableTuple, currentTuple: currentTuple, stableChannel: stableChannel, currentChannel: currentChannel)
        }
        
      }
    }
    
  }
}