//
//  UIColor.swift
//  FlappyBird
//
//  Created by Pedro Saldanha on 12/07/2019.
//  Copyright © 2019 GreenSphereStudios. All rights reserved.
//

import UIKit
import Lottie

private struct RGBA {
  var red: Int32 = 0
  var green: Int32 = 0
  var blue: Int32 = 0
  var alpha: Int32 = 0
}

extension UIColor {

  private func getComponents() -> RGBA {
    guard let components = cgColor.components else {
      return RGBA()
    }
    if components.count < 4 {
      return RGBA(red: Int32(components[0]*255.0), green: Int32(components[0]*255.0), blue: Int32(components[0]*255.0), alpha: Int32(components[1]*255.0))
    } else {
      return RGBA(red: Int32(components[0]*255.0), green: Int32(components[1]*255.0), blue: Int32(components[2]*255.0), alpha: Int32(components[3]*255.0))
    }
  }

  var hexInt: Int32 {
    let components = getComponents()
    return (components.alpha << 24) + (components.red << 16) + (components.green << 8) + components.blue
  }

  var hexString: String {
    let components = getComponents()
    return String(format: "%02lX%02lX%02lX%02lX", components.alpha, components.red, components.green, components.blue)
  }

  public class var coolGreen: UIColor { return UIColor (hex: 0x00ffcc) }
  public class var darkBlue: UIColor { return UIColor(hex: 0x000f21) }
  public class var lightDarkBlue: UIColor { return UIColor(hex: 0x00486f) }
  public class var auroraLightGrey: UIColor { return UIColor(hexString: "E4E7EA") }
  public class var auroraGrey: UIColor { return UIColor(hexString: "969899") }
  public class var auroraLightBlueGrey: UIColor { return UIColor(hexString: "D4ECF5") }
  public class var auroraText: UIColor { return UIColor(hexString: "CCE8F3") }
  public class var auroraGreen: UIColor { return UIColor(hexString: "3EE1D2") }
  public class var buttonColor: UIColor { return UIColor(hexString: "00FFD2") }
  public class var auroraSoftDarkBlue: UIColor { return UIColor(hexString: "006491") }
  public class var auroraDarkBlue: UIColor { return UIColor(hexString: "000F21") }
  public class var auroraBlue: UIColor { return UIColor(hexString: "00486F") }
  public class var auroraGreyText: UIColor { return UIColor(hexString: "7594A6") }
  public class var auroraCerulean: UIColor { return UIColor(hexString: "008EC4") }


  public class var aurora_color_picker_1: UIColor { return UIColor(hex: 0xD3007A) }
  public class var aurora_color_picker_2: UIColor { return UIColor(hex: 0xD33901) }
  public class var aurora_color_picker_3: UIColor { return UIColor(hex: 0xFF7C00) }
  public class var aurora_color_picker_4: UIColor { return UIColor(hex: 0xEFAE1D) }
  public class var aurora_color_picker_5: UIColor { return UIColor(hex: 0xFFE700) }
  public class var aurora_color_picker_6: UIColor { return UIColor(hex: 0xE4FF02) }
  public class var aurora_color_picker_7: UIColor { return UIColor(hex: 0xAFFF00) }
  public class var aurora_color_picker_8: UIColor { return UIColor(hex: 0x79FF03) }
  public class var aurora_color_picker_9: UIColor { return UIColor(hex: 0x05E505) }
  public class var aurora_color_picker_10: UIColor { return UIColor(hex: 0x02C627) }
  public class var aurora_color_picker_11: UIColor { return UIColor(hex: 0x02D178) }
  public class var aurora_color_picker_12: UIColor { return UIColor(hex: 0x28E4EB) }
  public class var aurora_color_picker_13: UIColor { return UIColor(hex: 0x00A4D3) }
  public class var aurora_color_picker_14: UIColor { return UIColor(hex: 0x006BD3) }
  public class var aurora_color_picker_15: UIColor { return UIColor(hex: 0x0045D2) }
  public class var aurora_color_picker_16: UIColor { return UIColor(hex: 0x1800C8) }
  public class var aurora_color_picker_17: UIColor { return UIColor(hex: 0x6D3DC9) }
  public class var aurora_color_picker_18: UIColor { return UIColor(hex: 0x9D03DD) }
  public class var aurora_color_picker_19: UIColor { return UIColor(hex: 0xC300D3) }
  public class var aurora_color_picker_20: UIColor { return UIColor(hex: 0xD301AA) }


  var redValue: CGFloat { return CIColor(color: self).red }
  var greenValue: CGFloat { return CIColor(color: self).green }
  var blueValue: CGFloat { return CIColor(color: self).blue }
  var alphaValue: CGFloat { return CIColor(color: self).alpha }

  static var random: UIColor {
    return UIColor(red: .random(in: 0...1),
                   green: .random(in: 0...1),
                   blue: .random(in: 0...1),
                   alpha: 1.0)
  }
  
  convenience public init(hex: Int32) {
    //let alpha = CGFloat((hex & 0x000000) >> 24) / 255.0
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
    let blue = CGFloat((hex & 0xFF)) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1)
  }

  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }

  public class var aurora_tetris_color_1: UIColor { return UIColor(hex: 0x28E4EB) }
  public class var aurora_tetris_color_2: UIColor { return UIColor(hex: 0x106DED) }
  public class var aurora_tetris_color_3: UIColor { return UIColor(hex: 0xBE5BFF) }
  public class var aurora_tetris_color_4: UIColor { return UIColor(hex: 0xFF44A6) }
  public class var aurora_tetris_color_5: UIColor { return UIColor(hex: 0x00B560) }
  public class var aurora_tetris_color_6: UIColor { return UIColor(hex: 0x7BBE2F) }
  public class var aurora_tetris_color_7: UIColor { return UIColor(hex: 0xE8D726) }

  func toColorLottie() -> Color {
    return Color(r: Double(self.redValue), g: Double(self.greenValue), b: Double(self.blueValue), a: 1)
  }
}
