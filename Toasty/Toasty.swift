//
//  Toasty.swift
//  Toasty
//
//  Copyright © 2016 Baris Sencan. All rights reserved.
//

/**
 TODO:
 - Toast vertical alignment (Top, Center, Bottom).
 - Add width/height FillAvailableArea/FitToText options.
 - Toast horizontal aligment (Left, Center, Right).
 - Queue vs show over.
 - OS X support.
 - Show toast with NSAttributedString.
 */

import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

// MARK: - Style Structure

public struct ToastyStyle {
  public var margin  = UIEdgeInsetsZero
  public var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  public var borderWidth: CGFloat = 0
  public var borderColor: CGColor? = nil

  public var cornerRadius: CGFloat = 0

  #if os(OSX)
  public var backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.8)
  public var textColor = NSColor.whiteColor()
  #else
  public var backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
  public var textColor = UIColor.whiteColor()
  #endif

  public var textAlignment = NSTextAlignment.Center
}

// MARK: - Main Functionality

public class Toasty {
  public static var defaultStyle = ToastyStyle()

  public static let shortDuration: NSTimeInterval = 2
  public static let longDuration: NSTimeInterval = 3.5

  #if os(OSX)

  public static func showToastWithText(text: String, inView view: NSView, forDuration duration: NSTimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    assert(false, "Toasty is not yet implemented for OS X")
  }

  #else

  public static func showToastWithText(text: String, inView view: UIView, forDuration duration: NSTimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    let toastView = UIView()
    toastView.backgroundColor    = style.backgroundColor
    toastView.layer.borderColor  = style.borderColor
    toastView.layer.borderWidth  = style.borderWidth
    toastView.layer.cornerRadius = style.cornerRadius
    toastView.layer.zPosition    = 1000

    let messageLabel = UILabel()
    messageLabel.text          = text
    messageLabel.textColor     = style.textColor
    messageLabel.textAlignment = style.textAlignment

    // Add views.
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    toastView.addSubview(messageLabel)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toastView)

    // Add constraints.
    toastView.addConstraints([
      NSLayoutConstraint(item: messageLabel, attribute: .Top, relatedBy: .Equal, toItem: toastView, attribute: .Top, multiplier: 1, constant: style.padding.top),
      NSLayoutConstraint(item: messageLabel, attribute: .Right, relatedBy: .Equal, toItem: toastView, attribute: .Right, multiplier: 1, constant: -style.padding.right),
      NSLayoutConstraint(item: messageLabel, attribute: .Bottom, relatedBy: .Equal, toItem: toastView, attribute: .Bottom, multiplier: 1, constant: -style.padding.bottom),
      NSLayoutConstraint(item: messageLabel, attribute: .Left, relatedBy: .Equal, toItem: toastView, attribute: .Left, multiplier: 1, constant: style.padding.left)])

    view.addConstraints([
      NSLayoutConstraint(item: toastView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: style.margin.top),
      NSLayoutConstraint(item: toastView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -style.margin.right),
      NSLayoutConstraint(item: toastView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: style.margin.left)])

    // Animate in.
    toastView.alpha = 0
    UIView.animateWithDuration(0.2) {
      toastView.alpha = 1
    }

    // Wait for duration and animate out.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      UIView.animateWithDuration(
        0.2,
        animations: { [weak toastView] in
          toastView?.alpha = 0
        },
        completion: { [weak toastView] completed in
          toastView?.removeFromSuperview()
      })
    }
  }

  #endif
}

// MARK: - View Extensions

#if os(OSX)

public extension NSView {

  public func showToastWithText(text: String, forDuration duration: NSTimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToastWithText(text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#else

public extension UIView {

  public func showToastWithText(text: String, forDuration duration: NSTimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToastWithText(text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#endif
