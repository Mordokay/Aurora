//
//  RealmChatStorage.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation

struct RealmChatStorage: ChatStorageProtocol {

  let realm: Realm
  init(realm: Realm) {
    self.realm = realm
  }

  // MARK: - CREATE
  internal func createMessage(deviceId: String,
                             username: String,
                             timestamp: Double,
                             content: String,
                             type: ChatMessageType) -> ChatMessageRealm? {


    do {
      let chatMessage = ChatMessageRealm()
      try realm.safeWrite {
        chatMessage.deviceId = deviceId
        chatMessage.username = username
        chatMessage.timestamp = timestamp
        chatMessage.content = content
        chatMessage.type = type
        realm.add(chatMessage, update: .all)
      }
      return chatMessage
    } catch let error {
      log.error(error)
      return nil
    }
  }

  func getMessagesFromLast(days: Int) -> List<ChatMessageRealm>? {

    let textMessageValidDuration = Date().changeDays(by: -days).millisecondsSince1970

    return realm.objects(ChatMessageRealm.self)
      .filter("timestamp > %@", textMessageValidDuration)
      .sorted(byKeyPath: "timestamp", ascending: true)
  }

  func findChatMessage(withIdInternal idInternal: String) -> ChatMessageRealm? {
    return realm.objects(ChatMessageRealm.self).filter("idInternal = %@", idInternal)
      .first
  }

  func getAllChatMessages() -> List<ChatMessageRealm>? {
    return realm.objects(ChatMessageRealm.self)
      .sorted(byKeyPath: "timestamp", ascending: true)
  }

  func getAllChatMessages(from deviceId: Bool) -> List<ChatMessageRealm>? {
    return realm.objects(ChatMessageRealm.self)
      .sorted(byKeyPath: "timestamp", ascending: true)
      .filter("deviceId = %@", deviceId)
  }

  func deleteMessage(with internalId: String) -> Bool {
    do {
      let obj = realm.objects(ChatMessageRealm.self).filter("idInternal = %@", internalId)
      try realm.safeWrite {
        realm.delete(obj)
      }
      return true
    } catch let error {
      log.error(error)
      return false
    }
  }
}
