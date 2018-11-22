//
//  ColorPickerCollectionViewCell.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit
import Hue

class ColorPickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var colorName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorName.backgroundColor = .clear
        type(of: self).setupHexagon(for: self.colorView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        type(of: self).setupHexagon(for: self.colorView, fillColor: self.colorView.backgroundColor ?? .white)
    }

    func set(color hex: String) {
        let color = UIColor(hex: hex)
        self.colorView.backgroundColor = color
        type(of: self).setupHexagon(for: self.colorView, fillColor: color)
    }

    private static func roundedPolygonPath(_ rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
        -> UIBezierPath {
            let path = UIBezierPath()

            let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides) // How much to turn at every corner
            
            let width = min(rect.size.width, rect.size.height)        // Width of the square

            let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)

            // Radius of the circle that encircles the polygon
            // Notice that the radius is adjusted for the corners, that way the largest outer
            // dimension of the resulting shape is always exactly the width - linewidth
            let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

            // Start drawing at a point, which by default is at the right hand edge
            // but can be offset
            var angle = CGFloat(rotationOffset)

            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let mp = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            path.move(to: mp)

            for _ in 0 ..< sides {
                angle += theta

                let cornerX: CGFloat = (center.x + (radius - cornerRadius) * cos(angle))
                let cornerY: CGFloat = (center.y + (radius - cornerRadius) * sin(angle))
                let corner = CGPoint(x: cornerX, y: cornerY)
                let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

                path.addLine(to: start)
                path.addQuadCurve(to: end, controlPoint: tip)
            }

            path.close()

            // Move the path to the correct origins
            let bounds = path.bounds
            let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                              y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
            path.apply(transform)

            return path
    }

    private static func setupHexagon(for view: UIView, fillColor: UIColor = .white, strokeColor: UIColor = .clear) {
        let lineWidth: CGFloat = 0
        let path = roundedPolygonPath(view.bounds,
                                      lineWidth: lineWidth,
                                      sides: 6,
                                      cornerRadius: 8,
                                      rotationOffset: CGFloat(Double.pi / 2.0))

        let mask: CAShapeLayer
        if let existingMask = view.layer.mask as? CAShapeLayer {
            mask = existingMask
        } else {
            mask = CAShapeLayer()
            view.layer.mask = mask
        }
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = strokeColor.cgColor
        mask.fillColor = fillColor.cgColor

        let border: CAShapeLayer
        if let existingBorder = view.layer.mask as? CAShapeLayer {
            border = existingBorder

        } else {
            border = CAShapeLayer()
            view.layer.addSublayer(border)
        }
        border.path = path.cgPath
        border.lineWidth = lineWidth
        border.strokeColor = strokeColor.cgColor
        border.fillColor = fillColor.cgColor
    }
}
