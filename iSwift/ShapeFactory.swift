//
//  ShapeFactory.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit

// 🌰 Abstract Factory
// -------------------
// The abstract factory pattern is used to provide a client with 
// a set of related or dependant objects. The "family" of objects 
// created by the factory are determined at run-time.
// --------------------------------------------------------------

// Simplify the creation of shapes.

// ShapeFactory is a protocol to build in maximum flexibility, 
// just like in ShapeViewFactory.
protocol ShapeFactory {
  func createShapes() -> (Shape, Shape)
}

// Build Square Shapes
class SquareShapeFactory: ShapeFactory {
  
  // You want your shape factory to produce shapes that have dimensions 
  // in unit terms, for instance, in a range like [0, 1] — so you store this range.
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    
    // Create the first square shape with random dimensions.
    let shape1 = SquareShape()
    shape1.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    // Create the second square shape with random dimensions.
    let shape2 = SquareShape()
    shape2.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    // Return the pair of square shapes as a tuple.
    return (shape1, shape2)
  }
}

// Build Circular Shapes
class CircleShapeFactory: ShapeFactory {
  var minProportion: CGFloat
  var maxProportion: CGFloat
  
  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }
  
  func createShapes() -> (Shape, Shape) {
    
    let shape1 = CircleShape()
    shape1.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    let shape2 = CircleShape()
    shape2.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)
    
    return (shape1, shape2)
  }
}