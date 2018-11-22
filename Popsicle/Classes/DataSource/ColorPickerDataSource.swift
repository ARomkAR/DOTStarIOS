//
//  ColorPickerDataSource.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit

class ColorPickerDataSource: NSObject {

    let colors = ColorPalette.shared.colors
    var numberOfItems: Int {
        return colors.count
    }


}

extension ColorPickerDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCollectionViewCell", for: indexPath)
        let colorHex = colors[indexPath.item]
        if let cell = cell as? ColorPickerCollectionViewCell {
            cell.set(color: colorHex)
        }
        cell.contentView.backgroundColor = .lightGray
        return cell
    }


}
