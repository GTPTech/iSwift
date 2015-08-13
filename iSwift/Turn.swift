//
//  Turn.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation

class Turn {
  // Store the shapes that the player saw during the turn, 
  // and also whether the turn was a match or not.
  let shapes: [Shape]
  var matched: Bool?
  
  init(shapes: [Shape]) {
    self.shapes = shapes
  }
  
  // Records the completion of a turn after a player taps a shape.
  func turnCompletedWithTappedShape(tappedShape: Shape) {
    let maxArea = shapes.reduce(0) { $0 > $1.area ? $0 : $1.area }
    matched = tappedShape.area >= maxArea
  }
}