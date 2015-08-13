//
//  AppUser.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import UIKit

class AppUser: NSObject {
  
  var name: String!
  var rating: String!
  var bio: String!
  var avatar: String!
  
  init(name: String, rating: String, bio: String, avatar: String) {
    self.name = name
    self.rating = rating
    self.bio = bio
    self.avatar = avatar
    super.init()
  }
}