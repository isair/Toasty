//
//  KitchensinkViewController
//  ToastyKitchensink
//
//  Copyright © 2016 Baris Sencan. All rights reserved.
//

import UIKit
import Toasty

class KitchensinkViewController: UITableViewController {
  // MARK: - Properties

  private var examples: [(description: String, action: () -> Void)]!

  // MARK: - Initialization

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    examples = generateToastyExamples(for: navigationController as! UIViewController) // No, this doesn't fail.
  }

  private func generateToastyExamples(for viewController: UIViewController) -> [(description: String, action: () -> Void)] {
    return [
      // MARK: Example: Using default style

      (
        description: "Show toast with default style and duration",
        action: {
          viewController.view.showToast(with: "This is the default style with default duration")
          // or
          // Toasty.showToast(with: "This is the default style with default duration", inView: viewController.view)
        }
      ),

      // MARK: Example: Customizing style

      (
        description: "Show toast with customized style",
        action: {
          // Make a copy of the default style.
          var style = Toasty.defaultStyle
          // Make the toast view be a UIVisualEffectView instead of a UIView (uses a dark blur effect by
          // default).
          style.background = .visualEffectView
          // Change it to a light blur effect.
          style.backgroundVisualEffect = UIBlurEffect(style: .light)
          // Change the text color to something that will contrast the background.
          style.textColor = UIColor.darkText
          // Turn it into a floating box!
          style.cornerRadius = 5
          style.margin = UIEdgeInsets(top: style.margin.top + 8, left: 8, bottom: 8, right: 8)
          // Show our toast.
          viewController.view.showToast(with: "This has a customized style!", usingStyle: style)
        }
      ),

      // MARK: Example: Customizing duration

      (
        description: "Show toast for a duration that we define",
        action: {
          viewController.view.showToast(with: "This will stay here for 4 seconds",
                                        forDuration: .custom(customDurationTime: 4))
        }
      ),

      // MARK: Example: Duration based on text length

      (
        description: "Show toast for a duration that is dependant on its text length",
        action: {
          viewController.view.showToast(with: "This will stay here for a duration that is based on how long it is.",
                                        forDuration: .dynamic(readSpeed: nil))
        }
      )
    ]
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Update default style's top margin to show toasts under bars correctly.
    Toasty.defaultStyle.margin.top = topLayoutGuide.length
  }

  // MARK: - UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return examples.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "\(ExampleCell.reuseIdentifier)\(indexPath.row % 2)"
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ExampleCell
    cell.exampleDescriptionLabel.text = examples[indexPath.row].description
    return cell
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    examples[indexPath.row].action()
  }
}

