//
//  VCAssembly.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class VCAssembly: Assembly {
  func assemble(container: Container) {

    registerUsernameSetupModule(on: container)
    registerUserColorSetupModule(on: container)
    registerChatModule(on: container)
    registerRouterModule(on: container)
  }

  private func registerUsernameSetupModule(on container: Container) {
    container.register(UsernameSetupViewController.self) { r in
      let presenter = r ~> (UsernameSetupPresenter.self)
      return UsernameSetupViewController(presenter: presenter)
    }

    container.register(UsernameSetupPresenter.self) { r in
      return UsernameSetupPresenter()
    }
  }

  private func registerUserColorSetupModule(on container: Container) {
    container.register(UserColorSetupViewController.self) { r in
      let presenter = r ~> (UserColorSetupPresenter.self)
      return UserColorSetupViewController(presenter: presenter)
    }

    container.register(UserColorSetupPresenter.self) { r in
      return UserColorSetupPresenter()
    }
  }

  private func registerChatModule(on container: Container) {
    container.register(ChatViewController.self) { r in
      let chatPresenter = r ~> (ChatPresenter.self)
      return ChatViewController(presenter: chatPresenter)
    }

    container.register(ChatPresenter.self) { r in
      let interactor = r ~> (ChatInteractor.self)
      return ChatPresenter(interactor: interactor)
    }

    container.register(ChatInteractor.self) { r in
      let mosquittoManager = r ~> (MosquittoManager.self)
      let chatManager = r ~> (ChatManager.self)
      return ChatInteractor(mosquittoManager: mosquittoManager, chatManager: chatManager)
    }
  }

  private func registerRouterModule(on container: Container) {
    container.register(RouterViewController.self) { r in
      let routerPresenter = r ~> (RouterPresenterProtocol.self)
      return RouterViewController(presenter: routerPresenter)
    }

    container.register(RouterPresenterProtocol.self) { r in
      let routerPresenter = r ~> (RouterInteractorProtocol.self)
      return RouterPresenter(interactor: routerPresenter)
    }

    container.register(RouterInteractorProtocol.self) { r in
      let realmManager = r ~> (RealmManager.self)
      return RouterInteractor(realmManager: realmManager)
    }
  }
}
