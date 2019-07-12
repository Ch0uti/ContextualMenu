// MenuView.swift

import SnapKit
import UIKit

// MARK: - MenuView

public class MenuView: UIView, MenuThemeable, UIGestureRecognizerDelegate {
  public static let menuWillPresent = Notification.Name("CodeaMenuWillPresent")

  private let titleLabel = UILabel()
  private let gestureBarView = UIView()
  private let tintView = UIView()
  private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  private let feedback = UISelectionFeedbackGenerator()

  public var title: String {
    didSet {
      titleLabel.text = title
      contentView?.title = title
    }
  }

  private var menuPresentationObserver: Any!

  private var contentView: MenuContentView?
  private var theme: MenuTheme
  private var longPress: UILongPressGestureRecognizer!
  private var tapGesture: UITapGestureRecognizer!

  private let itemsSource: () -> [MenuItem]

  public enum Alignment {
    case left
    case center
    case right
  }

  public var contentAlignment = Alignment.right {
    didSet {
      if contentAlignment == .center {
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
      } else {
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
      }
    }
  }

  /// Callback for showing the content view.
  public var onShow: (() -> Void)?

  /// Callback for hiding the content view.
  public var onHide: (() -> Void)?

  public init(title: String, theme: MenuTheme, itemsSource: @escaping () -> [MenuItem]) {
    self.title = title
    self.theme = theme
    self.itemsSource = itemsSource

    super.init(frame: .zero)

    titleLabel.text = title
    titleLabel.textColor = theme.menuTextColor
    titleLabel.textAlignment = .center
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)

    let clippingView = UIView()
    clippingView.clipsToBounds = true

    addSubview(clippingView)

    clippingView.snp.makeConstraints {
      make in

      make.edges.equalToSuperview()
    }

    clippingView.layer.cornerRadius = 8.0

    clippingView.addSubview(effectView)

    effectView.snp.makeConstraints {
      make in

      make.edges.equalToSuperview()
    }

    effectView.contentView.addSubview(tintView)
    effectView.contentView.addSubview(titleLabel)
    effectView.contentView.addSubview(gestureBarView)

    tintView.snp.makeConstraints {
      make in

      make.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      make in

      make.left.right.equalToSuperview().inset(12)
      make.centerY.equalToSuperview()
    }

    gestureBarView.layer.cornerRadius = 1.0
    gestureBarView.snp.makeConstraints {
      make in

      make.centerX.equalToSuperview()
      make.height.equalTo(2)
      make.width.equalTo(20)
      make.bottom.equalToSuperview().inset(3)
    }

    self.longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
    longPress.minimumPressDuration = 0.0
    longPress.delegate = self
    addGestureRecognizer(longPress)

    self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    tapGesture.delegate = self
    addGestureRecognizer(tapGesture)

    applyTheme(theme)

    self.menuPresentationObserver = NotificationCenter.default.addObserver(forName: MenuView.menuWillPresent, object: nil, queue: nil) {
      [weak self] notification in

      if let poster = notification.object as? MenuView, let this = self, poster !== this {
        self?.hideContents(animated: false)
      }
    }
  }

  deinit {
    if let menuPresentationObserver = menuPresentationObserver {
      NotificationCenter.default.removeObserver(menuPresentationObserver)
    }
  }

  // MARK: - Required Init

  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Gesture Handling

  private var gestureStart: Date = .distantPast

  @objc private func longPressGesture(_ sender: UILongPressGestureRecognizer) {
    // Highlight whatever we can
    if let contents = self.contentView {
      let localPoint = sender.location(in: self)
      let contentsPoint = convert(localPoint, to: contents)

      if contents.pointInsideMenuShape(contentsPoint) {
        contents.highlightedPosition = CGPoint(x: contentsPoint.x, y: localPoint.y)
      }
    }

    switch sender.state {
    case .began:
      if !isShowingContents {
        gestureStart = Date()
        showContents()
      } else {
        gestureStart = .distantPast
      }

      contentView?.isInteractiveDragActive = true
    case .cancelled:
      fallthrough
    case .ended:
      let gestureEnd = Date()

      contentView?.isInteractiveDragActive = false

      if gestureEnd.timeIntervalSince(gestureStart) > 0.3 {
        selectPositionAndHideContents(sender)
      }

    default:
      ()
    }
  }

  @objc private func tapped(_ sender: UITapGestureRecognizer) {
//    selectPositionAndHideContents(sender)
  }

  private func selectPositionAndHideContents(_ gesture: UIGestureRecognizer) {
    if let contents = contentView {
      let point = convert(gesture.location(in: self), to: contents)

      if contents.point(inside: point, with: nil) {
        contents.selectPosition(point, completion: { [weak self] menuItem in
          self?.hideContents(animated: true)
          menuItem?.performAction()
        })
      } else {
        hideContents(animated: true)
      }
    }
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer == longPress, otherGestureRecognizer == tapGesture {
      return true
    }
    return false
  }

  var overlayView: OverlayView?
  public func showContents() {
    // TODO: This is used for dismissing other menu. Should use a exclusive group of menus to dismiss.
    // Remove this notification and use hitTest to dismiss.
    NotificationCenter.default.post(name: MenuView.menuWillPresent, object: self)

    guard let window = self.window else {
      assertionFailure("Menu view must have a valid window")
      return
    }

    let overlayView = OverlayView()
    self.overlayView = overlayView
    overlayView.backgroundColor = .clear
    overlayView.onLongPress = { [weak self] longPress in
      guard let self = self else { return }
      self.longPressGesture(longPress)
    }
    window.addSubview(overlayView)
    overlayView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    let contents = MenuContentView(hostMenuView: self, name: title, items: itemsSource(), theme: theme)
    overlayView.addSubview(contents)

    contents.snp.makeConstraints {
      make in

      switch contentAlignment {
      case .left:
        make.top.right.equalTo(self)
      case .right:
        make.top.left.equalTo(self)
      case .center:
        make.top.centerX.equalTo(self)
      }
    }

    effectView.isHidden = true

    // What is this for? why 0.07?
    longPress?.minimumPressDuration = 0.07

    contentView = contents

    overlayView.setNeedsLayout()
    overlayView.layoutIfNeeded()

    contents.generateMaskAndShadow(alignment: contentAlignment)
//    contents.focusInitialViewIfNecessary()

    feedback.prepare()
    contents.highlightChanged = {
      [weak self] in

      self?.feedback.selectionChanged()
    }
    onShow?()
  }

  public func hideContents(animated: Bool) {
    let contentsView = contentView
    contentView = nil

    longPress?.minimumPressDuration = 0.0

    effectView.isHidden = false

    if animated {
      UIView.animate(withDuration: 0.2, animations: {
        contentsView?.alpha = 0.0
      }) { [weak self] _ in
        contentsView?.removeFromSuperview()
        guard let self = self else { return }
        self.overlayView?.removeFromSuperview()
      }
    } else {
      contentsView?.removeFromSuperview()
      overlayView?.removeFromSuperview()
    }

    onHide?()
  }

  public var isShowingContents: Bool {
    return contentView != nil
  }

  // MARK: - Hit Testing

  // TODO: touching just below the menu doesn't dismiss the content view
  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let contents = contentView else {
      return super.point(inside: point, with: event)
    }

    let contentsPoint = convert(point, to: contents)

    if !contents.pointInsideMenuShape(contentsPoint) {
      hideContents(animated: true)
    }

    return contents.pointInsideMenuShape(contentsPoint)
  }

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let contents = contentView else {
      return super.hitTest(point, with: event)
    }

    let contentsPoint = convert(point, to: contents)

    if !contents.pointInsideMenuShape(contentsPoint) {
      hideContents(animated: true)
    } else {
      return contents.hitTest(contentsPoint, with: event)
    }

    return super.hitTest(point, with: event)
  }

  // MARK: - Theming

  public func applyTheme(_ theme: MenuTheme) {
    self.theme = theme

    titleLabel.font = theme.font
    titleLabel.textColor = theme.menuTextColor
    gestureBarView.backgroundColor = theme.gestureBarTint
    tintView.backgroundColor = theme.menuBackgroundColor
    effectView.effect = theme.blurEffect

    contentView?.applyTheme(theme)
  }
}

extension UIView {
  var window: UIWindow? {
    var current = self
    while let superview = current.superview {
      if let window = superview as? UIWindow {
        return window
      } else {
        current = superview
      }
    }
    return nil
  }
}

class OverlayView: UIView {

  var onTap: ((UITapGestureRecognizer) -> ())?
  var onPan: ((UIPanGestureRecognizer) -> ())?
  var onLongPress: ((UILongPressGestureRecognizer) -> ())?

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    tapGesture.cancelsTouchesInView = false
    addGestureRecognizer(tapGesture)

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    panGesture.cancelsTouchesInView = false
    addGestureRecognizer(panGesture)

    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
    longPressGesture.cancelsTouchesInView = false
    longPressGesture.minimumPressDuration = 0.0
    addGestureRecognizer(longPressGesture)
  }

  @objc private func tapped(_ sender: UITapGestureRecognizer) {
    onTap?(sender)
  }

  @objc private func panned(_ sender: UIPanGestureRecognizer) {
    onPan?(sender)
  }

  @objc private func longPressed(_ sender: UILongPressGestureRecognizer) {
    onLongPress?(sender)
  }
}
