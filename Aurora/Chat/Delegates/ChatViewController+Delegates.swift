//
//  ChatMessagesDelegate.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import TTTAttributedLabel

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.presenter.messagesCount()
  }

  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    NotificationCenter.default.removeObserver(cell)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let message = self.presenter.getMessage(at: indexPath.row) else {
      return UITableViewCell()
    }
    return textCell(for: message, at: indexPath, in: tableView)
  }

  // MARK: - auxiliar cell builders
  func textCell(for message: ChatMessage, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {

    let isSent = message.deviceId == UIDevice().deviceId
    guard let cell: TextCellProtocol = isSent ? tableView.dequeueReusableView(TextCell.self, indexPath) : tableView.dequeueReusableView(TextCellPartner.self, indexPath) else {
      return UITableViewCell()
    }
    cell.setup(message: message, delegate: self)
    return cell
  }
}

extension ChatViewController: TTTAttributedLabelDelegate {

  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }

  func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let action1 = UIAlertAction(title: NSLocalizedString("Generic.copy", comment: ""), style: .default) { _ in
      self.copyToClipboard(url.absoluteString)
    }
    actionSheet.addAction(action1)
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Generic.cancel", comment: ""), style: .cancel, handler: nil))
    self.parent?.present(actionSheet, animated: true, completion: nil)
  }

  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
    showPhoneCallAlert(for: phoneNumber)
  }

  func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWithPhoneNumber phoneNumber: String!, at point: CGPoint) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    let action1Title =  NSLocalizedString("Generic.call", comment: "") + " " + phoneNumber
    let action1 = UIAlertAction(title: action1Title, style: .default, handler: { _ in
      self.showPhoneCallAlert(for: phoneNumber)
    })
    let action2 = UIAlertAction(title: NSLocalizedString("Generic.copy", comment: ""), style: .default) { _ in
      self.copyToClipboard(phoneNumber)
    }
    actionSheet.addAction(action1)
    actionSheet.addAction(action2)
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Generic.cancel", comment: ""), style: .cancel, handler: nil))
    self.parent?.present(actionSheet, animated: true, completion: nil)
  }

  func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
  }

  func showPhoneCallAlert(for phoneNumber: String) {
    let alert = UIAlertController(title: "", message: NSLocalizedString("Action.call", comment: ""), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Generic.cancel", comment: ""), style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Generic.call", comment: ""), style: .default, handler: { _ in
      let str = "tel://"+phoneNumber
      if let url = URL(string: str) {
        if UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
      }
    }))
    self.parent?.present(alert, animated: true, completion: nil)
  }
}
