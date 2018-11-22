//
//  ViewController.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var colorPickerCollectionView: UICollectionView!
    @IBOutlet private weak var brightnessLabel: UILabel!
    @IBOutlet private weak var brightnessSlider: UISlider!

    private let dataSource = ColorPickerDataSource()
    private var selectedColor: UIColor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    private func configure() {
        self.colorPickerCollectionView.register(ColorPickerCollectionViewCell.nib,
                                           forCellWithReuseIdentifier: "ColorPickerCollectionViewCell")
        self.colorPickerCollectionView.dataSource = dataSource
        self.colorPickerCollectionView.delegate = self
        self.brightnessSlider.setValue(127, animated: true)
        self.brightnessLabel.text = "Brightness: \(round(self.brightnessSlider.value))"

    }

    @IBAction private func brightnessDidChanged(_ sender: UISlider) {
        self.brightnessLabel.text = "Brightness: \(self.brightnessSlider.value)"
    }

    @IBAction private func updateButtonTapped(_ sender: Any) {
        guard let selectedColor = self.selectedColor else { return }
        let message = Message(state: true,
                              index: 0,
                              brightness: Double(round(self.brightnessSlider.value)),
                              color: selectedColor,
                              format: .rgb)
        MQTTContainer.send(message: message)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 120, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hex = ColorPalette.shared.colors[indexPath.item]
        let selectedColor = UIColor(hex: hex)
        self.selectedColor = selectedColor
        print("color \(hex)")
    }
}
