//
//  UsernameSetupViewController.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class UsernameSetupViewController: UIViewController {

  var titleLabel: UILabel = {
    let label = AuroraTitleLabel()
    label.text = NSLocalizedString("UsernameSetup.title", comment: "")
    return label
  }()

  var usernameTextfield: UITextField = {
    let textfield = AuroraTextfield()
    textfield.placeholder = NSLocalizedString("UsernameSetup.placeholder", comment: "")
    return textfield
  }()

  var infoLabel: UILabel = {
    let label = AuroraInfoLabel(isCentered: true)
    label.text = NSLocalizedString("UsernameSetup.info", comment: "")
    return label
  }()

  var nextButton: UIButton = {
    let button = AuroraRoundButton()
    return button
  }()

  var is2ndGen: Bool = false

  private var presenter: UsernameSetupPresenterProtocol

  init(presenter: UsernameSetupPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    self.presenter.view = self
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

    log.notice("Flow: Will Appear")

    UIView.performWithoutAnimation {
      self.usernameTextfield.becomeFirstResponder()
    }

    if let oobeName = presenter.getUsername() {
      usernameTextfield.text = oobeName
      nextButton.isEnabled = true
    } else {
      nextButton.isEnabled = false
    }
  }

  private func setupViews() {
    self.view.backgroundColor = .auroraBlue

    self.navigationItem.title = NSLocalizedString("OOBESetup.title", comment: "")

    self.view.addSubview(titleLabel)

    self.usernameTextfield.delegate = self
    self.usernameTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    self.view.addSubview(usernameTextfield)
    self.view.addSubview(infoLabel)

    self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    self.view.addSubview(nextButton)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: relativeHeight(50)),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(50)),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(50)),

      usernameTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: relativeHeight(30)),
      usernameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(52.5)),
      usernameTextfield.heightAnchor.constraint(equalToConstant: 50),
      usernameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(52.5)),

      nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -relativeWidth(24)),
      nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(24)),
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(24)),
      nextButton.heightAnchor.constraint(equalToConstant: 50),

      infoLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -relativeHeight(10)),
      infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: relativeWidth(24)),
      infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -relativeWidth(24))
    ])
  }

  @objc
  func textFieldDidChange() {
    guard let text = usernameTextfield.text else { return }

    if text.count >= Constants.maxNameLength {
      let trimmedText = String(text.dropLast(text.count - Constants.maxNameLength))
      usernameTextfield.text = trimmedText
    }

    self.nextButton.isEnabled = text != "" ? true : false
  }

  @objc
  func nextButtonPressed() {
    guard let username = self.usernameTextfield.text else { return }
    presenter.saveUsername(with: username)
  }
}

extension UsernameSetupViewController: UsernameSetupPresenterToViewProtocol {
  func usernameSaved() {
    log.notice("Flow: Going to ImageSetupViewController")
    AppSettings.setOOBEStep(with: OOBEStep.Color.rawValue)
    RouterViewController.checkOOBENextStep(into: self.navigationController)
  }
}

extension UsernameSetupViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.auroraGreen.cgColor
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.auroraSoftDarkBlue.cgColor
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

    let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

    if newString.isEmpty {
      textField.layer.borderColor = UIColor.auroraGreen.cgColor
      nextButton.isEnabled = false
    } else {
      textField.layer.borderColor = UIColor.auroraSoftDarkBlue.cgColor
      nextButton.isEnabled = true
    }
    return true
  }
}
