//
//  ChatInputDelegate.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class ChatInputDelegate: NSObject, UITextViewDelegate {

  weak var parent: ChatViewController?

  init(viewController: ChatViewController) {
    self.parent = viewController
  }

  func textViewDidChange(_ textView: UITextView) {
    onTextChanged(with: textView.text)
  }

  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return true
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

    // If updated text view will be empty, add the placeholder
    // and set the cursor to the beginning of the text view
    if updatedText.isEmpty {
      self.parent?.presenter.removeLastMessageWriten()
    } else {
      onTextChanged(with: text)
    }
    self.parent?.inputBottomBar.sendButton.isHidden = updatedText.isEmpty

    return true
  }

  private func onTextChanged(with text: String) {
    self.parent?.presenter.storeLastMessage(with: text)
  }
}

extension ChatInputDelegate: KeyboardToolbarDelegate {

  func onSendPress(_ view: KeyboardToolbarView) {
    guard let message = view.textField.text, !message.trimmed.isEmpty else {
      return
    }

    parent?.presenter.sendNewTextMessage(text: message.trimmingCharacters(in: .whitespacesAndNewlines))
    parent?.presenter.removeLastMessageWriten()
    parent?.inputBottomBar.textField.text = ""
    parent?.inputBottomBar.sendButton.isHidden = true
  }
}
