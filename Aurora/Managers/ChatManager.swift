//
//  ChatManager.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import RxSwift
import UserNotifications
import RealmSwift

class ChatManager {
  let mosquittoManager: MosquittoManager
  let realmManager: RealmManager

  fileprivate let userDefaults: UserDefaults
  fileprivate let disposeBag = DisposeBag()

  init(mosquittoManager: MosquittoManager, realmManager: RealmManager) {
    self.mosquittoManager = mosquittoManager
    self.userDefaults = UserDefaults.standard
    self.realmManager = realmManager
  }

  func sendTextMessage(deviceId: String, username: String, timestamp: Double, content: String, type: ChatMessageType) {
    mosquittoManager.sendMessage(deviceId: deviceId, username: username, timestamp: timestamp, content: content, type: type.rawValue)
  }

  func createMessage(deviceId: String, username: String, timestamp: Double, content: String, type: ChatMessageType) -> ChatMessageRealm? {
    realmManager.createMessage(deviceId: deviceId, username: username, timestamp: timestamp, content: content, type: type)
  }

  func getMessagesFromLast(days: Int) -> Results<ChatMessageRealm>? {
    realmManager.getMessagesFromLast(days: days)
  }

  func findChatMessage(withIdInternal idInternal: String) -> ChatMessageRealm? {
    realmManager.findChatMessage(withIdInternal: idInternal)
  }

  func getAllChatMessages() -> Results<ChatMessageRealm>? {
    return realmManager.getAllChatMessages()
  }

  func getAllChatMessages(from deviceId: Bool) -> Results<ChatMessageRealm>? {
    return realmManager.getAllChatMessages(from: deviceId)
  }

  func deleteMessage(with internalId: String) -> Bool {
    return realmManager.deleteMessage(with: internalId)
  }
}
