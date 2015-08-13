//
//  TurnStrategy.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation

// 💡 Strategy
// -----------
// The strategy pattern is used to create an interchangeable
// family of algorithms from which the required process is 
// chosen at run-time.
// ---------------------------------------------------------


// Declare the behavior of the algorithm. This is defined in a protocol, 
// with one method. The method takes an array of the past turns in the game, 
// and returns the shape views to display for the next turn.
protocol TurnStrategy {
  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView)
}

// Implement a basic strategy that uses a ShapeFactory and ShapeViewBuilder. 
// This strategy implements the existing behavior, where the shape views just 
// come from the single factory and builder as before. Notice how you’re 
// using Dependency Injection again here, and that means this strategy doesn’t 
// care which factory or builder it’s using.
class BasicTurnStrategy: TurnStrategy {
  let shapeFactory: ShapeFactory
  let shapeViewBuilder: ShapeViewBuilder
  
  init(shapeFactory: ShapeFactory, shapeViewBuilder: ShapeViewBuilder) {
    self.shapeFactory = shapeFactory
    self.shapeViewBuilder = shapeViewBuilder
  }
  
  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
    return shapeViewBuilder.buildShapeViewsForShapes(shapeFactory.createShapes())
  }
}

class RandomTurnStrategy: TurnStrategy {
  // Implement a random strategy which randomly uses one of two other 
  // strategies. You’ve used composition here so that RandomTurnStrategy 
  // can behave like two potentially different strategies. 
  // However, since it’s a Strategy, that composition is hidden 
  // from whatever code uses RandomTurnStrategy.
  let firstStrategy: TurnStrategy
  let secondStrategy: TurnStrategy
  
  init(firstStrategy: TurnStrategy, secondStrategy: TurnStrategy) {
    self.firstStrategy = firstStrategy
    self.secondStrategy = secondStrategy
  }
  
  // This is the "meat" of the random strategy.
  // It randomly selects either the first or second 
  // strategy with a 50 percent chance.
  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
    if Utils.randomBetweenLower(0.0, andUpper: 100.0) < 50.0 {
      return firstStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns)
    } else {
      return secondStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns)
    }
  }
}