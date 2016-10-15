//
//  Toasty.swift
//  Toasty
//
//  Copyright © 2016 Baris Sencan. All rights reserved.
//

/**
 TODO:
 - Expand for multiline text.
 - Accessory image.
 - Tap handler.
 - Hide method.
 - Left and right anchoring.
 - Diagonal anchoring.
 - Queue vs show over.
 - Fit width/height to content option.
 - Show toast with NSAttributedString.
 - Show toast with markup string.
 */

import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

// MARK: - Style Structure

public struct ToastyStyle {
  public enum Anchor {
    case top
    case bottom
  }
  public var anchor  = Anchor.top

  public var margin  = UIEdgeInsets.zero
  public var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  public var borderWidth: CGFloat = 0
  public var borderColor: CGColor? = nil

  public var cornerRadius: CGFloat = 0

  public enum Background {
    case view
    case visualEffectView
  }
  public var background = Background.view

  #if os(OSX)
  public var backgroundColor = NSColor.black.withAlphaComponent(0.8)
  public var textColor = NSColor.white
  public var font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
  #else
  public var backgroundColor = UIColor.black.withAlphaComponent(0.8)
  public var textColor = UIColor.white
  public var font = UIFont.preferredFont(forTextStyle: .body)
  #endif

  public var backgroundVisualEffect: UIVisualEffect = UIBlurEffect(style: .dark)

  public var textAlignment = NSTextAlignment.center
}

// MARK: - Main Functionality

open class Toasty {
  // MARK: Types

  public enum Duration {
    /// 2 seconds.
    case short

    /// 3.5 seconds.
    case long

    /// Custom defined duration.
    case custom(customDurationTime: TimeInterval)

    /// Duration is calculated from toast text
    /// length and the read speed provided here.
    ///
    /// Read speed format is characters per
    /// second. If nil, the default value of 8
    /// is used.
    case dynamic(readSpeed: Double?)
  }

  // MARK: Properties

  /// The default style configuration. Mutable. Changes
  /// only affect the toasts shown after their assignment.
  public static var defaultStyle = ToastyStyle()

  private static let shortDuration: TimeInterval = 2
  private static let longDuration: TimeInterval = 3.5

  // MARK: Methods

  open class func showToast<V: View>(with text: String, inView view: V, forDuration duration: Duration = .short, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    let toastView = style.background == .view ? UIView() : UIVisualEffectView(effect: style.backgroundVisualEffect)
    if (style.background == .view) {
      toastView.backgroundColor    = style.backgroundColor
    }
    toastView.layer.borderColor  = style.borderColor
    toastView.layer.borderWidth  = style.borderWidth
    toastView.layer.cornerRadius = style.cornerRadius
    toastView.layer.zPosition    = 1000

    let messageLabel = UILabel()
    messageLabel.text          = text
    messageLabel.textColor     = style.textColor
    messageLabel.textAlignment = style.textAlignment
    messageLabel.font          = style.font

    // Add views.
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    toastView.addSubview(messageLabel)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toastView as! V)

    // Add constraints.
    toastView.addConstraints([
      NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: toastView, attribute: .top, multiplier: 1, constant: style.padding.top),
      NSLayoutConstraint(item: messageLabel, attribute: .right, relatedBy: .equal, toItem: toastView, attribute: .right, multiplier: 1, constant: -style.padding.right),
      NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: toastView, attribute: .bottom, multiplier: 1, constant: -style.padding.bottom),
      NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: toastView, attribute: .left, multiplier: 1, constant: style.padding.left)])

    view.addConstraints([
      style.anchor == .top
        ? NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: style.margin.top)
        : NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: style.margin.top),
      NSLayoutConstraint(item: toastView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -style.margin.right),
      NSLayoutConstraint(item: toastView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: style.margin.left),
      style.anchor == .bottom
        ? NSLayoutConstraint(item: toastView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -style.margin.bottom)
        : NSLayoutConstraint(item: toastView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: -style.margin.bottom)])

    // Animate in.
    toastView.alpha = 0
    UIView.animate(withDuration: 0.2) {
      toastView.alpha = 1
    }

    // Calculate duration.
    var durationTime: TimeInterval!
    switch duration {
    case .short:
      durationTime = shortDuration
    case .long:
      durationTime = longDuration
    case .custom(let customDurationTime):
      durationTime = customDurationTime
    case .dynamic(let readSpeed):
      durationTime = Double(text.characters.count) / (readSpeed ?? 8.0)
    }

    // Wait for duration and animate out.
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + durationTime) {
      UIView.animate(
        withDuration: 0.2,
        animations: { [weak toastView] in
          toastView?.alpha = 0
        },
        completion: { [weak toastView] completed in
          toastView?.removeFromSuperview()
      })
    }
  }
}

// MARK: - View Extensions

#if os(OSX)

public extension NSView {

  public func showToast(with text: String, forDuration duration: Toasty.Duration = .short, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToast(with: text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#else

public extension UIView {

  public func showToast(with text: String, forDuration duration: Toasty.Duration = .short, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToast(with: text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#endif

// MARK: - Shared API for UIView and NSView

public protocol View {
  func addSubview(_ view: Self)
  func addConstraints(_ constraints: [NSLayoutConstraint])
  static func animate(withDuration: TimeInterval, animations: @escaping () -> Void)
}

#if os(OSX)

extension NSView: View {}

#else

extension UIView: View {}
  
#endif
