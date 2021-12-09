//
//  UIFont.swift
//  FlappyBird
//
//  Created by Pedro Saldanha on 13/07/2019.
//  Copyright © 2019 GreenSphereStudios. All rights reserved.
//

import UIKit

extension UIFont {
  private static func auroraFont(ofSize size: CGFloat, isBold: Bool = false, isItalic: Bool = false) -> UIFont {
    if isBold {
      return UIFont.boldSystemFont(ofSize: size)
    } else if isItalic {
      return UIFont.italicSystemFont(ofSize: size)
    }

    return UIFont.systemFont(ofSize: size)
  }

//  public static var tetris10: UIFont { return tetrisFont(ofSize: 10) }
//  public static var tetris10Dynamic: UIFont { return tetrisFont(ofSize: CGSize.relativeWidth(10)) }

  public static var aurora10: UIFont { return auroraFont(ofSize: 10) }
  public static var aurora12: UIFont { return auroraFont(ofSize: 12) }
  public static var aurora14: UIFont { return auroraFont(ofSize: 14) }
  public static var aurora16: UIFont { return auroraFont(ofSize: 16) }

  public static var aurora12Dynamic: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(12)) }
  public static var aurora14Dynamic: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(14)) }
  public static var aurora16Dynamic: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(16)) }

  public static var aurora14Bold: UIFont { return auroraFont(ofSize: 14, isBold: true) }

  public static var aurora14DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(14), isBold: true) }
  public static var aurora15DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(15), isBold: true) }
  public static var aurora20DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(20), isBold: true) }
  public static var aurora24DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(24), isBold: true) }
  public static var aurora28DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(28), isBold: true) }
  public static var aurora50DynamicBold: UIFont { return auroraFont(ofSize: CGSize.relativeWidth(50), isBold: true) }
  
}

