//
//  UITextField+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

extension UITextField {

  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      let text = placeholder ?? ""
      if let color = newValue {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.attributedPlaceholder = NSAttributedString(string: text, attributes: [ .foregroundColor: color ])
            }
        }
      }
    }
  }

  func setPaddingPoints(left: CGFloat? = nil, right: CGFloat? = nil) {
    if let leftPadding = left {
      let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.size.height))
      self.leftView = paddingViewLeft
      self.leftViewMode = .always
    }
    if let rightPadding = right {
      let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.size.height))
      self.rightView = paddingViewRight
      self.rightViewMode = .always
    }
  }
}
