//
//  CircularImageView.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import UIKit

@IBDesignable
class CircularImageView: UIView {
  
  var backgroundLayer: CAShapeLayer!
  var imageLayer: CALayer!
  var userImage: UIImage?
  
  // Add fields to Attributes Inspector in Storyboard file.
  @IBInspectable var backgroundLayerColor: UIColor = UIColor.grayColor()
  @IBInspectable var image: UIImage?
  @IBInspectable var lineWidth: CGFloat = 1.0

  override func layoutSubviews() {
    super.layoutSubviews()
    setBackgroundLayer()
    setBackgroundImageLayer()
    setImage()
  }
  
  // Here we check to see if a backgroundLayer has been created. 
  // If not, we create a CAShapeLayer object and add it to the 
  // view’s sublayer. We then create a circular UIBezierPath and 
  // apply it to the backgroundLayer path. We then set the backgroundLayer’s 
  // lineWidth and fillColor.
  func setBackgroundLayer() {
    if backgroundLayer == nil {
      backgroundLayer = CAShapeLayer()
      layer.addSublayer(backgroundLayer)
      let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
      let path = UIBezierPath(ovalInRect: rect)
      backgroundLayer.path = path.CGPath
      backgroundLayer.lineWidth = lineWidth
      backgroundLayer.fillColor = backgroundLayerColor.CGColor
    }
    
    backgroundLayer.frame = layer.bounds
  }
  
  // Here we first check to see if imageLayer hasn’t been created. 
  // If it hasn’t we create a circular path and set this as 
  // imageLayer’s mask. Masking a layer makes that layer transparent 
  // where the mask is transparent.
  func setBackgroundImageLayer() {
    if imageLayer == nil {
      let mask = CAShapeLayer()
      let dx = lineWidth + 3.0
      let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
      mask.fillColor = UIColor.blackColor().CGColor
      mask.path = path.CGPath
      mask.frame = self.bounds
      layer.addSublayer(mask)
      imageLayer = CAShapeLayer()
      imageLayer.frame = self.bounds
      imageLayer.mask = mask
      imageLayer.contentsGravity = kCAGravityResizeAspectFill
      layer.addSublayer(imageLayer)
    }
  }
  
  // This checks to see whether userImage isn’t nil and if it’s not, 
  // the view’s image is set to that, otherwise it will be set to 
  // the image selected in Interface Builder.
  func setImage() {
    if imageLayer != nil {
      if let userPic = userImage {
        imageLayer.contents = userPic.CGImage
      } else {
        if let pic = image {
          imageLayer.contents = pic.CGImage
        }
      }
    }
  }
}
