// ViewController.swift

import Menu
import SnapKit
import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let menu1 = MenuView(title: "Menu1", theme: LightMenuTheme()) { [weak self] () -> [MenuItem] in
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

    let menu2 = MenuView(title: "Menu2", theme: LightMenuTheme()) { [weak self] () -> [MenuItem] in
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

    view.addSubview(menu1)
    view.addSubview(menu2)

    menu1.tintColor = .black
    menu2.tintColor = .blue

    menu1.snp.makeConstraints {
      make in

      make.center.equalToSuperview()

      // Menus don't have an intrinsic height
      make.height.equalTo(40)
    }

    menu2.snp.makeConstraints {
      make in

      make.centerX.equalToSuperview().offset(-100)
      make.centerY.equalToSuperview().offset(100)

      // Menus don't have an intrinsic height
      make.height.equalTo(40)
    }
  }
}
