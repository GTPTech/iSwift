//
//  ShapeView.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit

// ShapeView is the view that renders a generic Shape model.
class ShapeView: UIView {
  var shape: Shape!
  
  // Indicate if the app should fill the shape with a color, 
  // and if so, which color. This is the solid interior color of the shape.
  var showFill: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var fillColor: UIColor = UIColor.orangeColor() {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // Indicate if the app should stroke the shape’s outline with a color, 
  // and if so, which color. This is the color of the shape’s border.
  var showOutline: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var outlineColor: UIColor = UIColor.grayColor() {
    didSet{
      setNeedsDisplay()
    }
  }
  
  // A closure that handles taps (e.g. to adjust the score). 
  var tapHandler: ((ShapeView) -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Set up a tap gesture recognizer that invokes handleTap when the player taps the view.
    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
    addGestureRecognizer(tapRecognizer)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Invoke the tapHandler when the gesture recognizer recognizes a tap gesture.
  func handleTap() {
    tapHandler?(self)
  }
  
  let halfLineWidth: CGFloat = 3.0
}

class SquareShapeView: ShapeView {
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    // If configured to show fill, then fill in the view with the fill color.
    if showFill {
      fillColor.setFill()
      let fillPath = UIBezierPath(rect: bounds)
      fillPath.fill()
    }
    
    // If configured to show an outline, then outline the view with the outline color.
    if showOutline {
      outlineColor.setStroke()
      let outlinePath = UIBezierPath(rect: CGRect(x: halfLineWidth, y: halfLineWidth, width: bounds.size.width - 2 * halfLineWidth, height: bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}

class CircleShapeView: ShapeView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    // Since a circle cannot fill the rectangular bounds of its view, 
    // you need to tell UIKit that the view is not opaque, meaning 
    // content behind it may poke through. If you miss this, 
    // then the circles will have an ugly black background.
    self.opaque = false
    
    // Because the view is not opaque, you should redraw 
    // the view when its bounds change.
    self.contentMode = UIViewContentMode.Redraw
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    if showFill {
      fillColor.setFill()
      // Draw a circle filled with the fillColor. In a moment, you’ll 
      // create CircleShapeViewFactory, which will ensure that CircleView
      // has equal width and height so the shape will be a circle and not an ellipse.
      let fillPath = UIBezierPath(ovalInRect: self.bounds)
      fillPath.fill()
    }
    
    if showOutline {
      outlineColor.setStroke()
      // Stroke the outline border of the circle and inset to account for line width.
      let outlinePath = UIBezierPath(ovalInRect: CGRect(
        x: halfLineWidth,
        y: halfLineWidth,
        width: self.bounds.size.width - 2 * halfLineWidth,
        height: self.bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}



