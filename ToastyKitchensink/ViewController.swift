//
//  ViewController.swift
//  ToastyKitchensink
//
//  Copyright © 2016 Baris Sencan. All rights reserved.
//

import UIKit
import Toasty

class ViewController: UIViewController {

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Make a copy of default style.
    var style = Toasty.defaultStyle

    // Navigation bar is translucent so the view starts from under the bars. Set margin accordingly.
    style.margin.top = topLayoutGuide.length

    // Show our toast.
    view.showToastWithText("Hello, world!", usingStyle: style)
  }
}

