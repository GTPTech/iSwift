//
//  AlbumExtensions.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 🍧 Decorator
// ------------
// The decorator pattern is used to extend or alter the 
// functionality of objects at run- time by wrapping them in 
// an object of a decorator class. This provides a flexible 
// alternative to using inheritance to modify behaviour.
// ---------------------------------------------------------

import Foundation

extension Album {
  func ae_tableRepresentation() -> (titles:[String], values:[String]) {
    return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
  }
}