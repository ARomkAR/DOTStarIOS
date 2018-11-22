//
//  UIColor+OKHSB.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit

struct HSB {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
}
extension UIColor {

    var hsb: HSB {
        let coreImageColor = CIColor(color: self)
        let red = coreImageColor.red
        let green = coreImageColor.green
        let blue = coreImageColor.blue

        var minVal: CGFloat
        var maxVal: CGFloat
        var delta: CGFloat

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0

        minVal = min(red, green)
        minVal = min(minVal, blue)

        maxVal = max(red, green)
        maxVal = max(maxVal, blue)

        delta = maxVal - minVal
        brightness = maxVal

        if delta < 0.0001 {
            return HSB(hue: 0, saturation: 0, brightness: maxVal)
        }

        if maxVal > 0.0 {
            saturation = (delta / maxVal)
        } else {
            saturation = 0.0
            hue = 0
            return HSB(hue: hue, saturation: saturation, brightness: brightness)
        }

        if red >= maxVal {
            hue = (green - blue) / delta
        } else {
            if green >= maxVal {
                hue = 2.0 + ( blue - red ) / delta
            } else {
                hue = 4.0 + ( red - green ) / delta
            }
        }
        hue = hue * 60.0

        if hue < 0.0 {
            hue = hue + 360.0
        }
        return HSB(hue: hue, saturation: saturation, brightness: brightness)
    }
}
