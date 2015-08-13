//
//  ContactsTableViewController.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

  private var allUsers = [AppUser]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    allUsers = LibraryAPI.sharedInstance.getUsers()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return allUsers.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContactsTableViewCell", forIndexPath: indexPath) as! ContactsTableViewCell
    
    // Configure the cell...
    let user = allUsers[indexPath.row]
    
    cell.circularImageView.userImage = UIImage(named: user.avatar)
    cell.title.text = user.name
    cell.subTitle.text = user.rating
    
    return cell
  }
  
  // MARK: - Navigation
  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if segue.identifier == "showProfile" {
//      if let destination = segue.destinationViewController as? ContactProfileViewController {
//        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
//        let selectedUser: AppUser = allUsers[indexPath.row]
//        destination.user = selectedUser
//      }
//    }
//  }
}
