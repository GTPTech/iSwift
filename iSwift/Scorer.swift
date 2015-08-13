//
//  Scorer.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation

// 👫 Command
// -----------
// The command pattern is used to express a request, 
// including the call to be made and all of its required 
// parameters, in a command object. The command may then 
// be executed immediately or held for later use.
// ------------------------------------------------------

// 🐝 Chain Of Responsibility
// --------------------------
// The chain of responsibility pattern is used to process 
// varied requests, each of which may be dealt with by a 
// different handler.
// ------------------------------------------------------

// Define your Command type, and declare its behavior 
// to accept a collection of past turns that you can 
// iterate over using the Iterator design pattern.
protocol Scorer {
  func computeScoreIncrement<S: SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int
  
  var nextScorer: Scorer? { get set }
}

// Declare a concrete implementation of Scorer that will 
// score turns based on whether they matched or not.
class MatchScorer: Scorer {
  var nextScorer: Scorer? = nil
  
  func computeScoreIncrement<S : SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int {
    var scoreIncrement: Int?
    
    // Use the Iterator design pattern to iterate over past turns.
    for turn in pastTurnsReversed {
      if scoreIncrement == nil {
        // Compute the score as +1 for a matched turn
        // and -1 for a non-matched turn.
        scoreIncrement = turn.matched! ? 1 : -1
        break
      }
    }
    
    // Help:
    // (a ?? b) is the same as, a != nil ? a! : b
    return (scoreIncrement ?? 0) + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
  }
}

class StreakScorer: Scorer {
  var nextScorer: Scorer? = nil
  
  func computeScoreIncrement<S : SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int {
    // Track streak length as the number of consecutive turns with successful matches.
    var streakLength = 0
    for turn in pastTurnsReversed {
      if turn.matched! {
        // If a turn is a match, the streak continues.
        ++streakLength
      } else {
        // If a turn is not a match, the streak is broken.
        break
      }
    }
    
    // Compute the streak bonus: 10 points for a streak of five or more consecutive matches!
    let streakBonus = streakLength >= 5 ? 10 : 0
    return streakBonus + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
  }
}