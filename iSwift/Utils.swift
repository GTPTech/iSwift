//
//  Utils.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/22/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import Foundation
import UIKit

class Utils {
  class func randomBetweenLower(lower: CGFloat, andUpper: CGFloat) -> CGFloat {
    return lower + CGFloat(arc4random_uniform(101)) / 100.0 * (andUpper - lower)
  }
}