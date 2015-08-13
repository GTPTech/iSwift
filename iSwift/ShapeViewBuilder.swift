//
//  ShapeViewBuilder.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit


// 👷 Builder
// ----------
// The builder pattern is used to create complex objects with 
// constituent parts that must be created in the same order or 
// using a specific algorithm. An external class controls the 
// construction algorithm.
// -----------------------------------------------------------


class ShapeViewBuilder {
  // Store configuration to set ShapeView fill properties.
  var showFill = true
  var fillColor = UIColor.orangeColor()
  
  // Store configuration to set ShapeView outline properties.
  var showOutline = true
  var outlineColor = UIColor.grayColor()
  
  // Initialize the builder to hold a ShapeViewFactory to construct the views. 
  // This means the builder doesn’t need to know if it’s building 
  // SquareShapeView or CircleShapeView or even some other kind of shape view.
  init(shapeViewFactory: ShapeViewFactory) {
    self.shapeViewFactory = shapeViewFactory
  }
  
  // This is the public API; it creates and initializes a 
  // pair of ShapeView when there’s a pair of Shape.
  func buildShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes)
    configureShapeView(shapeViews.0)
    configureShapeView(shapeViews.1)
    return shapeViews
  }
  
  // Do the actual configuration of a ShapeView based on the builder’s stored configuration.
  private func configureShapeView(shapeView: ShapeView) {
    shapeView.showFill = showFill
    shapeView.fillColor = fillColor
    shapeView.showOutline = showOutline
    shapeView.outlineColor = outlineColor
  }
  
  private var shapeViewFactory: ShapeViewFactory
}