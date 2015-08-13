//
//  GameViewController.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit

// Intermediate Design Patterns:
// Abstract Factory               : ShapeFactory.swift, ShapeViewFactory.swift
// Servant                        : Shape.swift (area property)
// Builder                        : ShapeViewBuilder.swift
// Dependency Injection           : TurnController.swift, Turn.swift
// Strategy                       : TurnStrategy.swift
// Chain of Responsibility        : Scorer.swift (nextScorer property)
// Command                        : Scorer.swift
// Iterator (for-in loops)

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Create a strategy to create squares.
    let squareShapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let squareShapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let squareShapeViewBuilder = shapeViewBuilderForFactory(squareShapeViewFactory)
    let squareTurnStrategy = BasicTurnStrategy(shapeFactory: squareShapeFactory, shapeViewBuilder: squareShapeViewBuilder)
    
    // Create a strategy to create circles.
    let circleShapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let circleShapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let circleShapeViewBuilder = shapeViewBuilderForFactory(circleShapeViewFactory)
    let circleTurnStrategy = BasicTurnStrategy(shapeFactory: circleShapeFactory, shapeViewBuilder: circleShapeViewBuilder)
    
    // Create a strategy to randomly select either your square or circle strategy.
    let randomTurnStrategy = RandomTurnStrategy(firstStrategy: squareTurnStrategy, secondStrategy: circleTurnStrategy)
    
    // Create your turn controller to use the random strategy.
    turnController = TurnController(turnStrategy: randomTurnStrategy)
    
    beginNextTurn()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  private func shapeViewBuilderForFactory(shapeViewFactory: ShapeViewFactory) -> ShapeViewBuilder {
    let shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
    shapeViewBuilder.fillColor = UIColor.brownColor()
    shapeViewBuilder.outlineColor = UIColor.orangeColor()
    return shapeViewBuilder
  }
  
  private func beginNextTurn() {
  
    // Asks the TurnController to begin a new turn and 
    // return a tuple of ShapeView to use for the turn.
    let shapeViews = turnController.beginNewTurn()

    shapeViews.0.tapHandler = {
      tappedView in
      // Informs the turn controller that the turn is over when the
      // player taps a ShapeView, and then it increments the score.
      // Notice how TurnController abstracts score calculation away,
      // further simplifying GameViewController.
      self.gameView.score += self.turnController.endTurnWithTappedShape(tappedView.shape)
      self.beginNextTurn()
    }
    
    // Since you removed explicit references to specific shapes, 
    // the second shape view can share the same tapHandler closure 
    // as the first shape view.
    shapeViews.1.tapHandler = shapeViews.0.tapHandler
    
    gameView.addShapeViews(shapeViews)
  }
  
  // Outlet for the custom view
  private var gameView: GameView { return view as! GameView }
  
  // Store TurnController as an instance property.
  private var turnController: TurnController!
}
