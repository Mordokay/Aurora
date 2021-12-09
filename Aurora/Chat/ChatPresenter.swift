//
//  ChatPresenter.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import RxSwift

protocol ChatPresenterProtocol: AnyObject {

  var view: ChatPresenterToViewProtocol? { get set }

  func storeLastMessage(with message: String)
  func getLastMessageWriten() -> String?
  func removeLastMessageWriten()

  func messagesCount() -> Int
  func getMessage(at index: Int) -> ChatMessage?
  func sendNewTextMessage(text: String)
  
  func setupObservers()
  func removeObservers()
  func getTextboxPlaceholder() -> String
}


protocol ChatPresenterToViewProtocol: AnyObject {
  func reloadChatTable()
}

class ChatPresenter: ChatPresenterProtocol {

  weak var view: ChatPresenterToViewProtocol?
  private var interactor: ChatInteractorProtocol
  private var allMessages: [ChatMessage] = []

  init(interactor: ChatInteractorProtocol) {
    self.interactor = interactor
    self.interactor.presenter = self
  }

  func setupObservers() {
    self.interactor.setupObservers()
  }

  func removeObservers() {
    self.interactor.removeObservers()
  }

  func getTextboxPlaceholder() -> String {
    return NSLocalizedString("Chat.textbox.placeholder", comment: "")
  }

  func storeLastMessage(with message: String) {
    UserDefaults.standard.set(message, forKey: Constants.Chat.lastMessage)
  }

  func getLastMessageWriten() -> String? {
    return UserDefaults.standard.string(forKey: Constants.Chat.lastMessage)
  }

  func removeLastMessageWriten() {
    UserDefaults.standard.set("", forKey: Constants.Chat.lastMessage)
  }

  // MARK: - touch methods

  private func sortAllMessages() {
    allMessages = allMessages.sorted(by: { $0.timestamp < $1.timestamp })
  }

  func sendNewTextMessage(text: String) {
    interactor.sendTextMessage(with: text)
  }

  func messagesCount() -> Int {
    return allMessages.count
  }

  func getMessage(at index: Int) -> ChatMessage? {
    if index < allMessages.count {
      return allMessages[index]
    }
    return nil
  }
}

// MARK: - interactor delegate

extension ChatPresenter: ChatInteractorToPresenterProtocol {

  func reloadChatTable() {
    self.view?.reloadChatTable()
  }

  // MARK: # chat message interactions

  func update(messages: [ChatMessage]) {
    self.allMessages = messages
    sortAllMessages()
    self.view?.reloadChatTable()
  }
}
