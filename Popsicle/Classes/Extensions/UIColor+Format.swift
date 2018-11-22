//
//  UIColor+Format.swift
//  Popsicle
//
//  Created by Omkar khedekar on 19/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit
extension UIColor {

    enum Format {
        case rgb
        case hsb
    }

    func represent(in format: Format) -> ColorFormat? {
        switch format {
        case .rgb:
            let coreImageColor = CIColor(color: self)
            let red = coreImageColor.red * 255
            let green = coreImageColor.green * 255
            let blue = coreImageColor.blue * 255
            return ColorFormat.rgb(red: red.native, green: green.native, blue: blue.native)
        case .hsb:
            let hsb = self.hsb
            return ColorFormat.hsb(hue: hsb.hue.native, saturation: hsb.saturation.native, brightness: hsb.brightness.native)
        }
    }
}
