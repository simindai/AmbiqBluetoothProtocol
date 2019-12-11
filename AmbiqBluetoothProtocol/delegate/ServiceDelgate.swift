//
//  ServiceDelgate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/24/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
protocol  ServiceDelegate {
	
	func Connect(p:CBPeripheral)
	func Disconnect(p:CBPeripheral)
	func DisCharacteristic(p:CBPeripheral,service:CBService)
	func restoreObserver()
	func requestServerSendTestData(p:CBPeripheral, rxCharacteristic:CBCharacteristic)
	func sendTestDataToServer(p:CBPeripheral, rxCharacteristic:CBCharacteristic)
	func stopTestDataToServer()
	func stopServerSendDataToClient(p: CBPeripheral, rxCharacteristic: CBCharacteristic)

}
