//
//  CGPoint+Extensions.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

extension CGPoint {
  func distance(toPoint p: CGPoint) -> CGFloat {
    return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
  }
}
