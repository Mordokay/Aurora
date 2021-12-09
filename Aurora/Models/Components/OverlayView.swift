//
//  OverlayView.swift
//  Aurora
//
//  Created by Pedro Saldanha on 08/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit
import Lottie

private class FadeImageView: UIImageView {
  @IBInspectable var fadeDuration: Double = 0.5
}

final class OverlayView: UIView {

  private var label: UILabel!
  private var indicator: AnimationView!

  private var timer: Timer?
  private let animationDuration: TimeInterval = 0.35

  var isLoading: Bool = false {
    didSet {
      if oldValue == isLoading { return }

      self.isHidden = !isLoading
      self.isUserInteractionEnabled = isLoading

      UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve, animations: {
        self.alpha = self.isLoading ? 1.0 : 0.0

      }, completion: { (_) in

        if self.isLoading {
          self.timer?.invalidate()
          self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
          self.timer?.fire()
        } else {
          if let timer = self.timer, timer.isValid {
            timer.invalidate()
          }
        }
      })
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
//    blurEffectView.frame = bounds
    indicator.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    label.center = self.center.applying(.init(translationX: 0, y: -label.optimalSize.height - 16))
  }

  deinit {
    timer?.invalidate()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()

    indicator = AnimationView(name: "anim_loading")
    indicator.contentMode = .scaleAspectFit
    indicator.loopMode = .loop
    indicator.backgroundBehavior = .pauseAndRestore
    indicator.frame.size = CGSize(width: 80, height: 48)
    addSubview(indicator)

    self.isUserInteractionEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  final func setupView() {

    backgroundColor = UIColor.auroraBlue.withAlphaComponent(0.8)

    label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = .auroraText
    label.font = .aurora20DynamicBold

    addSubview(label)

    hide()
  }

  @objc
  private func animate() {
    indicator.play()
  }

  func showWithMessage(_ message: String) {

    let maxWidth = CGSize.currentWindowSize.width * 0.7
    label.text = message
    label.frame.size.width =  label.optimalSize.width >= maxWidth ? maxWidth : CGSize.currentWindowSize.width * 0.7

    UIView.transition(with: label, duration: animationDuration, options: .transitionCrossDissolve, animations: {
      self.label.sizeToFit()
    }, completion: nil)

    show()
  }

  func show(withAnimation: Bool = true) {
    if !isLoading {
      self.isLoading = true
    }

    if !withAnimation {
      self.layer.zPosition = 20
      return
    }

    UIView.animate(withDuration: animationDuration) {
        self.layer.zPosition = 20
      }
  }

  func hide(withAnimation: Bool = true) {
    if isLoading {
      self.isLoading = false
    }

    if !withAnimation {
      self.layer.zPosition = -1
      return
    }

    UIView.animate(withDuration: animationDuration) {
      self.layer.zPosition = -1
    }
  }
}
