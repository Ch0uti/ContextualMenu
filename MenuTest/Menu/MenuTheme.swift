// MenuTheme.swift

import UIKit

public protocol MenuThemeable {
  func applyTheme(_ theme: MenuTheme)
}

public protocol MenuTheme {
  // Common
  var font: UIFont { get }
  var blurEffect: UIBlurEffect? { get }
  var shadowColor: UIColor { get }
  var shadowOpacity: Float { get }
  var shadowRadius: CGFloat { get }

  // Menu
  var menuTextColor: UIColor { get }
  var menuBackgroundColor: UIColor { get }
  var gestureBarTint: UIColor { get }

  // Content
  var contentTextColor: UIColor { get }
  var highlightedTextColor: UIColor { get }
  var highlightedBackgroundColor: UIColor { get }
  var contentBackgroundColor: UIColor { get }
  var separatorColor: UIColor { get }

  var brightTintColor: UIColor { get } // Not used
  var darkTintColor: UIColor { get } // Not used
}

public extension MenuTheme {
  var brightTintColor: UIColor { return .white }
  var darkTintColor: UIColor { return .black }
}

// MARK: - LightMenuTheme
public struct LightMenuTheme: MenuTheme {
  public let font = UIFont.systemFont(ofSize: 16, weight: .medium)
  public let blurEffect: UIBlurEffect? = UIBlurEffect(style: .light)
  public let shadowColor = UIColor.black
  public let shadowOpacity: Float = 0.3
  public let shadowRadius: CGFloat = 7.0

  public let menuTextColor = UIColor.black
  public let menuBackgroundColor = UIColor(white: 1.0, alpha: 0.15)
  public let gestureBarTint = UIColor(red: 36 / 255.0, green: 36 / 255.0, blue: 36 / 255.0, alpha: 0.17)

  public let contentTextColor = UIColor.black
  public let contentBackgroundColor = UIColor(white: 1.0, alpha: 0.15)
  public let highlightedTextColor = UIColor.white
  public let highlightedBackgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1.0)
  public let separatorColor = UIColor(white: 0, alpha: 0.1)

  public init() {}
}

// MARK: - DarkMenuTheme
public struct DarkMenuTheme: MenuTheme {
  public let font = UIFont.systemFont(ofSize: 16, weight: .medium)
  public let blurEffect: UIBlurEffect? = UIBlurEffect(style: .dark)
  public let shadowColor = UIColor.black
  public let shadowOpacity: Float = 0.3
  public let shadowRadius: CGFloat = 7.0

  public let menuTextColor = UIColor.white
  public let menuBackgroundColor = UIColor.clear
  public let gestureBarTint = UIColor(red: 36 / 255.0, green: 36 / 255.0, blue: 36 / 255.0, alpha: 0.17)

  public let contentTextColor = UIColor.white
  public let contentBackgroundColor = UIColor.clear
  public let highlightedTextColor = UIColor.white
  public let highlightedBackgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1.0)
  public let separatorColor = UIColor(white: 1, alpha: 0.4)

  public init() {}
}

// MARK: - PlainMenuTheme
public struct PlainMenuTheme: MenuTheme {
  public let font = UIFont.systemFont(ofSize: 16, weight: .medium)
  public let blurEffect: UIBlurEffect? = nil
  public let shadowColor = UIColor.black
  public let shadowOpacity: Float = 0.3
  public let shadowRadius: CGFloat = 7.0

  public let menuTextColor = UIColor.white
  public let menuBackgroundColor = UIColor.blue
  public let gestureBarTint = UIColor(red: 36 / 255.0, green: 36 / 255.0, blue: 36 / 255.0, alpha: 0.17)

  public let contentTextColor = UIColor.white
  public let contentBackgroundColor = UIColor.blue
  public let highlightedTextColor = UIColor.white
  public let highlightedBackgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1.0)
  public let separatorColor = UIColor(white: 1, alpha: 1.0)

  public init() {}
}
