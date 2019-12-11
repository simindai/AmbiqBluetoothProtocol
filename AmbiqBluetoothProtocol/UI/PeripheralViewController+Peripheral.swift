//
//  PeripheralViewController+Peripheral.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/27/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
extension PeripheralViewController{

	/** Required protocol method.  A full app should take care of all the possible states,
    *  but we're just waiting for  to know when the CBPeripheralManager is ready
    */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if (peripheral.state != .poweredOn) {
				return
			}

			// We're in CBPeripheralManagerStatePoweredOn state...
		    log_msg.appendWithTime("self.peripheralManager powered on.")
			//print("self.peripheralManager powered on.")
		    let services = self.m_ambiqService.getService()
		    for service in services {
		        self.m_peripheralManager?.add(service)
		    }
		    //self.startAdvertise()
			// ... so build our service.
			
			// Start with the CBMutableCharacteristic
	//        m_transferCharacteristic = CBMutableCharacteristic(
	//            type: transferCharacteristicUUID,
	//            properties: CBCharacteristicProperties.notify,
	//            value: nil,
	//            permissions: CBAttributePermissions.readable
	//        )
	//
	//        // Then the service
	//        let transferService = CBMutableService(
	//            type: transferServiceUUID,
	//            primary: true
	//        )
	//
	//        // Add the characteristic to the service
	//        transferService.characteristics = [transferCharacteristic!]
	//
	//        // And add it to the peripheral manager
	//        m_peripheralManager!.add(transferService)
		}
	
	func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
		   if (error == nil) {
			   log_msg.appendWithTime("Start advertisement")
			   //print("Start advertisement")
		   } else {
			   log_msg.appendWithTime("Failed to start advertisement \( error!.localizedDescription)")
			   print( "Failed to start advertisement \( error!.localizedDescription)")
		   }
	   }
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
		//print("did add service \(service.uuid)")
		log_msg.appendWithTime("did add service \(service.uuid)")
		if service.uuid.uuidString == Common.AMBIQ_SERVICE_DEVICE_INFO_UUID.uuidString{
			self.m_deviceInfo_add = true
		}
		else if service.uuid.uuidString == Common.AMBIQ_SERVICE_UUID.uuidString{
			self.m_ambiq_add = true
		}
		if self.m_ambiq_add == true, self.m_deviceInfo_add == true {
		    self.startAdvertise()
		}
	}
	
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
		//print("did receive write")
		log_msg.appendWithTime("did receive write")
		for request in requests{
			if let value = request.value{
				let (status, data_value)  = parse_data(data: value)
				print("value: \(value)")
				// client send test data
				if status == Common.AMDTP_STATUS_RECEIVE_DONE, self.m_receivedDataType == Common.AMDTP_PKT_TYPE_DATA, data_value == 0{
					self.m_lastRecSerialNumber = self.m_receivedSerialNumber
					reset_received_packet()
					sendAckNotification(status: Common.AMDTP_STATUS_SUCCESS, data: nil,len:0)
				}
				else if status == Common.AMDTP_STATUS_RECEIVE_DONE,self.m_receivedDataType == Common.AMDTP_PKT_TYPE_DATA, data_value == Common.AMBIQ_CLEINT_COMMAND_REQUEST_SERVER_SEND{
					reset_received_packet()
					self.sendTestData()
					self.m_sendDataToClient = true
				}
				else if status == Common.AMDTP_STATUS_RECEIVE_DONE,self.m_receivedDataType == Common.AMDTP_PKT_TYPE_DATA, data_value == Common.AMBIQ_CLIENT_COMMAND_STOP_SERVER_SEND{
					reset_received_packet()
					self.clean_send_test_data()
					
				}
					
				else if status == Common.AMDTP_STATUS_RECEIVE_DONE,self.m_receivedDataType == Common.AMDTP_PKT_TYPE_ACK, data_value == Common.AMDTP_STATUS_SUCCESS{
				   reset_received_packet()
					self.m_sendSerialNumber += 1
				   if self.m_sendSerialNumber == 16{
					   self.m_sendSerialNumber = 0
				   }
					if self.m_sendDataToClient == true {
					    self.sendTestData()
					}
				}
				
			}
			self.m_peripheralManager?.respond(to: request, withResult: .success)
		}
	}
	
	
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
		//self.m_peripheralManager?.stopAdvertising()
		self.m_peripheralManager?.setDesiredConnectionLatency(.low, for: central)
		self.m_maimumDataSize = central.maximumUpdateValueLength
	}
	
	private func sendTestData(){
		log_msg.appendWithTime("sever send test data")
		self.m_sendCount += 1 // need to track if it is greater than 255, may crash
		if self.m_sendCount == 255{
			self.m_sendCount = 0
		}
		let count_value = (Int(self.m_sendCount) << 8) & (0xff00)
		//print("count_value\(count_value)")
		let data_packet = PacketClass(packetType: Common.AMDTP_PKT_TYPE_DATA, serialNumber: self.m_sendSerialNumber, counter: count_value, status: nil, dataSize:self.m_maimumDataSize)
		let packet_data = data_packet.getData()
		if let ack_charateristic = self.m_ambiqService.getAckCharacteristic() {
		//	print("ack updateValue")
			log_msg.appendWithTime("server send packet data")
		    self.m_peripheralManager?.updateValue(packet_data, for: ack_charateristic, onSubscribedCentrals: nil)
		}
		
		
	}
	private func sendAckNotification(status:UInt8, data:[UInt8]?, len:Int){
		//print("sendAckNotification")
		log_msg.appendWithTime("server sendAckNotification")
		let ack_packet = PacketClass( packetType: Common.AMDTP_PKT_TYPE_ACK, serialNumber: self.m_receivedSerialNumber, counter: nil, status: status, dataSize:1+Common.AMTP_PREFIX_SIZE_IN_PACKET + Common.AMDTP_CRC_SIZE_IN_PACKET)
		let ack_data = ack_packet.getData()
		if let ack_charateristic = self.m_ambiqService.getAckCharacteristic() {
		//	print("ack updateValue")
			log_msg.appendWithTime("server ack updateValue")
		    self.m_peripheralManager?.updateValue(ack_data, for: ack_charateristic, onSubscribedCentrals: nil)
		}
		
		
		
		
	}
	
	
	// refer original code
	// 1. store data without head, length
	// 2. update offset, if offset >= length Done -- (??? if data after crc32 valid, we will not catch second packet?)
	private func parse_data(data:Data)->(UInt8, UInt8?){
		let array:[UInt8] = [UInt8](data)
		var data_index = 0

		// need to check length < prefixed size
		if self.m_receiveDataOffset == 0 {
			self.m_receiveDataLength = Int(array[0]) + Int(array[1] ) << 8
			if let packet_header  = Common.getUInt16(byte: array, index: 2) {
				let packet_type = (packet_header & UInt16(Common.PACKET_TYPE_BIT_MASK)) >> Common.PACKET_TYPE_BIT_OFFSET
				let packet_serial = (packet_header & UInt16(Common.PACKET_SN_BIT_MASK)) >> Common.PACKET_SN_BIT_OFFSET
				let packet_encode = (packet_header & UInt16(Common.PACKET_ENCRYPTION_BIT_MASK)) >> Common.PACKET_ENCRYPTION_BIT_OFFSET
				let packet_ackEnabled = (packet_header & UInt16(Common.PACKET_ACK_BIT_MASK)) >> Common.PACKET_ACK_BIT_OFFSET
				self.m_receivedDataType = Int(packet_type)
				//print("type = \(packet_type) sn = \(packet_serial)")
				//print("enc = \(packet_encode) ackEnabled = \(packet_ackEnabled)")
				log_msg.appendWithTime("server received type = \(packet_type) sn = \(packet_serial)")
				log_msg.appendWithTime("server received enc = \(packet_encode) ackEnabled = \(packet_ackEnabled)")
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
					return (Common.AMDTP_STATUS_RECEIVE_DONE,array[Common.AMTP_PREFIX_SIZE_IN_PACKET])
				}
			}
			return (Common.AMDTP_STATUS_CRC_ERROR, nil)
			
		}
		else { return (Common.AMDTP_STATUS_RECEIVE_CONTINUE,nil) }
		
	}
	
	private func reset_received_packet(){
		self.m_receiveDataOffset = 0
		self.m_receiveDataLength = 0
		self.m_receiveDataUInt8.removeAll()
		self.m_receivedDataType = Common.AMDTP_PKT_TYPE_UNKNOWN
	}
	
	private func clean_send_test_data(){
		self.m_sendSerialNumber = 0
		self.m_sendCount = 0
		self.m_sendDataToClient = false
	}

}
