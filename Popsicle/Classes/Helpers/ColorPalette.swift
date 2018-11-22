//
//  ColorPaletteProvider.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import Foundation

final class ColorPalette {

    static let shared = ColorPalette()
    private(set) var colors: [String]

    private init () {
        colors = []
        loadPalette()
    }
    private func loadPalette() {

        guard
            let paletteFilePath = Bundle.main.url(forResource: "2500", withExtension: "plist")
        else { return }

        do {
            let paletteData = try Data(contentsOf: paletteFilePath)
            let decoder = PropertyListDecoder()
            colors = try decoder.decode(Array<String>.self, from: paletteData)
            dump(colors)
        } catch let error {
            dump(error)
        }
    }
}
