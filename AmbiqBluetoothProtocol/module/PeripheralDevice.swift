//
//  PeriperalDevice.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/21/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralDevice:Equatable{
	var m_device_name = "unknown"
	var m_dbm:Int = 128
	var m_service_count = 0
	var m_peripheral:CBPeripheral!
	var m_update = false
	init(name:String?, dbmValue:Int, serviceCount:Int, peripheral:CBPeripheral){
		self.update(name: name, dbmValue: dbmValue, serviceCount: serviceCount)
		self.m_peripheral = peripheral
	}
	public static func ==(lhs: PeripheralDevice, rhs: PeripheralDevice) -> Bool { return lhs === rhs }
	func getDeviceData()->(String,Int,Int){
		return (self.m_device_name, self.m_dbm,self.m_service_count)
	}
	func update(name:String?, dbmValue:Int, serviceCount:Int){
		if let device_name = name{
			self.m_device_name = device_name
		}
		self.m_dbm = dbmValue
		self.m_service_count = serviceCount
		self.m_update = true
	}
	
	func updateDbm(dbmValue:Int){
		// (58,46) has a high frequency need to track to see if there are any relation
		if self.m_dbm == 58 {
			log_msg.append("prev: \(self.m_dbm), current:\(dbmValue)")
		}
		self.m_dbm = dbmValue
		
	}
	func getPeripheral()->CBPeripheral{
		return self.m_peripheral
	}
	
	func getUpdate()->Bool{
		return self.m_update
	}
	func setDbmZero(){
		self.m_dbm = 0
	}
	
}
