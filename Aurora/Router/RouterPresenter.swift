//
//  RouterPresenter.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation

protocol RouterPresenterToViewProtocol: AnyObject {
  func navigateToNextScreen()
}

protocol RouterPresenterProtocol: AnyObject {

  var view: RouterPresenterToViewProtocol? { get set }
  func checkForUser()
}

class RouterPresenter: RouterPresenterProtocol {

  private var interactor: RouterInteractorProtocol
  weak var view: RouterPresenterToViewProtocol?

  init(interactor: RouterInteractorProtocol) {
    self.interactor = interactor
    self.interactor.presenter = self
  }

  func checkForUser() {
    interactor.checkForUser()
  }
}

extension RouterPresenter: RouterInteractorToPresenterProtocol {

  func navigateToNextStep(with step: OOBEStep) {
    AppSettings.setOOBEStep(with: step.rawValue)
    self.view?.navigateToNextScreen()
  }
}
