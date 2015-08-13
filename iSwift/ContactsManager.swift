//
//  ContactsManager.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 🎁 Façade
// ---------
// The facade pattern is used to define a simplified
// interface to a more complex subsystem.
// -------------------------------------------------

import Foundation

class ContactsManager: NSObject {
  
  // Here you declare a private property to hold AppUser data.
  // The array is mutable, so you can easily add and delete users.
  private var users = [AppUser]()

  override init() {
    super.init()
    createContacts()
  }
  
  func createContacts() {
    
    // Create dummy collection of AppUsers
    let bio = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
    let jane = AppUser(name: "Jane Doe", rating: "4", bio: bio, avatar: "jane.png")
    let john = AppUser(name: "John Doe", rating: "4", bio: bio, avatar: "john.png")
    let ann = AppUser(name: "Ann Greene", rating: "2", bio: bio, avatar: "ann.png")
    let rob = AppUser(name: "Rob Black", rating: "0", bio: bio, avatar: "rob.png")
    let sam = AppUser(name: "Sam Summers", rating: "5", bio: bio, avatar: "sam.png")
    
    users = [jane, john, ann, rob, sam]
  }
  
  // Get all users
  func getUsers() -> [AppUser] {
    return users
  }
  
  // Add new user
  func addUser(user: AppUser, index: Int) {
    if (users.count >= index) {
      users.insert(user, atIndex: index)
    } else {
      users.append(user)
    }
  }
  
  // Delete user at index
  func deleteUserAtIndex(index: Int) {
    users.removeAtIndex(index)
  }
}
