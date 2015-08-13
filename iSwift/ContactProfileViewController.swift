//
//  ContactProfileViewController.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import UIKit

class ContactProfileViewController: UIViewController {

  @IBOutlet weak var contactProfileTableView: UITableView!
  @IBOutlet weak var circularImageView: CircularImageView!
  
  private var currentUserData : (titles:[String], values:[String])?
  var user: AppUser!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup the UITableView.
    contactProfileTableView.delegate = self
    contactProfileTableView.dataSource = self
    contactProfileTableView.backgroundView = nil
    
    currentUserData = user.aue_tableRepresentation()
    
    // Do any additional setup after loading the view.
    if user != nil {
      circularImageView.userImage = UIImage(named: user.avatar)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: UITableViewDataSource

extension ContactProfileViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let userData = currentUserData {
      return userData.titles.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("userProfileCell", forIndexPath: indexPath) 
    
    if let userData = currentUserData {
      cell.textLabel!.text = userData.titles[indexPath.row]
      cell.detailTextLabel!.text = userData.values[indexPath.row]
    }
    
    return cell
  }
}

extension ContactProfileViewController: UITableViewDelegate {
  
}