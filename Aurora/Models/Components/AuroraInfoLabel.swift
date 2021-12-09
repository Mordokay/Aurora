//
//  AuroraInfoLabel.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class AuroraInfoLabel: UILabel {

  private var isCentered: Bool = false

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

  func setup(isCentered:Bool = false) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = .aurora16Dynamic
    self.textColor = .auroraCerulean
    self.numberOfLines = 0
    self.textAlignment = isCentered ? .center : .left
  }
}
