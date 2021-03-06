//
//  ShapeViewFactory.swift
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

// Define ShapeViewFactory as a Swift protocol.
protocol ShapeViewFactory {
  // Each factory should have a size that defines the bounding box
  // of the shapes it creates. This is essential to layout 
  // code using the factory-produced views.
  var size: CGSize { get set }
  
  // Define the method that produces shape views. 
  // This is the “meat” of the factory. It takes a tuple of two Shape 
  // objects and returns a tuple of two ShapeView objects. 
  // This essentially manufactures views from its raw materials — the models.
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView)
}

class SquareShapeViewFactory: ShapeViewFactory {
  var size: CGSize
  
  // Initialize the factory to use a consistent maximum size.
  init(size: CGSize) {
    self.size = size
  }
  
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    
    // Construct the first shape view from the first passed shape.
    let squareShape1 = shapes.0 as! SquareShape
    let shapeView1 = SquareShapeView(frame: CGRect(x: 0, y: 0, width: squareShape1.sideLength * size.width, height: squareShape1.sideLength * size.height))
    shapeView1.shape = squareShape1
    
    // Construct the second shape view from the second passed shape.
    let squareShape2 = shapes.1 as! SquareShape
    let shapeView2 = SquareShapeView(frame: CGRect(x: 0, y: 0, width: squareShape2.sideLength * size.width, height: squareShape2.sideLength * size.height))
    shapeView2.shape = squareShape2
    
    // Return a tuple containing the two created shape views.
    return (shapeView1, shapeView2)
  }
}

class CircleShapeViewFactory: ShapeViewFactory {
  var size: CGSize
  
  init(size: CGSize) {
    self.size = size
  }
  
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let circleShape1 = shapes.0 as! CircleShape
    let shapeView1 = CircleShapeView(frame: CGRect(x: 0, y: 0, width: circleShape1.diameter * size.width, height: circleShape1.diameter * size.height))
    shapeView1.shape = circleShape1
    
    let circleShape2 = shapes.1 as! CircleShape
    let shapeView2 = CircleShapeView(frame: CGRect(x: 0, y: 0, width: circleShape2.diameter * size.width, height: circleShape2.diameter * size.height))
    shapeView2.shape = circleShape2
    
    return (shapeView1, shapeView2)
  }
}