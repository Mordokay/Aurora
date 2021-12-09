//
//  SlicedGradientView.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import UIKit

class SlicedGradientView: UIView {

  var thickness: CGFloat!
  let auroraPickerColors: [UIColor] = [.aurora_color_picker_1, .aurora_color_picker_2, .aurora_color_picker_3, .aurora_color_picker_4, .aurora_color_picker_5,
                               .aurora_color_picker_6, .aurora_color_picker_7, .aurora_color_picker_8, .aurora_color_picker_9, .aurora_color_picker_10,
                               .aurora_color_picker_11, .aurora_color_picker_12, .aurora_color_picker_13, .aurora_color_picker_14, .aurora_color_picker_15,
                               .aurora_color_picker_16, .aurora_color_picker_17, .aurora_color_picker_18, .aurora_color_picker_19, .aurora_color_picker_20]

  override init(frame: CGRect) {
    super.init(frame: frame)
    thickness = relativeWidth(20)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    drawGradient(auroraPickerColors,
                 at: CGPoint(x: rect.width / 2, y: rect.height / 2),
                 radius: min(rect.width / 2, rect.height / 2) - thickness / 2,
                 thickness: thickness)
  }

  fileprivate func drawGradient(_ slices: [UIColor],
                                at center: CGPoint,
                                radius: CGFloat,
                                thickness: CGFloat) {
    let totalValues = CGFloat(slices.count)
    let slice = CGFloat(Double.pi) * 2 / totalValues
    var angle: CGFloat = -slice / 2
    for color in slices {
      let path = UIBezierPath()
      let sliceAngle = CGFloat(Double.pi) * 2 / totalValues
      //Small space between slices ... adding a multiplier
      let adjustedAngle = sliceAngle * 1.01
      path.lineWidth = thickness
      color.setStroke()
      path.addArc( withCenter: center,
                   radius: radius,
                   startAngle: angle + adjustedAngle,
                   endAngle: angle,
                   clockwise: false)
      path.stroke()
      angle += sliceAngle
    }
  }
}
