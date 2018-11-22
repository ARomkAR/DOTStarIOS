//
//  UIView+Nib.swift
//  WitBot
//
//  Created by Omkar khedekar on 02/05/17.
//  Copyright © 2017 UnitedByHCL. All rights reserved.
//

import UIKit

extension UIView {

	static var nib: UINib {
		let name = String(describing: self.classForCoder())
		let nib = UINib(nibName: name, bundle: nil)
		return nib
	}
}
