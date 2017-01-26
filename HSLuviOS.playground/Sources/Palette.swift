import UIKit

public let squareRect = CGRect(x: 0, y: 0, width:75, height:75)

@available(iOS 9.0, *)
public class PaletteView: UIStackView {
  var subviewRect: CGRect!
  
  required public init(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  public init(frame: CGRect, numberOfColors colors: Int) {
    super.init(frame: frame)
    
    if frame.width > frame.height {
      axis = .horizontal
        subviewRect = CGRect(x: 0, y: 0, width: frame.width / CGFloat(colors), height: frame.height)
    } else {
      axis = .vertical
        subviewRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / CGFloat(colors))
    }
    
    distribution = .fillEqually
  }
  
  public func addColor(_ color: UIColor?) {
    guard let color = color else {
      print("Color is missing for view")
      return
    }
    
    let view = UIView(frame: subviewRect)
    view.backgroundColor = color
    
    self.addArrangedSubview(view)    
  }
  
  public func addColors(_ colors: [UIColor?]) {
    for color in colors {
      addColor(color)
    }
  }
}
