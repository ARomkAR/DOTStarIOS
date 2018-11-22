//
//  AppDelegate.swift
//  Popsicle
//
//  Created by Omkar khedekar on 15/10/17.
//  Copyright © 2017 HadHud. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        MQTTContainer.start { (status) in

            print(status ? "Started":"Failed")
        }

        return true
    }
}

