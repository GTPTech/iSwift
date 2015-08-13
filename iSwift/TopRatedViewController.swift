//
//  TopRatedViewController.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 💾 Memento
// ----------
// The memento pattern is used to capture the current 
// state of an object and store it in such a manner that 
// it can be restored at a later time without breaking 
// the rules of encapsulation.
// -----------------------------------------------------

import UIKit

class TopRatedViewController: UIViewController {

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var scroller: HorizontalScroller!
  
    private var allAlbums = [Album]()
    private var currentAlbumData : (titles:[String], values:[String])?
    private var currentAlbumIndex = 0
  
    // We will use this array as a stack to push and pop operation for the undo option
    // Hold a tuple of two arguments, an Album and the the index of the album.
    var undoStack: [(Album, Int)] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Set initial Album index
        currentAlbumIndex = 0
      
        // Get a list of all the albums via the API.
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
      
        // Setup the UITableView.
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
      
        // This loads the current Album at app launch.
        self.showDataForAlbum(currentAlbumIndex)
      
        // Loads previously saved stste.
        loadPreviousState()
      
        // Initialize scroller
        scroller.delegate = self
        reloadScroller()
      
        // NSNotification:
        // Send a UIApplicationDidEnterBackgroundNotification notification
        // when the app enters the background in order to save last state.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
      
        let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: "undoAction")
        undoButton.enabled = false
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAlbum")
        navigationItem.setRightBarButtonItem(trashButton, animated: true)
        navigationItem.setLeftBarButtonItem(undoButton, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    deinit {
        // NSNotification:
        // Un-register for notifications.
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
    func showDataForAlbum(albumIndex: Int) {
        // Defensive code: make sure the requested index is lower than the amount of albums
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            // Fetch the album
            let album = allAlbums[albumIndex]
      
            // Save the albums data to present it later in the tableview
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
      
        // We have the data we need, let's refresh our tableview
        dataTable!.reloadData()
    }
  
    // This method loads album data via LibraryAPI and then sets the 
    // currently displayed view based on the current value of the current view index.
    func reloadScroller() {
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if currentAlbumIndex >= allAlbums.count {
            currentAlbumIndex = allAlbums.count - 1
        }
      
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
  
    // Memento:
    // When the user leaves the app and then comes back again, he wants it to be in the exact same state
    // he left it. In order to do this we need to save the currently displayed album.
    // Since it's only one piece of information we can use NSUserDefaults.
    func saveCurrentState() {
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
      
        // Archive
        LibraryAPI.sharedInstance.saveAlbums()
    }
  
    func loadPreviousState() {
        currentAlbumIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
        showDataForAlbum(currentAlbumIndex)
    }
}

// MARK: TopRatedViewController

extension TopRatedViewController {
    func addAlbumAtIndex(album: Album, index: Int) {
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
  
    func deleteAlbum() {
        // Get the Album to delete.
        let deletedAlbum: Album = allAlbums[currentAlbumIndex]
      
        // Create a variable which stores a tuple of Album and its Index.
        // Then, add it into the stack.
        let undoAction = (deletedAlbum, currentAlbumIndex)
        undoStack.insert(undoAction, atIndex: 0)
      
        // Use LibraryAPI to delete the Album from the data structure.
        // Then, reload scroller.
        LibraryAPI.sharedInstance.deleteAlbum(currentAlbumIndex)
        reloadScroller()
      
        // Since there’s an action in the undo stack, you need to enable the undo button.
        let undoButton = navigationItem.leftBarButtonItem
        undoButton!.enabled = true
      
        // Lastly check to see if there are any albums left.
        // if there aren’t any you can disable the trash button.
        if (allAlbums.count == 0) {
            let trashButton = navigationItem.rightBarButtonItem
            trashButton!.enabled = false
        }
    }
  
    func undoAction() {
        // The method “pops” the object out of the stack, 
        // giving you a tuple containing the deleted Album 
        // and its index. You then proceed to add the album back.
        if undoStack.count > 0 {
            let (deletedAlbum, index) = undoStack.removeAtIndex(0)
            addAlbumAtIndex(deletedAlbum, index: index)
        }
      
        // Since you also deleted the last object in the stack when 
        // you “popped” it, you now need to check if the stack is empty. 
        // If it is, that means that there are no more actions to undo. 
        // So you disable the Undo button.
        if undoStack.count == 0 {
            let undoButton = navigationItem.leftBarButtonItem
            undoButton!.enabled = false
        }
      
        // You also know that since you undid an action, 
        // there should be at least one album cover. 
        // Hence you enable the trash button.
        let trashButton  = navigationItem.rightBarButtonItem
        trashButton!.enabled = true
      }
}

// MARK: UITableViewDataSource

extension TopRatedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albumData = currentAlbumData {
          return albumData.titles.count
        } else {
          return 0
      }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
      
        if let albumData = currentAlbumData {
            cell.textLabel!.text = albumData.titles[indexPath.row]
            cell.detailTextLabel!.text = albumData.values[indexPath.row]
        }
      
        return cell
    }
}

extension TopRatedViewController: UITableViewDelegate {
  
}

// MARK: HorizontalScrollerDelegate

extension TopRatedViewController: HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> (Int) {
        return allAlbums.count
    }
  
    // Create a new AlbumView, next check to see whether or not the user 
    // has selected this album. Then you can set it as highlighted or 
    // not depending on whether the album is selected. 
    // Lastly, you pass it to the HorizontalScroller.
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> (UIView) {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), albumCover: album.coverUrl)
      
        if currentAlbumIndex == index {
            albumView.highlightAlbum(didHighlightView: true)
        } else {
            albumView.highlightAlbum(didHighlightView: false)
        }
      
        return albumView
    }
  
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        // First you grab the previously selected album, and deselect the album cover.
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(didHighlightView: false)
        // Store the current album cover index you just clicked
        currentAlbumIndex = index
        // Grab the album cover that is currently selected and highlight the selection.
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        albumView.highlightAlbum(didHighlightView: true)
        // Display the data for the new album within the tableview.
        showDataForAlbum(index)
    }
  
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        return currentAlbumIndex
    }
}