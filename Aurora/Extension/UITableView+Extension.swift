//
//  UITableView+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func register<T: UITableViewCell> (_: T.Type) where T: ReusableView {
    register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableView<T: UITableViewCell> (_: T.Type, _ indexPath: IndexPath) -> T? where T: ReusableView {
    return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
  }

  func setEmptyMessage(_ message: String) {
          let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
          messageLabel.text = message
          messageLabel.textColor = .auroraLightBlueGrey
          messageLabel.numberOfLines = 0
          messageLabel.textAlignment = .center
          messageLabel.font = .aurora14
          messageLabel.sizeToFit()

          self.backgroundView = messageLabel
          self.separatorStyle = .none
      }

      func restore() {
          self.backgroundView = nil
          self.separatorStyle = .singleLine
      }
}
