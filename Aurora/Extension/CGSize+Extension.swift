//
//  CGSize.swift
//  FlappyBird
//
//  Created by Pedro Saldanha on 13/07/2019.
//  Copyright © 2019 GreenSphereStudios. All rights reserved.
//

import UIKit

extension CGSize {
  static var currentWindowSize: CGSize {
    return  UIApplication.shared.keyWindow?.bounds.size ?? UIWindow().bounds.size
  }
  
  static func relativeWidth(_ width: CGFloat) -> CGFloat {
    return currentWindowSize.width * (width / 414)
  }
  static func relativeHeight(_ height: CGFloat) -> CGFloat {
    return currentWindowSize.height * (height / 896)
  }
}

extension CGSize: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
  }

  public init(extendedGraphemeClusterLiteral value: String) {
    let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
  }

  public init(unicodeScalarLiteral value: String) {
    let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
  }
}
