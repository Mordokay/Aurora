//
//  AppSettings+OOBE.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

struct AppSettings {

  static func getUserName() -> String? {
    return UserDefaults.standard.string(forKey: Constants.AppSettings.kOobeUsername)
  }

  static func setUserName(with username: String) {
    UserDefaults.standard.set(username, forKey: Constants.AppSettings.kOobeUsername)
  }

  static func getUserColor() -> UIColor? {
    if let hexColor = UserDefaults.standard.string(forKey: Constants.AppSettings.kOobeUserColor) {
      return UIColor(hexString: hexColor)
    } else {
      return nil
    }
  }

  static func setUserColor(with color: UIColor) {
    UserDefaults.standard.set(color.hexString, forKey: Constants.AppSettings.kOobeUserColor)
  }

  static func setOOBEStep(with value: Int) {
    UserDefaults.standard.set(value, forKey: Constants.AppSettings.kOOBEStep)
  }

  static func getOOBEStep() -> Int {
    return UserDefaults.standard.integer(forKey: Constants.AppSettings.kOOBEStep)
  }

  static func appVersion() -> String? {
    guard let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
      let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
        return nil
    }
    return "\(shortVersion)(\(version))"
  }
}
