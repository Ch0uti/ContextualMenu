// ViewController.swift

import Menu
import SnapKit
import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let menu1 = MenuView(title: "LightMenu", theme: LightMenuTheme()) { [weak self] () -> [MenuItem] in
      [
        ShortcutMenuItem(name: "Undo", shortcut: (.command, "Z"), action: {
          [weak self] in

          let alert = UIAlertController(title: "Undo Action", message: "You selected undo", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

          self?.present(alert, animated: true, completion: nil)
        }),

        ShortcutMenuItem(name: "Redo", shortcut: ([.command, .shift], "Z"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Insert Image…", shortcut: ([.command, .alternate], "I"), action: {}),
        ShortcutMenuItem(name: "Insert Link…", shortcut: ([.command, .alternate], "L"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Help", shortcut: (.command, "?"), action: {}),
      ]
    }

    let menu2 = MenuView(title: "DarkMenu", theme: DarkMenuTheme()) { [weak self] () -> [MenuItem] in
      [
        ShortcutMenuItem(name: "Undo", shortcut: (.command, "Z"), action: {
          [weak self] in

          let alert = UIAlertController(title: "Undo Action", message: "You selected undo", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

          self?.present(alert, animated: true, completion: nil)
        }),

        ShortcutMenuItem(name: "Redo", shortcut: ([.command, .shift], "Z"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Insert Image…", shortcut: ([.command, .alternate], "I"), action: {}),
        ShortcutMenuItem(name: "Insert Link…", shortcut: ([.command, .alternate], "L"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Help", shortcut: (.command, "?"), action: {}),
      ]
    }

    let menu3 = MenuView(title: "PlainMenu", theme: PlainMenuTheme()) { [weak self] () -> [MenuItem] in
      [
        ShortcutMenuItem(name: "Undo", shortcut: (.command, "Z"), action: {
          [weak self] in

          let alert = UIAlertController(title: "Undo Action", message: "You selected undo", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

          self?.present(alert, animated: true, completion: nil)
        }),

        ShortcutMenuItem(name: "Redo", shortcut: ([.command, .shift], "Z"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Insert Image…", shortcut: ([.command, .alternate], "I"), action: {}),
        ShortcutMenuItem(name: "Insert Link…", shortcut: ([.command, .alternate], "L"), action: {}),

        SeparatorMenuItem(),

        ShortcutMenuItem(name: "Help", shortcut: (.command, "?"), action: {}),
      ]
    }

    // FIXME: This container blocks the touches
    let container = UIView()
    container.addSubview(menu1)
    menu1.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.height.equalTo(40)
    }

    view.addSubview(container)
    view.addSubview(menu2)
    view.addSubview(menu3)

//    menu1.tintColor = .black
//    menu2.tintColor = .blue

    container.snp.makeConstraints {
      make in

      make.top.equalToSuperview().offset(64)
      make.leading.equalToSuperview().inset(20)

      // Menus don't have an intrinsic height
      make.height.equalTo(80)
      make.width.equalTo(100)
    }

    menu2.snp.makeConstraints {
      make in

      make.top.equalToSuperview().offset(64)
      make.centerX.equalToSuperview()

      // Menus don't have an intrinsic height
      make.height.equalTo(40)
    }

    menu3.snp.makeConstraints {
      make in

      make.top.equalToSuperview().offset(64)
      make.trailing.equalToSuperview().inset(20)

      // Menus don't have an intrinsic height
      make.height.equalTo(40)
    }

    menu2.contentAlignment = .center
    menu3.contentAlignment = .left
  }
}

// class PassthroughView: UIView {
//  let hitTestView: UIView
//  init(hitTestView: UIView) {
//    self.hitTestView = hitTestView
//    super.init(frame: .zero)
//  }
//
//  required init?(coder _: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
////    let view = super.hitTest(point, with: event)
////    return view === self ? nil : view
//    return hitTestView.hitTest(point, with: event)
//  }
// }
