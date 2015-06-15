//
//  CGColor.swift
//  HUSLSwift
//
//  Created by Clay Smith on 6/15/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation
import CoreGraphics

func huslToCGColor(H: Double, S: Double, L: Double, alpha: Double) -> CGColor? {
  let (R, G, B) = huslToRgb(HUSL(H, S, L)).tuple
  let components = [CGFloat(R), CGFloat(G), CGFloat(B), CGFloat(alpha)]
  
  return CGColorCreate(CGColorSpaceCreateDeviceRGB(), components)
}