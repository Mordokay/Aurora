//
//  AuroraButton.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class AuroraRoundButton: UIButton {

  enum ButtonState {
    case normal
    case disabled
  }

  // 3
  private var disabledBackgroundColor: UIColor?
  private var defaultBackgroundColor: UIColor? {
    didSet {
      backgroundColor = defaultBackgroundColor
    }
  }

  override var isEnabled: Bool {
    didSet {
      if isEnabled {
        if let color = defaultBackgroundColor {
          self.backgroundColor = color
        }
      }
      else {
        if let color = disabledBackgroundColor {
          self.backgroundColor = color
        }
      }
    }
  }

  // 5. our custom functions to set color for different state
  func setBackgroundColor(_ color: UIColor?, for state: ButtonState) {
    switch state {
    case .disabled:
      disabledBackgroundColor = color
    case .normal:
      defaultBackgroundColor = color
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup()
  }

  func setup() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.setTitleColor(.auroraBlue, for: .normal)
    self.setTitleColor(.auroraSoftDarkBlue, for: .disabled)
    self.setTitle(NSLocalizedString("Generic.next", comment: ""), for: .normal)
    self.titleLabel?.font = .aurora14DynamicBold
    self.setBackgroundColor(.auroraLightBlueGrey, for: .normal)
    self.setBackgroundColor(.auroraGrey, for: .disabled)
    self.layer.cornerRadius = 25
    self.layer.masksToBounds = true
  }
}
