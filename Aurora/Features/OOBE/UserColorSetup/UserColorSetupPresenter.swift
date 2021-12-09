//
//  UserColorSetupPresenter.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

protocol UserColorSetupPresenterProtocol: AnyObject {

  func changeColor(_ color: UIColor)
  func setColor()
  func getColor() -> UIColor?
}

class UserColorSetupPresenter: UserColorSetupPresenterProtocol {

  var pickedColor: UIColor?

  func changeColor(_ color: UIColor) {
    self.pickedColor = color
  }

  func setColor() {
    if let color = self.pickedColor {
      AppSettings.setUserColor(with: color)
    }
  }

  func getColor() -> UIColor? {
    AppSettings.getUserColor()
  }
}
