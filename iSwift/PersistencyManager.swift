//
//  PersistencyManager.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 🎁 Façade
// ---------
// The facade pattern is used to define a simplified 
// interface to a more complex subsystem.
// -------------------------------------------------

import Foundation

class PersistencyManager: NSObject {
  
  // Here you declare a private property to hold album data. 
  // The array is mutable, so you can easily add and delete albums.
  private var albums = [Album]()
  
  override init() {
      super.init()

      // Archive:
      // NSKeyedUnarchiver loads the album data from the file, if it exists. 
      // If it doesn’t exist, it creates the album data and immediately 
      // saves it for the next launch of the app.
      if let data = NSData(contentsOfURL: localDirectoryURL(.DocumentDirectory).URLByAppendingPathComponent("albums.bin")) {
          let unarchiveAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Album]?
          if let unwrappedAlbum = unarchiveAlbums {
              albums = unwrappedAlbum
          }
      } else {
          createPlaceholderAlbum()
      }
  }
  
  func createPlaceholderAlbum() {
    // Create dummy list of albums.
    let album1 = Album(title: "Best of Bowie",
      artist: "David Bowie",
      genre: "Pop",
      coverUrl: "http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png",
      year: "1992")
    
    let album2 = Album(title: "It's My Life",
      artist: "No Doubt",
      genre: "Pop",
      coverUrl: "http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png",
      year: "2003")
    
    let album3 = Album(title: "Nothing Like The Sun",
      artist: "Sting",
      genre: "Pop",
      coverUrl: "http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png",
      year: "1999")
    
    let album4 = Album(title: "Staring at the Sun",
      artist: "U2",
      genre: "Pop",
      coverUrl: "http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png",
      year: "2000")
    
    let album5 = Album(title: "American Pie",
      artist: "Madonna",
      genre: "Pop",
      coverUrl: "http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png",
      year: "2000")
    
    albums = [album1, album2, album3, album4, album5]
    saveAlbums()
  }
  
  // Return albums array
  func getAlbums() -> [Album] {
    return albums
  }
  
  // Add new album
  func addAlbum(album: Album, index: Int) {
    if (albums.count >= index) {
      albums.insert(album, atIndex: index)
    } else {
      albums.append(album)
    }
  }
  
  // Remove album at index
  func deleteAlbumAtIndex(index: Int) {
    albums.removeAtIndex(index)
  }
  
  // Archive:
  // Archive all albums
  func saveAlbums() {
    let fileURL: NSURL = localDirectoryURL(.DocumentDirectory).URLByAppendingPathComponent("albums.bin")
    let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
    data.writeToURL(fileURL, atomically: true)
  }

  // Save data
  func saveData(data: NSData, filename: String) {
    let fileURL = localDirectoryURL(.CachesDirectory).URLByAppendingPathComponent(filename)
    data.writeToURL(fileURL, atomically: true)
  }
  
  // Get data
  func getData(filename: String) -> NSData? {
    let fileURL: NSURL = localDirectoryURL(.CachesDirectory).URLByAppendingPathComponent(filename)
    return NSData(contentsOfURL: fileURL)
  }
  
  // Get local directory URL
  func localDirectoryURL(directory: NSSearchPathDirectory) -> NSURL {
    return NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: .UserDomainMask)[0] 
  }
  
//  // Save image to cache
//  func saveImage(image: UIImage, filename: String) {
//    let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
//    let data = UIImagePNGRepresentation(image)
//    data?.writeToFile(path, atomically: true)
//  }
//  
//  // Get image from cache
//  func getImage(filename: String) -> UIImage? {
//    let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
//    
//    do {
//      let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.UncachedRead)
//      return UIImage(data: data)
//    } catch {
//      print("Error")
//    }
//    return nil
//  }
}
