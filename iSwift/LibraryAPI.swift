//
//  LibraryAPI.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 💍 Singleton
// ------------
// The singleton pattern ensures that only one object of
// a particular class is ever created. All further references 
// to objects of the singleton class refer to the same 
// underlying instance. There are very few applications,
// do not overuse this pattern!
// ----------------------------------------------------------

import Foundation

// Using Patterns:
// Singleton                    : LibraryAPI.swift
// Facade                       : PersistencyManager.swift, HTTPClient.swift
// Decorator (Extensions)       : AlbumExtensions.swift
// Adapter (Protocol-Delegate)  : HorizontalScroller.swift
// Observer (Notifications)     : AlbumView.swift, LibraryAPI.swift (downloadImage) - Not active
// Observer (KVO)               : AlbumView.swift                                   - Not active
// Memento                      : TopRatedViewController.swift
// Archiving                    : Album.swift

class LibraryAPI: NSObject {
  
    private let persistencyManager: PersistencyManager
    private let contactsManager: ContactsManager
    private let httpClient: HTTPClient
    private let isOnline: Bool
  
    // Create a class variable as a computed type property.
    class var sharedInstance: LibraryAPI {
        // Nested within the class variable is a struct.
        struct Singleton {
            // Singleton wraps a static constant variable named instance.
            static let instance = LibraryAPI()
        }
        // Returns the computed type property.
        return Singleton.instance
    }
  
    override init() {
        persistencyManager = PersistencyManager()
        contactsManager = ContactsManager()
        httpClient = HTTPClient()
        isOnline = false
    
        super.init()
    
//        // NSNotification:
//        // The observer. Every time an AlbumView class posts a
//        // BLDownloadImageNotification notification, since LibraryAPI has
//        // registered as an observer for the same notification, the system notifies LibraryAPI.
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:"downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
  
    deinit {
//        // NSNotification:
//        // When this object is deallocated, it removes itself as an observer from all notifications it had registered for.
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
    // Archive albums
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
  
    // Get all albums
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
  
    // Call addAlbum directly
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
  
    // Call deleteAlbum directly
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
  
    // Call getUsers directly
    func getUsers() -> [AppUser] {
        return contactsManager.getUsers()
    }
  
//    // NSNotification:
//    // downloadImage executed via notifications and so the method receives the
//    // notification object as a parameter.
//    // The UIImageView and image URL are retrieved from the notification.
//    func downloadImage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let imageView = userInfo["imageView"] as! UIImageView?
//        let coverUrl = userInfo["coverUrl"] as! String
//    
//        // Retrieve the image from the PersistencyManager if it’s been downloaded previously.
//        if let imageViewUnWrapped = imageView {
//            imageViewUnWrapped.image = persistencyManager.getImage(coverUrl.lastPathComponent)
//            if imageViewUnWrapped.image == nil {
//                // If the image hasn’t already been downloaded, then retrieve it using HTTPClient.
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                    let downloadedImage = self.httpClient.downloadImage(coverUrl as String)
//                    // When the download is complete, display the image in the image view and use the PersistencyManager to save it locally.
//                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                        imageViewUnWrapped.image = downloadedImage
//                        self.persistencyManager.saveImage(downloadedImage, filename: coverUrl.lastPathComponent)
//                    })
//                })
//            }
//        }
//    }
  
    // Completion blocks
    func downloadData(sourceUrl: NSString, completionHandler:(data: NSData) -> Void) {
        // if we have a local cached copy then use it
        if let cachedData = persistencyManager.getData(sourceUrl.lastPathComponent) {
//            NSLog("using cached version")
            completionHandler(data: cachedData)
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let downloadedData = self.httpClient.downloadData(sourceUrl as String)
                self.persistencyManager.saveData(downloadedData, filename: sourceUrl.lastPathComponent)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(data: downloadedData)
                }
            }
        }
    }
}
