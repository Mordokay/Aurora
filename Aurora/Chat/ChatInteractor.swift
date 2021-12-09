//
//  ChatInteractor.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import RealmSwift

protocol ChatInteractorProtocol: AnyObject {
  var presenter: ChatInteractorToPresenterProtocol? { get set }

  func sendTextMessage(with message: String)
  func setupObservers()
  func removeObservers()
}

protocol ChatInteractorToPresenterProtocol: AnyObject {

  func update(messages: [ChatMessage])
  func reloadChatTable()
}

class ChatInteractor: ChatInteractorProtocol {

  weak var presenter: ChatInteractorToPresenterProtocol?

  private var messagesToken: NotificationToken?
  private var realmMessages: Results<ChatMessageRealm>?

  fileprivate var mosquittoManager: MosquittoManager
  fileprivate var chatManager: ChatManager

  // MARK: - init method
  init(mosquittoManager: MosquittoManager, chatManager: ChatManager) {
    self.mosquittoManager = mosquittoManager
    self.chatManager = chatManager
  }

  // MARK: - deinit methods
  deinit {
    removeObservers()
  }

  func setupObservers() {
    realmMessages = chatManager.getMessagesFromLast(days: 3)
    messagesToken = realmMessages?.safelyObserve { [weak self] changes in
      switch changes {
      case .initial:
        break
      case .update(_, _, _, _):
        var totalMessages: [ChatMessage] = []
        if let messages = self?.realmMessages {
          for message in messages {
            let myMessage = ChatMessage(deviceId: message.deviceId, username: message.username, timestamp: message.timestamp, content: message.content, type: message.type.rawValue)
            totalMessages.append(myMessage)
          }
        }
        self?.presenter?.update(messages: totalMessages)
      case .error:
        break
      }
    }
  }

  func removeObservers() {
    log.debug("Status: Remove realm observers")
    messagesToken?.invalidate()
  }

  func sendTextMessage(with message: String) {
    chatManager.sendTextMessage(deviceId: UIDevice().deviceId, username: "Banana", timestamp: Date().millisecondsSince1970, content: message, type: .textUser)
  }
}
