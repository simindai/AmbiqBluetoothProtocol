//
//  CentralManagerDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/22/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
protocol  CentralManagerDelegate {
	func updatePeripheralTable(rowIndex:Int)
	//func launchServiceView(p:CBPeripheral)
}
