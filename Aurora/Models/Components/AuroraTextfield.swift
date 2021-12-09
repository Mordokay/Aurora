//
//  AuroraTextfield.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class AuroraTextfield: UITextField {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  init(isCentered: Bool) {
    super.init(frame: .zero)
    setup(isCentered: isCentered)
  }

  init(isCentered: Bool, clearButtonMode: UITextField.ViewMode) {
    super.init(frame: .zero)
    setup(isCentered: isCentered, clearButtonMode: clearButtonMode)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.placeHolderColor = .auroraSoftDarkBlue
  }

  func setup(isCentered: Bool = false, clearButtonMode: UITextField.ViewMode = .never) {

    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 3
    self.layer.borderColor = UIColor.auroraSoftDarkBlue.cgColor
    self.backgroundColor = .clear
    self.textAlignment = isCentered ? .center : .left
    self.placeHolderColor = .auroraSoftDarkBlue
    self.textColor = .auroraLightBlueGrey
    self.font = .aurora16Dynamic
    self.clearButtonMode = clearButtonMode

    if clearButtonMode != .never {
      let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: relativeHeight(50), height: relativeHeight(50)))
      clearButton.imageEdgeInsets = UIEdgeInsets(top: relativeHeight(10), left: relativeHeight(10), bottom: relativeHeight(10), right: relativeHeight(10))
      clearButton.setImage(UIImage(named: "bar_close_normal")!, for: .normal)
      clearButton.setImage(UIImage(named: "bar_close_pressed")!, for: .highlighted)

      let rightView = UIView(frame: CGRect( x: 0, y: 0, width: clearButton.frame.width, height: clearButton.frame.height))
      rightView.addSubview(clearButton)
      self.rightView = rightView
      clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)

      self.rightViewMode = .always
    }

    if !isCentered {
      self.setPaddingPoints(left: UIView.staticRelativeWidth(16))
    }
  }

  func setClearButtonState(to state: Bool) {
    self.rightView?.isHidden = !state
  }

  @objc
  func clearClicked(sender:UIButton) {
    self.text = ""
  }
}
