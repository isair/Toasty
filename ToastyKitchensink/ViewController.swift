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

    // Make a copy of the default style.
    var style = Toasty.defaultStyle

    // Navigation bar is translucent so the view starts from under the bars. Set margin accordingly.
    style.margin.top = topLayoutGuide.length

    // Make the toast view be a UIVisualEffectView instead of a UIView (uses a dark blur effect by
    // default).
    style.background = .visualEffectView

    // Show our toast.
    view.showToastWithText("Hello, world!", forDuration: .dynamic(readSpeed: nil), usingStyle: style)
  }
}

