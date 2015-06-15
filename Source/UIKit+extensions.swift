//
//  UIKit+extensions.swift
//  HUSLSwift
//
//  Created by Clay Smith on 6/14/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import UIKit

public extension UIColor {
  /// Initializes and returns a color object using the specified opacity and
  /// HUSL color space component values.
  ///
  /// - parameter hue: CGFLoat
  /// - parameter saturation: CGFloat
  /// - parameter lightness: CGFloat
  /// - parameter alpha: CGFloat
  convenience init?(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
    if let color = huslToCGColor(Double(hue), S: Double(saturation), L: Double(lightness), alpha: Double(alpha)) {
      self.init(CGColor: color)
    } else {
      return nil
    }
  }
  
  /// Convenience function to wrap the behavior of getRed(red:green:blue:alpha:)
  ///
  /// - returns: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
  func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return (red: red, green: green, blue: blue, alpha: alpha)
  }
}