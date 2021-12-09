//
//  UIDevice+Extension.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

extension UIDevice {
  var deviceId: String {
    return self.identifierForVendor!.uuidString
  }

  static var modelCode: String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
      return simulatorModelIdentifier
    }
    var systemInfo = utsname()
    uname(&systemInfo)
    return withUnsafeMutablePointer(to: &systemInfo.machine) {ptr in
      String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
    }
  }

  static var model: DeviceModel {
    // Thanks https://stackoverflow.com/a/26962452/5928180
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafeMutablePointer(to: &systemInfo.machine) { ptr in
      String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
    }

    // Thanks https://stackoverflow.com/a/33495869/5928180
    if modelCode == "i386" || modelCode == "x86_64" {
      if let simulatorModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"], let model = DeviceModel.Model(modelCode: simulatorModelCode) {
        return DeviceModel.simulator(model)
      } else if let simulatorModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return DeviceModel.unrecognizedSimulator(simulatorModelCode)
      } else {
        return DeviceModel.unrecognized(modelCode)
      }
    } else if let model = DeviceModel.Model(modelCode: modelCode) {
      return DeviceModel.real(model)
    } else {
      return DeviceModel.unrecognized(modelCode)
    }
  }

  static var modelType: DeviceModel.Model? {
    return UIDevice.model.model
  }

  static func isDevice(ofType model: DeviceModel.Model) -> Bool {
    return UIDevice.modelType == model
  }

  static func isSimulator() -> Bool {
    return model.isSimulator
  }

  static func isPhone8Size() -> Bool {
    return CGSize.currentWindowSize == DeviceTemplate.iPhone6.rawValue
  }

  static func hasNotch() -> Bool {
    if #available(iOS 11.0, *) {
      if let window = UIApplication.shared.keyWindow, window.safeAreaInsets.bottom > 0 {
      return true
      }
    }

    return false
  }
}

enum DeviceTemplate: CGSize {

  case iPhoneSE = "{320, 568}"
  case iPhone6 = "{375, 667}"
  case iPhonePlus = "{414, 736}"
  case iPhoneX = "{375, 812}"
  case iPhoneXs = "{414, 896}"

  static var currentType: DeviceTemplate? {

    switch CGSize.currentWindowSize {
    case DeviceTemplate.iPhoneSE.rawValue:
      return .iPhoneSE
    case DeviceTemplate.iPhone6.rawValue:
      return .iPhone6
    case DeviceTemplate.iPhonePlus.rawValue:
      return .iPhonePlus
    case DeviceTemplate.iPhoneXs.rawValue:
      return .iPhoneXs
    default:
      return .iPhoneX
    }
  }
}

public enum DeviceModel {
  case simulator(Model)
  case unrecognizedSimulator(String)
  case real(Model)
  case unrecognized(String)

  public enum Model: String {
    case iPod1            = "iPod 1"
    case iPod2            = "iPod 2"
    case iPod3            = "iPod 3"
    case iPod4            = "iPod 4"
    case iPod5            = "iPod 5"
    case iPad2            = "iPad 2"
    case iPad3            = "iPad 3"
    case iPad4            = "iPad 4"
    case iPhone4          = "iPhone 4"
    case iPhone4S         = "iPhone 4S"
    case iPhone5          = "iPhone 5"
    case iPhone5S         = "iPhone 5S"
    case iPhone5C         = "iPhone 5C"
    case iPadMini1        = "iPad Mini 1"
    case iPadMini2        = "iPad Mini 2"
    case iPadMini3        = "iPad Mini 3"
    case iPadAir1         = "iPad Air 1"
    case iPadAir2         = "iPad Air 2"
    case iPadPro9_7       = "iPad Pro 9.7\""
    case iPadPro9_7_cell  = "iPad Pro 9.7\" cellular"
    case iPadPro10_5      = "iPad Pro 10.5\""
    case iPadPro10_5_cell = "iPad Pro 10.5\" cellular"
    case iPadPro12_9      = "iPad Pro 12.9\""
    case iPadPro12_9_cell = "iPad Pro 12.9\" cellular"
    case iPhone6          = "iPhone 6"
    case iPhone6plus      = "iPhone 6 Plus"
    case iPhone6S         = "iPhone 6S"
    case iPhone6Splus     = "iPhone 6S Plus"
    case iPhoneSE         = "iPhone SE"
    case iPhone7          = "iPhone 7"
    case iPhone7plus      = "iPhone 7 Plus"
    case iPhone8          = "iPhone 8"
    case iPhone8plus      = "iPhone 8 Plus"
    case iPhoneX          = "iPhone X"
    case iPhoneXSMax      = "iPhone XS Max"
    case iPhoneXR         = "iPhone XR"
    case iPhoneXS         = "iPhoneXS"

    init?(modelCode: String) {
      switch modelCode {
      case "iPod1,1":    self = .iPod1
      case "iPod2,1":    self = .iPod2
      case "iPod3,1":    self = .iPod3
      case "iPod4,1":    self = .iPod4
      case "iPod5,1":    self = .iPod5
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": self = .iPad2
      case "iPad2,5", "iPad2,6", "iPad2,7":    self = .iPadMini1
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":  self = .iPhone4
      case "iPhone4,1":  self = .iPhone4S
      case "iPhone5,1", "iPhone5,2":  self = .iPhone5
      case "iPhone5,3", "iPhone5,4":  self = .iPhone5C
      case "iPad3,1", "iPad3,2", "iPad3,3":    self = .iPad3
      case "iPad3,4", "iPad3,5", "iPad3,6":    self = .iPad4
      case "iPhone6,1", "iPhone6,2":  self = .iPhone5S
      case "iPad4,1":    self = .iPadAir1
      case "iPad4,2":    self = .iPadAir2
      case "iPad4,4", "iPad4,5", "iPad4,6", "iPad4,7", "iPad4,8", "iPad4,9":    self = .iPadMini2
      case "iPad6,3", "iPad6,11":    self = .iPadPro9_7
      case "iPad6,4", "iPad6,12":    self = .iPadPro9_7_cell
      case "iPad6,7":    self = .iPadPro12_9
      case "iPad6,8":    self = .iPadPro12_9_cell
      case "iPad7,3":    self = .iPadPro10_5
      case "iPad7,4":    self = .iPadPro10_5_cell
      case "iPhone7,1":  self = .iPhone6plus
      case "iPhone7,2":  self = .iPhone6
      case "iPhone8,1":  self = .iPhone6S
      case "iPhone8,2":  self = .iPhone6Splus
      case "iPhone8,4":  self = .iPhoneSE
      case "iPhone9,1", "iPhone9,3":  self = .iPhone7
      case "iPhone9,2", "iPhone9,4":  self = .iPhone7plus
      case "iPhone10,1", "iPhone10,4": self = .iPhone8
      case "iPhone10,2", "iPhone10,5": self = .iPhone8plus
      case "iPhone10,3", "iPhone10,6": self = .iPhoneX
      case "iPhone11,8": self = .iPhoneXR
      case "iPhone11,2": self = .iPhoneXS
      case "iPhone11,6", "iPhone11,4": self = .iPhoneXSMax
      default:           return nil
      }
    }
  }

  public var name: String {
    switch self {
    case .simulator(let model):         return "Simulator[\(model.rawValue)]"
    case .unrecognizedSimulator(let s): return "UnrecognizedSimulator[\(s)]"
    case .real(let model):              return model.rawValue
    case .unrecognized(let s):          return "\(s)"
    }
  }

  public var model: DeviceModel.Model? {
    switch self {
    case .simulator(let model):         return model
    case .real(let model):              return model
    default:     return nil
    }
  }

  public var isSimulator: Bool {
    if case .simulator = self {
      return true
    }
    return false
  }
}
