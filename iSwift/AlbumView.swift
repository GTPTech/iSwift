//
//  AlbumView.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 👓 Observer
// -----------
// The observer pattern is used to allow an object to 
// publish changes to its state. Other objects subscribe 
// to be immediately notified of any changes.
// -----------------------------------------------------

import UIKit

class AlbumView: UIView {

    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
  
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        commonInit()
      
//        // KVO:
//        // Observe changes to the image property of the UIImageView that holds the image.
//        coverImage.addObserver(self, forKeyPath: "image", options: nil, context: nil)
//      
//        // NSNotification:
//        // Sends a notification through the NSNotificationCenter singleton.
//        // The notification info contains the UIImageView to populate and the URL of the cover image to be downloaded.
//        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView":coverImage, "coverUrl" : albumCover])
      
        // Completion blocks:
        // Call downlaodData and on completion, perform UIImage-NAData conversion.
        LibraryAPI.sharedInstance.downloadData(albumCover, completionHandler: { data in
            let image = UIImage(data: data)
            self.coverImage.image = image
            self.indicator.stopAnimating()
        })
    }
  
    deinit {
//        // KVO:
//        // Unregister as an observer when you’re done.
//        coverImage.removeObserver(self, forKeyPath: "image")
    }
  
    // Programmatically create the view.
    func commonInit() {
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
    }
  
    func highlightAlbum(didHighlightView didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
  
//    // KVO:
//    // You must implement this method in every class acting as an observer. 
//    // The system executes this method every time an observed property changes.
//    // Stop the spinner when the “image” property changes.
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "image" {
//            indicator.stopAnimating()
//        }
//    }
}
