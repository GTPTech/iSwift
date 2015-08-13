//
//  Shape.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit

// The Shape class is the basic model for tappable shapes in the game.
class Shape {
  var area: CGFloat { return 0 }
}

// The concrete subclass SquareShape represents a square: a polygon with four equal-length sides.
class SquareShape: Shape {
  var sideLength: CGFloat!
  
  override var area: CGFloat { return sideLength * sideLength }
}

class CircleShape: Shape {
  var diameter: CGFloat!
  
  override var area: CGFloat { return CGFloat(M_PI) * diameter * diameter / 4.0 }
}
