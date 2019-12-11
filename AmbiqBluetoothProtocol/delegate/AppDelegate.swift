//
//  AppDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/18/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window:UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		if #available(iOS 13.0, *) {} else {
			window = UIWindow(frame:UIScreen.main.bounds)
			let viewController = ViewController()
			window?.rootViewController = viewController
			window?.makeKeyAndVisible()
		}
		return true
	}

	// MARK: UISceneSession Lifecycle




}

