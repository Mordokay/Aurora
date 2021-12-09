//
//  ChatViewController.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

  // MARK: - auxiliar variables
  private var keyboardHeight: CGFloat = 0.0

  var textInputDelegate: ChatInputDelegate?
  var bottomConstraint: NSLayoutConstraint!
  var clockTimer: Timer = Timer()

  // MARK: - UI Components

  let chatTable: UITableView = {
    let myTable = UITableView()
    myTable.translatesAutoresizingMaskIntoConstraints = false
    myTable.backgroundColor = .clear
    myTable.separatorStyle = .none
    return myTable
  }()

  lazy var inputBottomBar: KeyboardToolbarView = {
    let textField = KeyboardToolbarView()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textField.textColor = .auroraText
    return textField
  }()

  // MARK: - lifecycle methods

  var presenter: ChatPresenterProtocol

  init(presenter: ChatPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    self.presenter.view = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    log.notice("Flow: Deinit")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    log.notice("Flow: Load")
    self.view.backgroundColor = .auroraBlue

    addTableView()
    addInputBottomBar()
    setupConstraints()

    self.presenter.view = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log.notice("Flow: Appear")
    self.navigationController?.setNavigationBarHidden(true, animated: animated)

    let message = self.presenter.getLastMessageWriten() ?? ""
    inputBottomBar.textField.placeholder = presenter.getTextboxPlaceholder() as NSString
    inputBottomBar.textField.placeholderColor = UIColor.auroraLightBlueGrey.withAlphaComponent(0.5)
    inputBottomBar.textField.text = message
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.presenter.setupObservers()
    self.setupNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    log.notice("Flow: Disappear")
    self.presenter.removeObservers()
    removeNotification()
    dropKeyboardInstantly()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      chatTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      chatTable.bottomAnchor.constraint(equalTo: inputBottomBar.topAnchor),
      chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),

      inputBottomBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
      inputBottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      inputBottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomConstraint,
    ])
  }

  private func setupNotifications() {
    log.debug("setupNotifications")
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func removeNotification() {
    log.debug("removeNotification")
    NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }


  // MARK: - private UI builder methods

  private func addTableView() {

    view.addSubview(chatTable)

    chatTable.delegate = self
    chatTable.dataSource = self
    chatTable.rowHeight = UITableView.automaticDimension

    chatTable.register(TextCell.self)
    chatTable.register(TextCellPartner.self)

    let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tableViewTapGesture.cancelsTouchesInView = false
    chatTable.addGestureRecognizer(tableViewTapGesture)
  }

  private func addInputBottomBar() {

    self.textInputDelegate = ChatInputDelegate(viewController: self)

    view.addSubview(inputBottomBar)
    bottomConstraint = inputBottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    inputBottomBar.textField.delegate = self.textInputDelegate
    inputBottomBar.delegate = self.textInputDelegate
  }

  // MARK: - observer actions

  @objc
  private func dismissKeyboard() {
    self.inputBottomBar.textField.resignFirstResponder()
  }

  @objc
  private func keyboardWillShow(notification: NSNotification) {

    guard self.bottomConstraint.constant == 0 else {
      return
    }

    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
       let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {

      let offset = self.adjustConstraint(with: keyboardSize.height, and: duration)

      UIView.animate(withDuration: TimeInterval(truncating: duration)) {
        self.chatTable.contentOffset.y = offset
        self.view.layoutIfNeeded()
      }
    }
  }

  @objc
  private func keyboardWillChangeFrame(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      guard self.bottomConstraint.constant != 0 && self.keyboardHeight != keyboardSize.height else { return }

      if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
        self.adjustConstraint(with: keyboardSize.height, and: duration)
      }
    }
  }

  @discardableResult
  private func adjustConstraint(with keyboardHeight: CGFloat, and duration: NSNumber) -> CGFloat {
    self.keyboardHeight = keyboardHeight

    let constraintConstant = -keyboardHeight + self.view.safeAreaInsets.bottom
    let offsetY = self.chatTable.contentOffset.y

    let offsetCut = chatTable.frame.size.height - chatTable.contentSize.height - keyboardHeight
    let adaptedOffset = max(0, min(-offsetCut, keyboardHeight))

    let newContentOffsetY = offsetY +  max(0, adaptedOffset - self.view.safeAreaInsets.bottom)

    self.chatTable.contentOffset.y = newContentOffsetY

    UIView.animate(withDuration: TimeInterval(truncating: duration)) {
      self.bottomConstraint.constant = constraintConstant
      self.view.layoutIfNeeded()
    }

    return newContentOffsetY
  }

  func dropKeyboardInstantly() {
    self.keyboardHeight = 0
    self.bottomConstraint.constant = 0
  }

  @objc
  private func keyboardWillHide(notification: NSNotification) {
    if inputBottomBar.textField.text.trimmed.isEmpty {
      presenter.removeLastMessageWriten()
    }

    guard self.bottomConstraint.constant != 0 else { return }

    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
      self.keyboardHeight = 0
      self.bottomConstraint.constant = 0
      let currentOffset = self.chatTable.contentOffset.y
      let targetOffset = max(0, currentOffset - keyboardSize.height + self.view.safeAreaInsets.bottom)
      self.chatTable.contentOffset.y = targetOffset

      UIView.animate(withDuration: TimeInterval(truncating: duration)) {
        self.view.layoutIfNeeded()
      }
    }
  }

  private func scrollToBottom() {
    let lastIndexPath = IndexPath(row: self.presenter.messagesCount() - 1, section: 0)
    self.chatTable.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
  }
}

// MARK: - presenter delegate

extension ChatViewController: ChatPresenterToViewProtocol {

  func reloadChatTable() {
    chatTable.reloadData()
    scrollToBottom()
  }
}
