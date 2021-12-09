//
//  UsernameSetupPresenter.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

protocol UsernameSetupPresenterToViewProtocol: AnyObject {
  func usernameSaved()
}

protocol UsernameSetupPresenterProtocol: AnyObject {

  var view: UsernameSetupPresenterToViewProtocol? { get set }
  func saveUsername(with username: String)
  func getUsername() -> String?
}

class UsernameSetupPresenter: UsernameSetupPresenterProtocol {
  weak var view: UsernameSetupPresenterToViewProtocol?

  func saveUsername(with username: String) {
    AppSettings.setUserName(with: username)
    view?.usernameSaved()
  }

  func getUsername() -> String? {
    return AppSettings.getUserName()
  }
}
