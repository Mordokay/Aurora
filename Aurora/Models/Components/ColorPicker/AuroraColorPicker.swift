//
//  AuroraColorPicker.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate: AnyObject {
  func changeColor(color: UIColor)
  func setColor()
}

class AuroraColorPicker: UIView {

  weak var delegate: ColorPickerViewDelegate?
  var externalBorderLayer: CALayer!

  var draggableCircle: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = false
    return imageView
  }()
  var draggableArea: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    return imageView
  }()

  var slicedGradient: SlicedGradientView!

  var lastLocation = CGPoint.zero
  var ringThickness: CGFloat = 10
  var borderDraggableAlpha: CGFloat!
  var borderDraggableWidth: CGFloat!
  var draggableBackgroundColor: UIColor!
  var dragCircleWidth: CGFloat!
  var dragCircleMultiplicator: CGFloat = 1.5
  var padding: CGFloat!

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  convenience init(initColor: UIColor? = .aurora_color_picker_1, ringThickness: CGFloat, dragCircleWidth: CGFloat) {
    self.init()

    self.ringThickness = ringThickness
    self.dragCircleWidth = dragCircleWidth
    self.padding = (dragCircleWidth * dragCircleMultiplicator - ringThickness) / 2

    slicedGradient = SlicedGradientView(frame: CGRect(origin: .zero, size: CGSize(width: relativeWidth(300), height: relativeWidth(300))))
    slicedGradient.backgroundColor = .clear
    self.addSubview(slicedGradient)
    slicedGradient.pin(into: self, safeMargin: false, padding: self.padding)

    if slicedGradient.auroraPickerColors.contains(where: { $0.hexInt == initColor?.hexInt }) {
      self.draggableBackgroundColor = initColor
    } else {
      self.draggableBackgroundColor = .aurora_color_picker_1
    }

    self.addSubview(draggableCircle)
    self.addSubview(draggableArea)
    slicedGradient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTheCircle(sender:))))
  }

  func getIndexFromAngle(angle: CGFloat) -> Int {
    var newAngle = angle
    if angle < 0 {
      newAngle = 2 * CGFloat.pi + angle
    }
    let slice = 2 * CGFloat.pi / CGFloat(slicedGradient.auroraPickerColors.count)

    for i in (0..<slicedGradient.auroraPickerColors.count) {
      if abs(slice * CGFloat(i) - newAngle) <= slice / 2 {
        return i
      }
    }
    return 0
  }

  func getColorFromAngle(angle: CGFloat) -> UIColor {
    let index = getIndexFromAngle(angle: angle)
    return slicedGradient.auroraPickerColors[index]
  }

  @objc
  fileprivate func tapTheCircle(sender: UITapGestureRecognizer) {
    let tapPosition = sender.location(in: self)
    let rads = atan2(tapPosition.y - slicedGradient.center.y, tapPosition.x - slicedGradient.center.x)

    let slicePosition = sender.location(in: slicedGradient)
    let distance = slicePosition.distance(toPoint: CGPoint(x: slicedGradient.frame.width / 2, y: slicedGradient.frame.height / 2))
    let radiusToMiddleGradient = (slicedGradient.frame.width - ringThickness) / 2
    let detectionThickness = ringThickness * 1.5
    if (radiusToMiddleGradient - detectionThickness ... radiusToMiddleGradient + detectionThickness).contains(distance) {
      moveDragCircleFromRadius(rads)
      let color = getColorFromAngle(angle: rads)
      draggableCircle.backgroundColor = color
      externalBorderLayer.borderColor = color.withAlphaComponent(borderDraggableAlpha).cgColor
      delegate?.changeColor(color: color)
      delegate?.setColor()
      moveToSliceIndex()
    }
  }

  private func commonInit() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.isUserInteractionEnabled = true

    layer.contentsScale = UIScreen.main.scale
    layer.drawsAsynchronously = true
    layer.needsDisplayOnBoundsChange = true
    layer.setNeedsDisplay()
  }

  func setupBorderLayer() {
    borderDraggableAlpha = 0.5
    borderDraggableWidth = relativeWidth(5)

    draggableCircle.removeAllSubLayers()

    externalBorderLayer = CALayer()
    externalBorderLayer.frame = CGRect(x: -borderDraggableWidth, y: -borderDraggableWidth, width: draggableCircle.frame.size.width + 2 * borderDraggableWidth, height: draggableCircle.frame.size.height + 2 * borderDraggableWidth)
    externalBorderLayer.borderColor = draggableBackgroundColor.withAlphaComponent(borderDraggableAlpha).cgColor
    externalBorderLayer.borderWidth = borderDraggableWidth
    externalBorderLayer.cornerRadius = (draggableCircle.frame.size.width + 2 * borderDraggableWidth) / 2
    externalBorderLayer.name = "externalBorder"
    draggableCircle.layer.addSublayer(externalBorderLayer)
  }

  func setupDraggableImage() {
    var angle: CGFloat = 0
    if let index = slicedGradient.auroraPickerColors.firstIndex(where: {
      $0.hexInt == self.draggableBackgroundColor.hexInt
    }) {
      let slice = 2 * CGFloat.pi / CGFloat(slicedGradient.auroraPickerColors.count)
      angle = slice * CGFloat(index)
    }

    let currentColor = getColorFromAngle(angle: angle)
    delegate?.changeColor(color: currentColor)

    let sizeCircle = CGSize(width: dragCircleWidth, height: dragCircleWidth)
    let sizeDragArea = CGSize(width: dragCircleWidth * dragCircleMultiplicator, height: dragCircleWidth * dragCircleMultiplicator)
    draggableArea.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(detectPan)))
    draggableCircle.layer.cornerRadius = sizeCircle.width / 2
    draggableCircle.backgroundColor = draggableBackgroundColor

    draggableCircle.frame.size = sizeCircle
    draggableArea.frame.size = sizeDragArea

    let radius = (frame.size.width - self.padding * 2 - ringThickness) / 2
    let x = frame.size.width / 2 + radius * cos(angle)
    let y = frame.size.height / 2 + radius * sin(angle)

    draggableCircle.center = CGPoint(x: x, y: y)
    draggableArea.center = CGPoint(x: x, y: y)
  }

  fileprivate func moveDragCircleFromRadius(_ rads: CGFloat) {
    let radius = (slicedGradient.frame.width - ringThickness) / 2
    let x = slicedGradient.center.x + radius * cos(rads)
    let y = slicedGradient.center.y + radius * sin(rads)
    draggableCircle.center = CGPoint(x: x, y: y)
    draggableArea.center = CGPoint(x: x, y: y)
  }

  @objc
  func detectPan(recognizer: UIPanGestureRecognizer) {
    if recognizer.state == .began {
      lastLocation = draggableArea.center
    } else if recognizer.state == .changed {
      let translation = recognizer.translation(in: superview)
      draggableCircle.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
      draggableArea.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)

      let rads = atan2(draggableCircle.center.y - slicedGradient.center.y, draggableCircle.center.x - slicedGradient.center.x)
      moveDragCircleFromRadius(rads)

      let color = getColorFromAngle(angle: rads)
      draggableCircle.backgroundColor = color
      externalBorderLayer.borderColor = color.withAlphaComponent(borderDraggableAlpha).cgColor
      delegate?.changeColor(color: color)

    } else if recognizer.state == .ended {
      delegate?.setColor()
      moveToSliceIndex()
    }
  }

  func pointDistance(_ a: CGPoint, _ b: CGPoint) -> Double {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return Double(sqrt(xDist * xDist + yDist * yDist))
  }

  func moveToSliceIndex() {

    let angleRads = atan2(draggableCircle.center.y - slicedGradient.center.y, draggableCircle.center.x - slicedGradient.center.x)
    let index = getIndexFromAngle(angle: angleRads)

    let gradientRadius = (frame.size.width - self.padding * 2 - ringThickness) / 2
    let slice = 2 * CGFloat.pi / CGFloat(slicedGradient.auroraPickerColors.count)
    let angle = CGFloat(index) * slice

    let x = frame.size.width / 2 + gradientRadius * cos(angle)
    let y = frame.size.height / 2 + gradientRadius * sin(angle)

    draggableArea.isUserInteractionEnabled = false
    let distance = pointDistance(self.draggableCircle.center, CGPoint(x: x, y: y))
    UIView.animate(withDuration: distance * 0.015, animations: {
      self.draggableCircle.center = CGPoint(x: x, y: y)
      self.draggableArea.center = CGPoint(x: x, y: y)
    }, completion: { _ in
      self.draggableArea.isUserInteractionEnabled = true
    })
  }

  override func layoutSubviews() {
    setupDraggableImage()
    setupBorderLayer()
  }
}
