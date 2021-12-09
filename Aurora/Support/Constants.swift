//
//  Constants.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

struct Constants {

  struct Chat {
    static let lastMessage = "kLastMessage"
  }

  static let sampleString = "sampleString"
  static let sampleTimeInterval: TimeInterval = 1.0
  static let sampleDouble: Double = 1.0

  #if DEBUG
  static let isRelease: Bool = false
  #else
  static let isRelease: Bool = true
  #endif

  static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}
