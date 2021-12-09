//
//  MQTTChatModel.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import SwiftUI

struct MQTTChatModel: Codable {
  var deviceId: String = ""
  var username: String = ""
  var timestamp: Double = 0
  var content: String = ""
  var type: Int = 0

  init(jsonString: String) {
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()

    do {
      self = try decoder.decode(MQTTChatModel.self, from: jsonData)
    } catch {
      self = MQTTChatModel()
      print(error.localizedDescription)
    }
  }

  init(deviceId: String = "", username: String = "", timestamp: Double = 0, content: String = "", type: Int = 0) {
    self.deviceId = deviceId
    self.username = username
    self.timestamp = timestamp
    self.content = content
    self.type = type
  }

  func toJson() -> String {
    let jsonData = try! JSONEncoder().encode(self)
    return String(data: jsonData, encoding: .utf8)!
  }
}
