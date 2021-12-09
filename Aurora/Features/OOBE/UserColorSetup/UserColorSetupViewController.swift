//
//  UserColorSetupViewController.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import Photos

class UserColorSetupViewController: UIViewController {

  var picker: AuroraColorPicker!

  var titleLabel: UILabel = {
    let label = AuroraTitleLabel()
    label.text = NSLocalizedString("UserColorSetup.title", comment: "")
    return label
  }()

  var subtitleLabel: UILabel = {
    let label = AuroraSecondaryTitleLabel()
    label.text = NSLocalizedString("UserColorSetup.subtitle", comment: "")
    return label
  }()

  var infoLabel: UILabel = {
    let label = AuroraInfoLabel(isCentered: true)
    label.text = NSLocalizedString("UserColorSetup.info", comment: "")
    return label
  }()

  let backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "back_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .auroraGreen
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  var finishButton: UIButton = {
    let button = AuroraRoundButton()
    button.setTitle(NSLocalizedString("Generic.finish", comment: ""), for: .normal)
    button.isEnabled = true
    return button
  }()

  private var presenter: UserColorSetupPresenterProtocol

  init(presenter: UserColorSetupPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    log.notice("Flow: Load")

    self.setupViews()
    self.setupConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log.notice("Flow: Appear")

    if let color = presenter.getColor() {
      presenter.changeColor(color)
    } else {
      presenter.changeColor(.aurora_color_picker_1)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    log.notice("Flow: Disappear")
  }

  private func setupViews() {
    self.view.backgroundColor = .auroraBlue

    self.navigationItem.title = NSLocalizedString("UserProfile.title", comment: "")

    picker = AuroraColorPicker(initColor: presenter.getColor(), ringThickness: relativeWidth(20), dragCircleWidth: relativeWidth(50))
    picker.backgroundColor = .clear
    picker.delegate = self
    view.addSubview(picker)

    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    backButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    self.view.addSubview(backButton)

    self.view.addSubview(titleLabel)
    self.view.addSubview(subtitleLabel)

    self.view.addSubview(infoLabel)

    self.finishButton.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
    self.view.addSubview(finishButton)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: relativeWidth(14)),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(16)),
      backButton.widthAnchor.constraint(equalToConstant: 44),
      backButton.heightAnchor.constraint(equalToConstant: 44),

      picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      picker.slicedGradient.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: relativeWidth(50)),
      picker.widthAnchor.constraint(equalToConstant: relativeWidth(310)),
      picker.heightAnchor.constraint(equalToConstant: relativeWidth(310)),

      titleLabel.topAnchor.constraint(equalTo: picker.slicedGradient.bottomAnchor, constant: relativeHeight(50)),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(50)),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(50)),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(50)),
      subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(50)),

      infoLabel.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -relativeHeight(10)),
      infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(24)),
      infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(24)),

      finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -relativeWidth(24)),
      finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(24)),
      finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(24)),
      finishButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  @objc
  func backButtonPressed() {
    log.debug("Tap: back arrow")
    RouterViewController.popVC(in: self.navigationController)
  }

  @objc
  func finishButtonPressed() {
    log.notice("Flow: Going to ChatViewController")
    AppSettings.setOOBEStep(with: OOBEStep.Chat.rawValue)
    RouterViewController.checkOOBENextStep(into: self.navigationController)
  }
}

extension UserColorSetupViewController: ColorPickerViewDelegate {

  //  Registers color change
  func changeColor(color: UIColor) {
    self.presenter.changeColor(color)
  }

  func setColor() {
    self.presenter.setColor()
  }
}
