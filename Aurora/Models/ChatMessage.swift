//
//  ChatMessage.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import RealmSwift

class ChatMessage: Equatable {

  // MARK: properties

  var deviceId: String = ""
  var username: String = ""
  var timestamp: Double = 0
  var content: String = ""
  var type: Int = 0

  static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    return lhs.deviceId == rhs.deviceId &&
    lhs.username == rhs.username &&
    lhs.timestamp == rhs.timestamp &&
    lhs.content == rhs.content &&
    lhs.type == rhs.type
  }

  // MARK: - init

  init(deviceId: String = "", username: String = "", timestamp: Double = 0, content: String = "", type: Int = 0) {
    self.deviceId = deviceId
    self.username = username
    self.timestamp = timestamp
    self.content = content
    self.type = type
  }
}
