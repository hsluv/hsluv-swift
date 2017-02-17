//: # HSLuvSwift
//:
//: Swift port of HSLuv, a human-friendly alternative to HSL

import UIKit
import HSLuvSwift

//: ## Examples
//:
//: The new UIColor initializer works exactly as you would expect.
let color = UIColor(hue: 360, saturation: 100.0, lightness: 50.0, alpha: 1.0)
let colorView = UIView(frame: squareRect)
colorView.backgroundColor = color

//: Alpha transparency is supported
let fiftyPc = UIColor(hue: 200, saturation: 100, lightness: 50, alpha: 0.25)
let fiftyPcView = UIView(frame: squareRect)
fiftyPcView.backgroundColor = fiftyPc

//: ## Let's make a rainbow!
var colors = [UIColor?]()
for H in stride(from: 0, through: 360, by: 5.0) {
  colors.append(UIColor(hue: H, saturation: 100.0, lightness: 50.0, alpha: 1.0))
}

if #available(iOS 9.0, *) {
    var palette = PaletteView(frame: CGRect(x: 0, y: 0, width: 500, height: 100), numberOfColors: 37)
  
  palette.addColors(colors)
}

