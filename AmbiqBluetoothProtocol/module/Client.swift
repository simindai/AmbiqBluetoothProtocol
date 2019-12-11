//
//  ViewController+Client.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/20/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import CoreBluetooth


class Client:NSObject,CBCentralManagerDelegate,CBPeripheralDelegate{
	var m_centralManager:CBCentralManager?
	var m_discoveredPeripheral:CBPeripheral?
	var m_periheralData = PeripheralData()
	var m_centralMangerDelegate:CentralManagerDelegate?
	var m_req_sever_send_data:Bool?
	var m_send_test_data:Bool?
	var m_send_rx_characteristic:CBCharacteristic?
	var m_ack_characteristic:CBCharacteristic?
	var m_send_peripheral:CBPeripheral?
	var m_count :UInt8 = 0
	var m_serialNumber:Int = 0
	var m_receiveDataOffset = 0
	var m_receiveDataUInt8:[UInt8] = []
	var m_lastRecSerialNumber:Int = 0
	var m_receivedSerialNumber:Int = 0
	var m_receiveDataLength:Int = 0
	var m_receivedDataType:Int = Common.AMDTP_PKT_TYPE_UNKNOWN
	init(cmDelegate:CentralManagerDelegate){
		super.init()
		self.m_centralMangerDelegate = cmDelegate
		
	}
	
	public func scan(){
		
		if self.m_centralManager == nil{
			let centralQueue = dispatch_queue_serial_t(label: "ble")
			self.m_centralManager = CBCentralManager(delegate: self, queue: centralQueue)
		} // need to check state
		
		client_scan()
		
	}
	public func stopScan(){
		// Stop scanning
        self.m_centralManager?.stopScan()
        //print("Scanning stopped")
		log_msg.appendWithTime("Scanning stopped")
	}
	
	public func getPeripheralData(index:Int)->(String,Int,Int){
		return self.m_periheralData.getPeripherDeviceData(index: index)
	}
	
	public func getPeripheral(index:Int)->CBPeripheral?{
		return self.m_periheralData.getPeripheral(index:index)
	}
	
	public func getPeriheralDeviceCount()->Int{
		return self.m_periheralData.getDeviceCount()
	}
	
	public func readRssi(){
		self.m_periheralData.readRssi()
	}
	
	public func updateRssi(p:CBPeripheral, rssi:NSNumber){
		self.m_periheralData.updateRssi(p: p, rssi: rssi)
	}
	public func connectPeripheral(index:Int){
		if let p = self.m_periheralData.getPeripheral(index:index){
			self.m_discoveredPeripheral = p
			self.m_centralManager?.connect(p, options: nil)
			
		}
	}
	
	public func connectPeripheral(p:CBPeripheral){
		
		self.m_discoveredPeripheral = p
		self.m_centralManager?.connect(p, options: nil)
	}
	
	func disconnect(p:CBPeripheral){
		self.m_centralManager?.cancelPeripheralConnection(p)
	}
	
	func disCharacteristic(p:CBPeripheral, service:CBService){
		p.discoverCharacteristics(nil, for: service)
	}
	
	func writeCharacteristic(p:CBPeripheral, characteristic:CBCharacteristic, type:CBCharacteristicWriteType, data:Data){
		//print ("write data to rx characteristic")
		//log_msg.appendWithTime("write data to rx characteristic")
		p.writeValue(data, for: characteristic, type: type)
	}
	func sendTestDataToServer(p:CBPeripheral, rxCharacteristic:CBCharacteristic){
		self.m_send_test_data = true
		self.m_send_peripheral = p
		self.m_send_rx_characteristic = rxCharacteristic
		let data_size = p.maximumWriteValueLength(for: .withResponse)
		// refer original code count stored in data[1]
		let count_value = (Int(self.m_count) << 8) & (0xff00)
		
		print("count_value\(count_value)")
		let packet = PacketClass(packetType: Common.AMDTP_PKT_TYPE_DATA, serialNumber: self.m_serialNumber, counter: count_value, status: nil, dataSize:data_size)
		//print("send test data to server count = \(self.m_count)")
		log_msg.appendWithTime("client send data ")
		self.writeCharacteristic(p: p, characteristic: rxCharacteristic, type: .withResponse, data: packet.getData())
	}
	
	
	func requestServerSendTestData(p:CBPeripheral, rxCharacteristic:CBCharacteristic){
		self.m_req_sever_send_data = true
		self.m_send_peripheral = p
		self.m_send_rx_characteristic = rxCharacteristic
		let data_size = 4 + Common.AMTP_PREFIX_SIZE_IN_PACKET + Common.AMDTP_CRC_SIZE_IN_PACKET
		let packet = PacketClass(packetType: Common.AMDTP_PKT_TYPE_DATA, serialNumber: self.m_serialNumber, counter: Int(Common.AMBIQ_CLEINT_COMMAND_REQUEST_SERVER_SEND), status: nil, dataSize:data_size)
		//print("send test data to server count = \(self.m_count)")
		log_msg.appendWithTime("request server send data")
		self.writeCharacteristic(p: p, characteristic: rxCharacteristic, type: .withResponse, data: packet.getData())
		//p.setNotifyValue(true, for: ackCharateristic)
		
	}
	
	
	func stopTestDataSend(){
		log_msg.appendWithTime("client stop send data to server")
		self.cleanSendTestData()
	}
	
	func stopServerSendData(p:CBPeripheral, rxCharacteristic:CBCharacteristic){
		self.m_req_sever_send_data = true
		self.m_send_peripheral = p
		self.m_send_rx_characteristic = rxCharacteristic
		let data_size = 4 + Common.AMTP_PREFIX_SIZE_IN_PACKET + Common.AMDTP_CRC_SIZE_IN_PACKET
		let packet = PacketClass(packetType: Common.AMDTP_PKT_TYPE_DATA, serialNumber: self.m_serialNumber, counter: Int(Common.AMBIQ_CLIENT_COMMAND_STOP_SERVER_SEND), status: nil, dataSize:data_size)
		log_msg.appendWithTime("client request server stop sending data\n")
		self.writeCharacteristic(p: p, characteristic: rxCharacteristic, type: .withResponse, data: packet.getData())
	}
	
	func cleanup(){
		self.m_periheralData.clean()
		clean_received_data()
		cleanSendTestData()
		guard self.m_discoveredPeripheral?.state == CBPeripheralState.connected else { return }
		// See if we are subscribed to a characteristic on the peripheral
        guard let services = m_discoveredPeripheral?.services else {
			self.disconnect(p:  self.m_discoveredPeripheral!)
            return
        }
		for service in services {
		   guard let characteristics = service.characteristics else {
			   continue
		   }
		   for characteristic in characteristics {
			if characteristic.uuid.isEqual(self.m_ack_characteristic?.uuid) && characteristic.isNotifying {
				self.m_discoveredPeripheral?.setNotifyValue(false, for: characteristic)
				   // And we're done.
				   return
			   }
		   }
		}
		
	}
	
	func cleanSendTestData(){
		clean_received_data()
		self.m_send_test_data = nil
		self.m_send_peripheral = nil
		self.m_send_rx_characteristic = nil
		self.m_serialNumber  = 0
		self.m_count = 0
	}
	
	
	func clean_received_data(){
		self.reset_received_data()
		self.m_serialNumber = 0
		self.m_lastRecSerialNumber = 0
		
	}
	func reset_received_data(){
		self.m_receiveDataOffset  = 0
		self.m_receiveDataLength = 0
		self.m_receiveDataUInt8.removeAll()
		self.m_receivedDataType = Common.AMDTP_PKT_TYPE_UNKNOWN
		
	}
	
	
	
	
	
	
	
	
}
