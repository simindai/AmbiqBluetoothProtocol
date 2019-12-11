//
//  Client+Central.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/23/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Client{
	
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		//print("\(#line) \(#function)")
		guard central.state  == .poweredOn else {
            // In a real app, you'd deal with all the states correctly
            return
        }
		client_scan()
	}
	
	// discover peripheral
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("Discovered \(peripheral.name) at \(RSSI)")
		//if let name = peripheral.name {
	//		log_msg.appendWithTime("Discovered \(name) at \(RSSI)")
		//}
		self.get_peripheral_advertisement(peripheral: peripheral, advertisementData: advertisementData,RSSI: RSSI)
	}
	
	// failed to connect to peripheral
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		//print("Failed to connect to \(peripheral). (\(error?.localizedDescription))")
		log_msg.appendWithTime("Failed to connect to \(peripheral). (\(error?.localizedDescription ?? ""))")
		self.cleanup()
	}
	
	// connected to peripheral sucessfully
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		//print("Peripheral Connected")
		log_msg.appendWithTime("Peripheral Connected")
		self.stopScan()
		self.m_discoveredPeripheral = peripheral
		peripheral.delegate = self
		peripheral.discoverServices(nil)
	}
	
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		//print("Peripheral disConnected")
		log_msg.appendWithTime("Peripheral disConnected")
		self.m_discoveredPeripheral = nil
		NotificationCenter.default.post(name: .didLostConnection, object: peripheral, userInfo: nil)
	}
	
	func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
		print("read rssi")
		let rssi_dictionary = ["rssi":RSSI]
		
		NotificationCenter.default.post(name: .didReadRSSI , object: peripheral, userInfo: rssi_dictionary)
	}
	
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard error == nil else {
			log_msg.appendWithTime("Error discovering services:\(error!.localizedDescription)")
			//print("Error discovering services:\(error!.localizedDescription)")
			cleanup()
			return
		}
		guard let services = peripheral.services else {return}
		//print("discover services")
		log_msg.appendWithTime("discover services)")
		for s in services{
			//print(s)
			log_msg.appendWithTime("\(s)")
		}
		NotificationCenter.default.post(name: .didDiscoverService, object: peripheral, userInfo: nil)
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
		//print("didDiscoverCharacteristics")
		log_msg.appendWithTime("didDiscoverCharacteristics")
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
			log_msg.appendWithTime("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }


        guard let characteristics = service.characteristics else {
            return
        }
		

        // Again, we loop through the array, just in case.
        for characteristic in characteristics {
			if characteristic.uuid.uuidString == Common.AMBIQ_CHARACTERISTIC_ACK.uuidString {
				//print("subscribe ambiq ack characteristic")
				log_msg.appendWithTime("subscribe ambiq ack characteristic")
				peripheral.setNotifyValue(true, for: characteristic)
				self.m_ack_characteristic = characteristic
			}
			log_msg.appendWithTime("\(characteristic)")
          // print(characteristic)
			
        }
		NotificationCenter.default.post(name: .didDiscoverCharateristic, object: service, userInfo: nil)
        // Once this is complete, we just need to wait for the data to come in.
    }
	func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
		//log_msg.appendWithTime("didModifyServices")
	}
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		//log_msg.appendWithTime("did write value")
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		//print("did update value")
		//log_msg.appendWithTime("did update value")
		guard error == nil else {
			log_msg.appendWithTime("Error discovering services: \(error!.localizedDescription)")
				   //print("Error discovering services: \(error!.localizedDescription)")
				   return
			   }
		guard characteristic.value != nil  else {
		log_msg.appendWithTime("data nil ")
		 //  print("data nil ")
		   return
	   }
		let result = self.parse_received_data(data: characteristic.value!)
		if result == Common.AMDTP_STATUS_RECEIVE_DONE, self.m_receivedDataType == Common.AMDTP_PKT_TYPE_ACK{
			let status = self.m_receiveDataUInt8[0]
			if status == Common.AMDTP_STATUS_SUCCESS{
				log_msg.appendWithTime("sucessfully ack from server")
				//print("sucessfully ack from server")
				self.m_serialNumber += 1
				if self.m_serialNumber == 16{
					self.m_serialNumber = 0
				}
				if let _ = self.m_send_test_data, let _ = self.m_send_peripheral, let rx = self.m_send_rx_characteristic{
					//self.m_count += 1
					//if self.m_count <= 5 {
				    	self.sendTestDataToServer(p: peripheral, rxCharacteristic: rx)
					//}
				}
				
			}
			self.reset_received_data()
		}
		else if result == Common.AMDTP_STATUS_RECEIVE_DONE, self.m_receivedDataType == Common.AMDTP_PKT_TYPE_DATA{
			self.reset_received_data()
			self.send_ack(peripheral: peripheral, status: Common.AMDTP_STATUS_SUCCESS)
		}

	}
	
	func client_scan(){
		self.m_centralManager?.scanForPeripherals(withServices:nil,options: [
			CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
		])
		log_msg.appendWithTime("Scanning started")
		//print("Scanning started")
	}
	
	private func send_ack(peripheral:CBPeripheral, status:UInt8){
		
		// refer original code count stored in data[1]
		let ack_packet = PacketClass( packetType: Common.AMDTP_PKT_TYPE_ACK, serialNumber: self.m_receivedSerialNumber, counter: nil, status: status, dataSize:1+Common.AMTP_PREFIX_SIZE_IN_PACKET + Common.AMDTP_CRC_SIZE_IN_PACKET)
		log_msg.appendWithTime("client write ack to server ")
		if m_ack_characteristic != nil {
		    self.writeCharacteristic(p: peripheral, characteristic:self.m_ack_characteristic! , type: .withResponse, data: ack_packet.getData())
		}
	}
	
	// advertisement content shall in table view cell  
	// don't print or log 
	private func get_peripheral_advertisement(peripheral:CBPeripheral, advertisementData: [String : Any], RSSI:NSNumber){
	//	print("Advertisement")
		//log_msg.appendWithTime("Advertisement")
		let device_name:String? = peripheral.name
		//var local_name:NSData?
		//var device_service_data:NSDictionary?
		
		let service_count  = 0
		let dbm = Int(truncating: RSSI)
		
		//if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber{
		//	print("connectable \(connectable)")
			//log_msg.appendWithTime("connectable \(connectable)")
		//}
		//if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? NSData {
			//print("data local name \(name)")
			//log_msg.appendWithTime("data local name \(name)")
			//local_name = name
		//}
		//if let service_data = advertisementData[CBAdvertisementDataServiceDataKey] as? NSDictionary{
			//print("service_data\(service_data)")
			//log_msg.appendWithTime("service_data\(service_data)")
			//device_service_data = service_data
		//}
		//if let service_id = advertisementData[CBAdvertisementDataServiceUUIDsKey]  as? [CBUUID]{
			//print("service uuid \(service_id)")
//			for id in service_id {
//				log_msg.appendWithTime("service uuid \(id.uuidString)")
//			}
		//	service_count = service_id.count
		//}
		//if let power = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber{
			//print("power \(power)")
		//	log_msg.appendWithTime("power \(power)")
		//}
		//if let manufacture_data = advertisementData[CBAdvertisementDataManufacturerDataKey] as? NSData{
			//print("manufacture data \(manufacture_data)")
			//log_msg.appendWithTime("manufacture data \(manufacture_data)")
		//}
		
		//if let overflow_service = advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey] as? NSArray {
			//print("overflow service uuid  \(overflow_service)")
			//log_msg.appendWithTime("overflow service uuid  \(overflow_service)")
		//}
		
		//if let solicit_service = advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey]as? NSArray {
			//print("solicit service uuid  \(solicit_service)")
			//log_msg.appendWithTime("solicit service uuid  \(solicit_service)")
		//}
		let _ = self.m_periheralData.addPeripheralDevice(name: device_name, dbm: dbm, serviceUUidCount: service_count,peripheral: peripheral)
	}
	
	private func parse_received_data(data:Data)->UInt8{
		let array:[UInt8] = [UInt8](data)
		var data_index = 0
		print(self.m_receiveDataOffset)
		if self.m_receiveDataOffset == 0 {
			self.m_receiveDataLength = Int(array[0]) + Int(array[1] ) << 8
			if let packet_header  = Common.getUInt16(byte: array, index: 2) {
				let packet_type = (packet_header & UInt16(Common.PACKET_TYPE_BIT_MASK)) >> Common.PACKET_TYPE_BIT_OFFSET
				let packet_serial = (packet_header & UInt16(Common.PACKET_SN_BIT_MASK)) >> Common.PACKET_SN_BIT_OFFSET
				let packet_encode = (packet_header & UInt16(Common.PACKET_ENCRYPTION_BIT_MASK)) >> Common.PACKET_ENCRYPTION_BIT_OFFSET
				let packet_ackEnabled = (packet_header & UInt16(Common.PACKET_ACK_BIT_MASK)) >> Common.PACKET_ACK_BIT_OFFSET
				//print("type = \(packet_type) sn = \(packet_serial)")
				//print("enc = \(packet_encode) ackEnabled = \(packet_ackEnabled)")
				log_msg.appendWithTime("client received type = \(packet_type) sn = \(packet_serial)")
				log_msg.appendWithTime("client received enc = \(packet_encode) ackEnabled = \(packet_ackEnabled)")
				self.m_receivedDataType = Int(packet_type)
				self.m_receivedSerialNumber = Int(packet_serial)
			}
			data_index = Common.AMTP_PREFIX_SIZE_IN_PACKET
			self.m_receiveDataUInt8 = Array(array[data_index...])
		}
		else {
			self.m_receiveDataUInt8.append(contentsOf: array)
		}
		self.m_receiveDataOffset += array.count - data_index
		if self.m_receiveDataOffset >= self.m_receiveDataLength{
			let valid_length = self.m_receiveDataUInt8.count - Common.AMDTP_CRC_SIZE_IN_PACKET
			let crc32 = CRC32.CalcCrc32(crcInit: 0xFFFFFFFF, length: valid_length, byte: Array(self.m_receiveDataUInt8[0..<valid_length]), offset:0)
			let crc32_index = valid_length
			if let valid_crc32 = Common.getUInt32(byte: self.m_receiveDataUInt8, index: crc32_index){
				if valid_crc32 == crc32 {
					return Common.AMDTP_STATUS_RECEIVE_DONE
				}
			}
			return Common.AMDTP_STATUS_CRC_ERROR
			
		}
		else { return Common.AMDTP_STATUS_RECEIVE_CONTINUE }
		
		
	}
	
	
}
