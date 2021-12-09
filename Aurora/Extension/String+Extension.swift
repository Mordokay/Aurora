//
//  String+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

extension String {
  var trimmed: String {
    return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }

  func formatWithSpacing(spacing: CGFloat) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

    return attributedString
  }
}
