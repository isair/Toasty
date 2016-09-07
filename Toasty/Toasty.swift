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
  public var margin  = UIEdgeInsets.zero
  public var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  public var borderWidth: CGFloat = 0
  public var borderColor: CGColor? = nil

  public var cornerRadius: CGFloat = 0

  #if os(OSX)
  public var backgroundColor = NSColor.black.withAlphaComponent(0.8)
  public var textColor = NSColor.white
  #else
  public var backgroundColor = UIColor.black.withAlphaComponent(0.8)
  public var textColor = UIColor.white
  #endif

  public var textAlignment = NSTextAlignment.center
}

// MARK: - Main Functionality

open class Toasty {
  open static var defaultStyle = ToastyStyle()

  open static let shortDuration: TimeInterval = 2
  open static let longDuration: TimeInterval = 3.5

  #if os(OSX)

  open static func showToastWithText(_ text: String, inView view: NSView, forDuration duration: TimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    assert(false, "Toasty is not yet implemented for OS X")
  }

  #else

  open static func showToastWithText(_ text: String, inView view: UIView, forDuration duration: TimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
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
      NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: toastView, attribute: .top, multiplier: 1, constant: style.padding.top),
      NSLayoutConstraint(item: messageLabel, attribute: .right, relatedBy: .equal, toItem: toastView, attribute: .right, multiplier: 1, constant: -style.padding.right),
      NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: toastView, attribute: .bottom, multiplier: 1, constant: -style.padding.bottom),
      NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: toastView, attribute: .left, multiplier: 1, constant: style.padding.left)])

    view.addConstraints([
      NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: style.margin.top),
      NSLayoutConstraint(item: toastView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -style.margin.right),
      NSLayoutConstraint(item: toastView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: style.margin.left)])

    // Animate in.
    toastView.alpha = 0
    UIView.animate(withDuration: 0.2) {
      toastView.alpha = 1
    }

    // Wait for duration and animate out.
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
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

  #endif
}

// MARK: - View Extensions

#if os(OSX)

public extension NSView {

  public func showToastWithText(_ text: String, forDuration duration: TimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToastWithText(text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#else

public extension UIView {

  public func showToastWithText(_ text: String, forDuration duration: TimeInterval = Toasty.shortDuration, usingStyle style: ToastyStyle = Toasty.defaultStyle) {
    Toasty.showToastWithText(text, inView: self, forDuration: duration, usingStyle: style)
  }
}

#endif
