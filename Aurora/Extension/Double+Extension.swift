//
//  Double+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation

extension Double {
  var toMillisecondsFromSeconds: Double {
      return (self * 1000.0).rounded()
  }
  var toSecondsFromMilliseconds: Double {
      return (self / 1000.0).rounded()
  }
}
