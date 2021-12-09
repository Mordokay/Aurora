//
//  KeyboardToolbarView.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import RSKGrowingTextView

protocol KeyboardToolbarDelegate: AnyObject {
  func onSendPress(_ view: KeyboardToolbarView)
}

class KeyboardToolbarView: UIView {

  enum State {
    case normal, displayOption
  }

  lazy var textField: RSKGrowingTextView = {
    let textField = RSKGrowingTextView()
    textField.font = .aurora16
    textField.textColor = .auroraText
    textField.backgroundColor = .clear
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.showsVerticalScrollIndicator = true
    textField.isScrollEnabled = true
    textField.maximumNumberOfLines = 8
    return textField
  }()

  weak var delegate: KeyboardToolbarDelegate?

  lazy var sendButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString("Generic.send", comment: ""), for: .normal)
    button.titleLabel?.font = .aurora14
    button.setTitleColor(.auroraGreen, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    button.isEnabled = true
    button.isHidden = true
    return button
  }()

  var isButtonEnabled: Bool = false {
    didSet {
      DispatchQueue.main.async {
        UIView.animate(withDuration: 0.2, animations: {
          self.sendButton.isEnabled = self.isButtonEnabled
        })
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var middleView: UIView = {
    let myView = UIView()
    myView.layer.masksToBounds = true
    myView.layer.borderWidth = 1
    myView.layer.borderColor = UIColor.auroraLightBlueGrey.cgColor
    return myView
  }()

  @objc
  func onButtonTap() {
    log.notice("Tap: Send button")
    delegate?.onSendPress(self)
  }

  func setup() {

    middleView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(middleView)
    middleView.layer.cornerRadius = 20
    addSubview(sendButton)
    middleView.addSubview(textField)

    NSLayoutConstraint.activate([

      heightAnchor.constraint(lessThanOrEqualToConstant: CGSize.currentWindowSize.height * 0.5),

      middleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: relativeWidth(6)),
      middleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -relativeWidth(8)),
      middleView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      middleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      middleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

      sendButton.heightAnchor.constraint(equalToConstant: relativeHeight(42)),
      sendButton.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -relativeWidth(20)),
      sendButton.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),

      textField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: relativeWidth(10)),
      textField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -relativeWidth(64)),
      textField.topAnchor.constraint(equalTo: middleView.topAnchor),
      textField.bottomAnchor.constraint(equalTo: middleView.bottomAnchor)
      ])

  }
}
