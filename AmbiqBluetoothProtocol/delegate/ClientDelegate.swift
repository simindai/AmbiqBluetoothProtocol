//
//  peripheralDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/20/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
protocol  ClientlDelegate {
	func scan()
	func stopScan()
	func resume()
}
