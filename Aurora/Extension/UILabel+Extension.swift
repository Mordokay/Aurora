//
//  UILabel+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

extension UILabel {

  var optimalHeight: CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = self.lineBreakMode
    label.font = self.font
    label.text = self.text

    label.sizeToFit()

    return label.frame.height
  }

  var optimalSize: CGSize {

    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    label.lineBreakMode = self.lineBreakMode
    label.font = self.font
    label.text = self.text

    label.sizeToFit()

    return label.bounds.size
  }

  func format(text: String = "", size: CGFloat = 12, fontColor: UIColor = .auroraText, isBold: Bool = false) {
    self.text = text
    self.textColor = fontColor
    self.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    self.sizeToFit()
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  func setAttributes(lineHeight: CGFloat, alignment: NSTextAlignment) {
    let text = self.text
    if let text = text {
      let attributeString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      style.lineHeightMultiple = lineHeight
      style.alignment = alignment
      attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
      self.attributedText = attributeString
    }
  }
}
