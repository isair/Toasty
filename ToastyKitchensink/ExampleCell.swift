//
//  ExampleCell.swift
//  Toasty
//
//  Copyright © 2016 Baris Sencan. All rights reserved.
//

import UIKit

class ExampleCell: UITableViewCell {
  static var reuseIdentifier: String { return "ExampleCell" }

  @IBOutlet weak var exampleDescriptionLabel: UILabel!
}
