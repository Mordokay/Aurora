//
//  RouterInteractor.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import RxSwift

enum OOBEStep: Int {
  case Username = 1
  case Color
  case Chat
}

protocol RouterInteractorProtocol: AnyObject {
  var presenter: RouterInteractorToPresenterProtocol? { get set }

  func checkForUser()
}

protocol RouterInteractorToPresenterProtocol: AnyObject {

  func navigateToNextStep(with step: OOBEStep)
}

class RouterInteractor: RouterInteractorProtocol {

  weak var presenter: RouterInteractorToPresenterProtocol?

  private var realmManager: RealmManager
  private var disposeBag = DisposeBag()

  init(realmManager: RealmManager) {
    self.realmManager = realmManager
  }

  func checkForUser() {
    let username = AppSettings.getUserName()
    let userColor = AppSettings.getUserColor()

    if username != nil && userColor != nil {
      presenter?.navigateToNextStep(with: .Chat)
      return
    }

    if username != nil {
      presenter?.navigateToNextStep(with: .Color)
      return
    }

    presenter?.navigateToNextStep(with: .Username)
  }
}
