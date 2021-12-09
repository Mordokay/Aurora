//
//  ChatMessageCell.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol ReusableView {
}

extension ReusableView where Self: UIView {
 static var reuseIdentifier: String {
  return String(describing: self)
 }
}

class ChatMessageCell: UITableViewCell, ReusableView {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(){}
}
