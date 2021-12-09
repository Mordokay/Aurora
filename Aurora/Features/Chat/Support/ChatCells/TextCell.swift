//
//  TextCell.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol TextCellProtocol: ChatMessageCell {
  func setup(message: ChatMessage, delegate: TTTAttributedLabelDelegate?)
}

class TextCell: ChatMessageCell, TextCellProtocol  {

  var nameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = .aurora14Bold
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    label.textAlignment = .left
    return label
  }()

  var baloonText: PaddingLabel = {
    let label = PaddingLabel(top: 20, bottom: 10, left: 16, right: 16)
    label.backgroundColor = .clear
    label.textAlignment = .left
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.layer.masksToBounds = true

    label.layer.cornerRadius = 8
    label.layer.borderWidth = 1
    label.layer.borderColor = UIColor.auroraCerulean.withAlphaComponent(0.8).cgColor
    if #available(iOS 11.0, *) {
      label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }

    label.backgroundColor = .clear
    label.preferredMaxLayoutWidth = UIView.staticRelativeWidth(230)

    var urlAttr = [NSAttributedString.Key: AnyObject]()
    urlAttr[NSAttributedString.Key.foregroundColor] = UIColor.white
    urlAttr[NSAttributedString.Key.underlineStyle] = 1 as AnyObject
    urlAttr[NSAttributedString.Key.font] = UIFont.aurora16

    label.linkAttributes = urlAttr
    label.inactiveLinkAttributes = urlAttr

    label.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.init(arrayLiteral: [NSTextCheckingResult.CheckingType.phoneNumber,NSTextCheckingResult.CheckingType.link]).rawValue
    return label
  }()

  var timeInfoLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = .aurora10
    label.textColor = .auroraGreyText
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    return label
  }()

  var message: ChatMessage!

  func setup(message: ChatMessage, delegate: TTTAttributedLabelDelegate?) {
    self.message = message
    let text = message.content.formatWithSpacing(spacing: 3)

    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.auroraLightBlueGrey, range: NSRange(location: 0, length: text.length))
    text.addAttribute(NSAttributedString.Key.font, value: UIFont.aurora16, range: NSRange(location: 0, length: text.length))

    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: text.string, options: [], range: NSRange(location: 0, length: text.string.utf16.count))

    text.append(NSAttributedString(string: UIDevice.isPhone8Size() ? " ____________" : " ______________", attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear]))

    let isSent = message.deviceId == UIDevice().deviceId
    nameLabel.textColor = isSent ? AppSettings.getUserColor() : AppSettings.getColor(for: message.deviceId)
    nameLabel.text = message.username
    baloonText.setText(text)
    baloonText.delegate = delegate
    timeInfoLabel.text = Date(timeIntervalSince1970: self.message.timestamp.toSecondsFromMilliseconds).simpleDate("d MMM, h:mm a")

  }

  override func setup() {
    self.backgroundColor = .clear
    self.isUserInteractionEnabled = true
    self.selectionStyle = .none

    baloonText.addSubview(nameLabel)
    self.contentView.addSubview(baloonText)
    self.contentView.addSubview(timeInfoLabel)

    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: self.baloonText.topAnchor, constant: 3),
      nameLabel.leadingAnchor.constraint(equalTo: baloonText.leadingAnchor, constant: 6),
      nameLabel.trailingAnchor.constraint(equalTo: self.baloonText.trailingAnchor),

      baloonText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
      baloonText.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -relativeWidth(24)),
      baloonText.widthAnchor.constraint(lessThanOrEqualToConstant: CGSize.currentWindowSize.width - relativeWidth(104)),
      baloonText.topAnchor.constraint(equalTo: self.contentView.topAnchor),

      timeInfoLabel.trailingAnchor.constraint(equalTo: baloonText.trailingAnchor, constant: -16),
      timeInfoLabel.bottomAnchor.constraint(equalTo: baloonText.bottomAnchor, constant: -10),
    ])
  }
}
