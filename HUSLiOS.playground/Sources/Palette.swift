import UIKit

public let squareRect = CGRectMake(0, 0, 75, 75)

@available(iOS 9.0, *)
public class PaletteView: UIStackView {
  var subviewRect: CGRect!
  
  required public init(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  public init(frame: CGRect, numberOfColors colors: Int) {
    super.init(frame: frame)
    
    if frame.width > frame.height {
      axis = .Horizontal
      subviewRect = CGRectMake(0, 0, frame.width / CGFloat(colors), frame.height)
    } else {
      axis = .Vertical
      subviewRect = CGRectMake(0, 0, frame.width, frame.height / CGFloat(colors))
    }
    
    distribution = .FillEqually
  }
  
  public func addColor(color: UIColor?) {
    guard let color = color else {
      print("Color is missing for view")
      return
    }
    
    let view = UIView(frame: subviewRect)
    view.backgroundColor = color
    
    self.addArrangedSubview(view)    
  }
  
  public func addColors(colors: [UIColor?]) {
    for color in colors {
      addColor(color)
    }
  }
}