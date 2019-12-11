//
//  LogDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 12/2/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
protocol  LogDelegate {
	func launchPeripheralController()
	func lanuchClientController()
	func lanuchLogController(isBack:Bool)
}
