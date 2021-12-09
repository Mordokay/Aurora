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
    registerChatModule(on: container)
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
}
