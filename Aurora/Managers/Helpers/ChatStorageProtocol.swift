//
//  ChatStorageProtocol.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmInitializable {
  typealias Realm = RealmSwift.Realm
  init(realm: Realm)
}

protocol ChatStorageProtocol: RealmInitializable {
  typealias ChangeCallback = (ChatMessageRealm) -> Void
  typealias List = RealmSwift.Results

  func createMessage(deviceId: String, username: String, timestamp: Double, content: String, type: ChatMessageType) -> ChatMessageRealm?
  func getMessagesFromLast(days: Int) -> List<ChatMessageRealm>?
  func findChatMessage(withIdInternal idInternal: String) -> ChatMessageRealm?
  func getAllChatMessages() -> List<ChatMessageRealm>?
  func getAllChatMessages(from deviceId: Bool) -> List<ChatMessageRealm>?
  func deleteMessage(with internalId: String) -> Bool
}
