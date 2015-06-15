//
//  ColorSpaces.swift
//  HUSLSwift
//
//  Created by Clay Smith on 6/15/15.
//  Copyright © 2015 Clay Smith. All rights reserved.
//

import Foundation

// Using structs instead of tuples prevents implicit conversion,
// which was making debugging difficult

typealias Tuple = (Double, Double, Double)

protocol Deconstructable {
  var tuple: Tuple { get }
}

struct HUSL: Deconstructable {
  var H: Double
  var S: Double
  var L: Double
  
  init(_ H: Double, _ S: Double, _ L: Double) {
    self.H = H
    self.S = S
    self.L = L
  }
  
  var tuple: Tuple {
    return (H: H, S: S, L: L)
  }
}

struct XYZ: Deconstructable {
  var X: Double
  var Y: Double
  var Z: Double
  
  init(_ X: Double, _ Y: Double, _ Z: Double) {
    self.X = X
    self.Y = Y
    self.Z = Z
  }
  
  var tuple: Tuple {
    return (X: X, Y: Y, Z: Z)
  }
}

struct RGB: Deconstructable {
  var R: Double
  var G: Double
  var B: Double
  
  init(_ R: Double, _ G: Double, _ B: Double) {
    self.R = R
    self.G = G
    self.B = B
  }
  
  var tuple: Tuple {
    return (R: R, G: G, B: B)
  }
}

struct LCH: Deconstructable {
  var L: Double
  var C: Double
  var H: Double
  
  init(_ L: Double, _ C: Double, _ H: Double) {
    self.L = L
    self.C = C
    self.H = H
  }
  
  var tuple: Tuple {
    return (L: L, C: C, H: H)
  }
}

struct LUV: Deconstructable {
  var L: Double
  var U: Double
  var V: Double
  
  init(_ L: Double, _ U: Double, _ V: Double) {
    self.L = L
    self.U = U
    self.V = V
  }
  
  var tuple: Tuple {
    return (L: L, U: U, V: V)
  }
}