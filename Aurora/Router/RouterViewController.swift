//
//  RouterViewController.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import CoreBluetooth

class RouterViewController: UIViewController {

  private var navigation: UINavigationController?
  private var presenter: RouterPresenterProtocol

  private lazy var auroraLogo: UIImageView = {
    let logo = UIImageView(image: UIImage(named: "aurora_logo"))
    logo.contentMode = .scaleAspectFit
    logo.translatesAutoresizingMaskIntoConstraints = false
    return logo
  }()

  init(presenter: RouterPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    self.presenter.view = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    log.notice("Flow: Appear")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
      self?.startRouter()
    })
  }

  private func startRouter() {
    UIView.animate(withDuration: Constants.animationDuration, delay: 0.8, options: .curveEaseOut, animations: {
      self.auroraLogo.alpha = 0
    }, completion: { [weak self] _ in
      self?.navigation = self?.navigationController
      self?.presenter.checkForUser()
    })
  }

  func setupViews() {
    self.view.backgroundColor = .auroraBlue
    self.view.addSubview(auroraLogo)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      auroraLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      auroraLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      auroraLogo.heightAnchor.constraint(equalToConstant: relativeWidth(150)),
      auroraLogo.widthAnchor.constraint(equalToConstant: relativeWidth(150))
    ])
  }

  static func checkOOBENextStep(into navigation: UINavigationController?) {
    let state = OOBEStep(rawValue: AppSettings.getOOBEStep())

    switch state {
    case .Username:
      goToUsernameSetup(in: navigation)
    case .Color:
      goToUserColorSetup(in: navigation)
    case .Chat:
      goToChatViewController(in: navigation)
    default:
      log.error("Incorrect OOBE step!")
      break
    }
  }

  private static func goToUsernameSetup(in navigation: UINavigationController?) {

    log.notice("Flow: Going into UsernameSetupViewController")
    let vc = DependencyManager.resolve(UsernameSetupViewController.self)
    pushVC(vc, in: navigation)
  }

  private static func goToUserColorSetup(in navigation: UINavigationController?) {

    pushControllerIfNeeded(index: 0, navigation: navigation)

    log.notice("Flow: Going into UserColorSetupViewController")
    let vc = DependencyManager.resolve(UserColorSetupViewController.self)
    pushVC(vc, in: navigation)
  }

  private static func goToChatViewController(in navigation: UINavigationController?) {
    log.notice("Flow: Going into EmptyDashboardViewController")
    let chatVC = DependencyManager.resolve(ChatViewController.self)
    let navVC = UINavigationController(rootViewController: chatVC)
    UIApplication.shared.windows.first?.rootViewController = nil
    UIApplication.shared.windows.first?.rootViewController = navVC
    UIApplication.shared.windows.first?.makeKeyAndVisible()
  }

  private static func pushControllerIfNeeded(index: Int, navigation: UINavigationController?) {

    let classArray: [UIViewController.Type] = [ UsernameSetupViewController.self, UserColorSetupViewController.self]

    guard let navigation = navigation, !navigation.hasViewControllerOfType(ofClass: classArray[index]) else { return }


    var vc: UIViewController!
    switch index {
    case 0:
      vc = DependencyManager.resolve(UsernameSetupViewController.self)
    case 1:
      vc = DependencyManager.resolve(UserColorSetupViewController.self)
    default:
      break
    }

    navigation.pushViewController(vc, animated: false)
  }

  static func pushFade(_ vc: UIViewController, in navigation: UINavigationController?) {
    vc.view.layoutIfNeeded()
    let transition: CATransition = CATransition()
    transition.duration = Constants.animationDuration
    transition.type = CATransitionType.fade
    navigation?.view.layer.add(transition, forKey: nil)
    navigation?.pushViewController(vc, animated: false)
  }

  static func popFade(in navigation: UINavigationController?) {
    let transition: CATransition = CATransition()
    transition.duration = Constants.animationDuration
    transition.type = CATransitionType.fade
    navigation?.view.layer.add(transition, forKey: nil)
    navigation?.popViewController(animated: false)
  }

  static func pushVC(_ vc: UIViewController, in navigation: UINavigationController?) {
      navigation?.pushViewController(vc, animated: true)
  }

  static func popVC(in navigation: UINavigationController?) {
    navigation?.popViewController(animated: true)
  }

  static func setOOBEStep(with value: Int) {
    if let oobeStep = OOBEStep(rawValue: value) {
      AppSettings.setOOBEStep(with: oobeStep.rawValue)
    }
  }
}

extension RouterViewController: RouterPresenterToViewProtocol {

  func navigateToNextScreen() {
    RouterViewController.checkOOBENextStep(into: self.navigation)
  }
}
