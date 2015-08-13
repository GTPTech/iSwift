//
//  ContactsTableViewCell.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/23/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
  
  var circularImageView: CircularImageView!
  var title = UILabel()
  var subTitle = UILabel()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    circularImageView = CircularImageView(frame: CGRectMake(0, 0, 90.0, 90.0))
    
//    let labelsStackView = UIStackView()
//    labelsStackView.axis = UILayoutConstraintAxis.Vertical
//    labelsStackView.distribution = UIStackViewDistribution.Fill
//    labelsStackView.alignment = UIStackViewAlignment.Fill
//    
//    labelsStackView.addArrangedSubview(title)
//    labelsStackView.addArrangedSubview(subTitle)
//    
//    let imageStackView = UIStackView()
//    imageStackView.axis = UILayoutConstraintAxis.Horizontal
//    imageStackView.distribution = UIStackViewDistribution.Fill
//    imageStackView.alignment = UIStackViewAlignment.Fill
//
//    circularImageView.translatesAutoresizingMaskIntoConstraints = false
//    imageStackView.addArrangedSubview(circularImageView)
//
//    let subCellStackView = UIStackView()
//    subCellStackView.axis = UILayoutConstraintAxis.Horizontal
//    subCellStackView.distribution = UIStackViewDistribution.Fill
//    subCellStackView.alignment = UIStackViewAlignment.Fill
//    
//    subCellStackView.addArrangedSubview(labelsStackView)
//    subCellStackView.addArrangedSubview(imageStackView)
//    
//    let cellStackView = UIStackView(frame: frame)
//    cellStackView.axis = UILayoutConstraintAxis.Vertical
//    cellStackView.distribution = UIStackViewDistribution.Fill
//    cellStackView.alignment = UIStackViewAlignment.Fill
    
//    cellStackView.translatesAutoresizingMaskIntoConstraints = false
//    cellStackView.addArrangedSubview(subCellStackView)
//
//    let tempConstraint = NSLayoutConstraint(item: imageStackView,
//      attribute: NSLayoutAttribute.Height,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: imageStackView,
//      attribute: NSLayoutAttribute.Width,
//      multiplier: 1.0 / 1.0,
//      constant: 0)
//    
//    circularImageView.addConstraint(tempConstraint)
//    
//    contentView.addSubview(cellStackView)
//    
//    let leadingConstraint = NSLayoutConstraint(item: cellStackView,
//      attribute: NSLayoutAttribute.LeadingMargin,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: contentView,
//      attribute: NSLayoutAttribute.LeadingMargin,
//      multiplier: 1,
//      constant: 0)
//    
//    contentView.addConstraint(leadingConstraint)
//    
//    let tralingConstraint = NSLayoutConstraint(item: cellStackView,
//      attribute: NSLayoutAttribute.TrailingMargin,
//      relatedBy: NSLayoutRelation.Equal,
//      toItem: contentView,
//      attribute: NSLayoutAttribute.TrailingMargin,
//      multiplier: 1,
//      constant: 0)
//    
//    contentView.addConstraint(tralingConstraint)
  }
}
