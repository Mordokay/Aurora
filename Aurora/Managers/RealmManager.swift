//
//  RealmManager.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import RealmSwift

final class RealmManager {

  var realm: Realm
  var chatStorage: ChatStorageProtocol

  init() {
    self.realm = RealmManager.getRealm()
    self.chatStorage = RealmChatStorage(realm: realm)
  }

  @discardableResult
  func createMessage(deviceId: String, username: String, timestamp: Double, content: String, type: ChatMessageType) -> ChatMessageRealm? {
    chatStorage.createMessage(deviceId: deviceId, username: username, timestamp: timestamp, content: content, type: type)
  }

  func getMessagesFromLast(days: Int) -> Results<ChatMessageRealm>? {
    return chatStorage.getMessagesFromLast(days: days)
  }

  func findChatMessage(withIdInternal idInternal: String) -> ChatMessageRealm? {
    return chatStorage.findChatMessage(withIdInternal: idInternal)
  }

  func getAllChatMessages() -> Results<ChatMessageRealm>? {
    return chatStorage.getAllChatMessages()
  }

  func getAllChatMessages(from deviceId: Bool) -> Results<ChatMessageRealm>? {
    return chatStorage.getAllChatMessages(from: deviceId)
  }

  func deleteMessage(with internalId: String) -> Bool {
    return chatStorage.deleteMessage(with: internalId)
  }


  // MARK: - Realm Generator
  private static func getRealm() -> Realm {
    do {
      var config = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
//          if oldSchemaVersion < 17 {
//            migration.deleteData(forType: ChatMessageRealm.className())
//          }

//          if oldSchemaVersion < 16 {
//            migration.enumerateObjects(ofType: UserRealm.className()) { _, newObject in
//              guard let new = newObject else {
//                return
//              }
//              new["email"] = ""
//            }
//          }
      })
      config.fileURL = getRealmURL()

      let realm = try Realm(configuration: config)
      return realm
    } catch let error {
      log.error("Failed to create realm with error: \(error.localizedDescription)")
      preconditionFailure("Failed to create realm with error: \(error.localizedDescription)")
    }
  }

  private static func getRealmURL() -> URL? {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return documentsURL.appendingPathComponent("default.realm")
  }
}
