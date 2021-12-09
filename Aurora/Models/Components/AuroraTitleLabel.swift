//
//  AuroraTitleLabel.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import UIKit

class AuroraTitleLabel: UILabel {

  private var isCentered: Bool = false

  override var text: String? {
    didSet {
      let alignment: NSTextAlignment = isCentered ? .center : .left
      setAttributes(lineHeight: 1.09, alignment: alignment)
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

  init(isCentered: Bool) {
    super.init(frame: .zero)
    self.isCentered = isCentered
    setup()
  }

  init() {
    super.init(frame: .zero)
    setup()
  }

  private func setup() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = .aurora20DynamicBold
    self.textColor = .auroraLightBlueGrey
    self.numberOfLines = 0
    let alignment: NSTextAlignment = self.isCentered ? .center : .left
    self.setAttributes(lineHeight: 1.09, alignment: alignment)
  }
}
