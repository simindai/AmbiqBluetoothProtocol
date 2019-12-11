//
//  ViewController+ServiceDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/24/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
extension ViewController{
	func Connect(p:CBPeripheral){
		self.m_client.connectPeripheral(p:p)
	}
	
	func Disconnect(p:CBPeripheral){
		self.m_client.disconnect(p: p)
	}
	
	func restoreObserver(){
		self.resume()
	}
	
	func DisCharacteristic(p:CBPeripheral,  service: CBService) {
		self.m_client.disCharacteristic(p: p, service: service)
	}

	func requestServerSendTestData(p: CBPeripheral, rxCharacteristic: CBCharacteristic) {
		self.m_client.requestServerSendTestData(p: p, rxCharacteristic: rxCharacteristic)
	}
	
	func sendTestDataToServer(p: CBPeripheral, rxCharacteristic: CBCharacteristic) {
		self.m_client.sendTestDataToServer(p: p, rxCharacteristic: rxCharacteristic)
	}
	
	func stopTestDataToServer() {
		self.m_client.stopTestDataSend()
	}
	
	func stopServerSendDataToClient(p: CBPeripheral, rxCharacteristic: CBCharacteristic){
		self.m_client.stopServerSendData(p: p, rxCharacteristic: rxCharacteristic)
	}
	
	
	




}
