//
//  DependencyManager.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class DependencyManager {
  private static let shared = DependencyManager()
  private var assembler: Assembler

  func resolve<T>(_ type: T.Type) -> T {
    let synchronizedResolver = (assembler.resolver as! Container).synchronize()
    return synchronizedResolver ~> (type)
  }

  private init() {
    if CommandLine.arguments.contains("-UITests") {
      let assembler = Assembler([
//        UITestsAssembly(),
        ServiceAssembly()
        ])
      self.assembler = assembler
    } else {
      let assembler = Assembler([
        VCAssembly(),
        ServiceAssembly()
        ])
      self.assembler = assembler
    }
  }
}

extension DependencyManager {
  static func resolve<T>(_ type: T.Type) -> T {
    return DependencyManager.shared.resolve(type)
  }
}
