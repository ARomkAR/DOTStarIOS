//
//  ColorFormat.swift
//  Popsicle
//
//  Created by Omkar khedekar on 19/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import Foundation
enum ColorFormat {
    case rgb(red: Double, green: Double, blue: Double)
    case hsb(hue: Double, saturation: Double, brightness: Double)

    var asDictionery: [String: String] {
        switch self {
        case .rgb(red: let red, green: let green, blue: let blue):
            return [
                "red": "\(String(format: "%.2f", red))",
                "green": "\(String(format: "%.2f", green))",
                "blue":"\(String(format: "%.2f", blue))"
            ]

        case .hsb(hue: let hue, saturation: let saturation, brightness: let brightness):
            return [
                "hue": "\(String(format: "%.2f", hue))",
                "saturation": "\(String(format: "%.2f", saturation))",
                "brightness":"\(String(format: "%.2f", brightness))"
            ]
        }
    }

    var stringFormatted: String {
        var baseFormat: String
        switch self {
        case .rgb(_, _, _):
            baseFormat = "\"r\":<red>, \"g\":<green>, \"b\":<blue>"
        case .hsb(_, _, _):
            baseFormat = "h:<hue>, s:<saturation>, b: <brightness>"
        }

        let dict = self.asDictionery

        dict.forEach { (arg) in

            let (colorFragment, value) = arg
            baseFormat = baseFormat.replacingOccurrences(of: "<\(colorFragment)>", with: value)
        }

        return baseFormat
    }
}
