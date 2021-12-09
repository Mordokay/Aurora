//
//  ChatMessageRealm.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import RealmSwift

@objc
enum ChatMessageType: Int, RealmEnum {
  case unknown = -1
  case textEnterExit = 0
  case textBot = 1
  case textUser = 2
}

class ChatMessageRealm: Object {

  @objc dynamic var idInternal: String = UUID().uuidString

  @objc dynamic var deviceId: String = ""
  @objc dynamic var username: String = ""
  @objc dynamic var timestamp: Double = 0
  @objc dynamic var content: String = ""
  @objc dynamic var type: ChatMessageType = .unknown

  override class func primaryKey() -> String? { return "idInternal" }
}
