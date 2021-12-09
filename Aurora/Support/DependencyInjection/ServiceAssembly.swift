//
//  ServiceAssembly.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class ServiceAssembly: Assembly {
  func assemble(container: Container) {
    registerMosquittoManager(on: container)
    registerRealmManager(on: container)
    registerChatManager(on: container)
  }

  private func registerMosquittoManager(on container: Container) {
    container.register(MosquittoManager.self) { r in
      let realmManager = r ~> (RealmManager.self)
      return MosquittoManager(realmManager: realmManager)
    }.inObjectScope(.container) //Singleton
  }

  private func registerRealmManager(on container: Container) {
    container.register(RealmManager.self) { r in
      return RealmManager()
    }.inObjectScope(.container) //Singleton
  }

  private func registerChatManager(on container: Container) {
    container.register(ChatManager.self) { r in
      let mosquittoManager = r ~> (MosquittoManager.self)
      let realmManager = r ~> (RealmManager.self)
      return ChatManager(mosquittoManager: mosquittoManager, realmManager: realmManager)
    }.inObjectScope(.container) //Singleton
  }
}
