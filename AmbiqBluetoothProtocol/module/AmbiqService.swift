//
//  AmbiqService.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/26/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class AmbiqService{
	var m_service:[CBMutableService]  = []
	let m_advertise_uuid :[CBUUID] = [Common.ATT_UUID_DEVICE_INFO_SERVICE_UUID, Common.AMBIQ_SERVICE_UUID] // ipad or iphone has device info service, we could see two device info from the client
	var m_ack_charateristic:CBMutableCharacteristic!
	
	init(){
	    init_service()
	}
	
	public func getAdvertiseUUID()->[CBUUID]{
		return self.m_advertise_uuid
	}
	
	private func init_service(){
		let service_device_info = CBMutableService(type: Common.AMBIQ_SERVICE_DEVICE_INFO_UUID, primary: true)
		let characteristic_manufature_name = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_MANUFACTURE_NAME, properties: .read, value: Common.MANUFACTURE_NAME, permissions: .readable)
		let characteristic_system_id = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_SYSTEM_ID, properties: .read, value: Common.SYSTEM_ID, permissions: .readable)
		let characteristic_model_number = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_MODEL_NUMBER, properties: .read, value: Common.MODAL_NUMBER, permissions: .readable)
		let characteristic_serial_number = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_SERIAL_NUMBER, properties: .read, value: Common.SERIAL_NUMBER, permissions: .readable)
		let characteristic_firmware_revision = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_FIRMEARE_REVISION, properties: .read, value: Common.FIRMWARE_REVISION, permissions: .readable)
		let characteristic_hardware_revision = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_HARDWARE_REVISION, properties: .read, value: Common.HARDWARE_REVISION, permissions: .readable)
		let characteristic_software_revision = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_SOFTWARE_REVISION, properties: .read, value: Common.SOFTWARE_REVISION, permissions: .readable)
		let characteristic_11073_cert_data = CBMutableCharacteristic(type: Common.ATT_UUID_CHARACTERISTIC_11073_CERT_DATA, properties: .read, value: Common.IEEE_11073_CERT_DATA, permissions: .readable)
		service_device_info.characteristics = [characteristic_manufature_name,characteristic_system_id,characteristic_model_number,characteristic_serial_number,
											   characteristic_firmware_revision,characteristic_hardware_revision,characteristic_software_revision,characteristic_11073_cert_data]
		//service_device_info.characteristics = [characteristic_manufature_name]
		self.m_service.append(service_device_info)
		
		// original code initialize client confiuguation 0x20=> cccset
		// bluetooth document 0x01 (used) all other bits reserved.
		let service_ambiq = CBMutableService(type: Common.AMBIQ_SERVICE_UUID, primary: true)
		let characteristic_rx = CBMutableCharacteristic(type: Common.AMBIQ_CHARACTERISTIC_RX, properties: .write, value: nil, permissions: .writeable)
		let characteristic_tx = CBMutableCharacteristic(type: Common.AMBIQ_CHARACTERISTIC_TX, properties: [.notify], value: nil, permissions:.readable)
		//let characteristic_tx_client_configuration = CBMutableCharacteristic(type: Common.ATT_UUID_CLIENT_CHARACTERISTIC_CONFIGURATION, properties: [CBCharacteristicProperties.read,CBCharacteristicProperties.write],
//																			 value: nil, permissions:[CBAttributePermissions.readable,CBAttributePermissions.writeable])
		let characteristic_ack = CBMutableCharacteristic(type: Common.AMBIQ_CHARACTERISTIC_ACK, properties: [.write,.notify], value: nil, permissions: [.writeable, .readable])
//		let characteristic_ack_client_configuaration = CBMutableCharacteristic(type: Common.ATT_UUID_CLIENT_CHARACTERISTIC_CONFIGURATION, properties: [CBCharacteristicProperties.read,CBCharacteristicProperties.write],
//																			   value: nil, permissions:[CBAttributePermissions.readable,CBAttributePermissions.writeable])
//		service_ambiq.characteristics = [characteristic_rx,characteristic_tx, characteristic_tx_client_configuration, characteristic_ack,characteristic_ack_client_configuaration]
		service_ambiq.characteristics = [characteristic_rx,characteristic_tx, characteristic_ack]
		self.m_service.append(service_ambiq)
		self.m_ack_charateristic = characteristic_ack
	}
	
	public func getService()->[CBMutableService]{
		return self.m_service
	}
	
	public func getAckCharacteristic()->CBMutableCharacteristic?{
		return self.m_ack_charateristic
	}
	public func getServiceStr(index:Int)->(String,String){
		if index >= self.m_service.count{
			return ("","")
		}
		let service = self.m_service[index]
		var service_str = "Custom Service"
		if let service_name = Common.getUUIDName(uuid: service.uuid){
			service_str = service_name
		}
		service_str.append("\n\(service.uuid.uuidString)")
		var characteristic_str = ""
		if let characteristics = service.characteristics{
			characteristic_str = "Characteristics:\n"
			for characteristic in characteristics{
				var characteristic_name = "Custom Characteristic"
				if let str_name = Common.getUUIDName(uuid: characteristic.uuid){
					characteristic_name = str_name
				}
				characteristic_str.append(characteristic_name)
				characteristic_str.append("\nuuid:\(characteristic.uuid.uuidString)\n")
				let property_name = Common.getCharacteristicPropertyStr(Characteristic: characteristic)
				characteristic_str.append("\(property_name)\n")
			}
		}
		return (service_str, characteristic_str)
	}
}
