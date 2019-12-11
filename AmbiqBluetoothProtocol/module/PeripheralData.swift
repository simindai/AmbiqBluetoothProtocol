//
//  PeripheralData.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/21/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import CoreBluetooth
class PeripheralData{
	
	var m_peripheralData:[PeripheralDevice] = []
	
	
	init(){
		
	}
	
	func addPeripheralDevice(name:String?, dbm:Int, serviceUUidCount:Int, peripheral:CBPeripheral)->Int{
		
		for(i, p_data) in self.m_peripheralData.enumerated(){
			if p_data.getPeripheral() == peripheral{
				p_data.update(name: name, dbmValue: dbm, serviceCount: serviceUUidCount)
		        return i
			}
		}
		let device = PeripheralDevice(name: name, dbmValue: dbm, serviceCount: serviceUUidCount, peripheral: peripheral)
		self.m_peripheralData.append(device)
		return self.m_peripheralData.count - 1
	}
	
	public func getPeripherDeviceData(index:Int)->(String, Int, Int){
		if index < self.m_peripheralData.count{
			let device = self.m_peripheralData[index]
			return (device.getDeviceData())
		}
		return ("error", 0 , 0 )
	}
	
	public func getPeripheral(index:Int)->CBPeripheral?{
		if index < self.m_peripheralData.count{
			let device = self.m_peripheralData[index]
			return (device.getPeripheral())
		}
		return nil
	}
	
	public func getDeviceCount()->Int{
		return self.m_peripheralData.count
	}
	
	public func readRssi(){
		for p in self.m_peripheralData{
			p.getPeripheral().readRSSI()
		}
	}
	
	public func updateRssi(p:CBPeripheral, rssi:NSNumber){
		for device in self.m_peripheralData{
			if device.getPeripheral() == p{
				device.updateDbm(dbmValue: Int(truncating: rssi))
			}
		}
		
	}
	func clean(){
		self.m_peripheralData.removeAll()
	}
	
	
	
	
	
}
