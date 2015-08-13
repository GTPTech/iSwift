//
//  HTTPClient.swift
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

class HTTPClient {
  
  func downloadData(url: String) -> NSData {
    let aUrl = NSURL(string: url)
    let data = NSData(contentsOfURL: aUrl!)
    return data!
  }
  
  func getRequest(url: String) -> (AnyObject) {
    return NSData()
  }

  func postRequest(uri: String, body: String) -> (AnyObject) {
    return NSData()
  }
  
//  func downloadImage(url: String) -> (UIImage) {
//    let aUrl = NSURL(string: url)
//    let data = NSData(contentsOfURL: aUrl!)
//    let image = UIImage(data: data!)
//    return image!
//  }
}
