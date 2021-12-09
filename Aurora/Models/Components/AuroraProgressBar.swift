//
//  AuroraProgressBar.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import UIKit

class AuroraProgressBar: UIProgressView {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  init(step: Int, of total: Int) {
    super.init(frame: .zero)
    setup(step: step, of: total)
  }

  func setup(step: Int = 1, of total: Int = 1) {
    self.progress = Float(Float(step)/Float(total))
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.cornerRadius = 1
    self.trackTintColor = .auroraSoftDarkBlue
    self.progressTintColor = .auroraCerulean
  }
}
