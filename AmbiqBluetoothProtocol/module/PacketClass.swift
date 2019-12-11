//
//  PacketClass.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/30/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class PacketClass{
	var m_dataSize:Int = 0
	var m_data:[UInt8] = []
	var m_encrypted = false
	var m_enableAck = false
	var m_packetType:Int = 0
	var m_serialNumber:Int = 0
	var m_counter:Int?
	var m_status:UInt8?
	
	init(packetType:Int, serialNumber:Int, counter:Int?, status:UInt8?, dataSize:Int){
		self.m_dataSize = dataSize
		m_data = Array(repeating: 0, count: self.m_dataSize )
		self.m_packetType = packetType
		self.m_serialNumber = serialNumber
		self.m_counter = counter
		self.m_status = status
		if self.m_packetType == Common.AMDTP_PKT_TYPE_DATA{
			if let count = counter{
				if count & 0xff == 0{
					self.m_enableAck = true
				}
			}
			self.createDataPacket()
		}
		else if self.m_packetType == Common.AMDTP_PKT_TYPE_ACK{
			self.createAckPacket()
		}
		
		//print("Max write value: \(self.m_dataSize)")
		log_msg.appendWithTime("Max write value: \(self.m_dataSize)")
	}
	
	init(data:Data){
		
		
		
		
		
	}
	
	
	
//	public static func check_data_valid(data:Data)->Bool{
//		
//		
//		
//		
//		
//	}
	
	private func createAckPacket(){
		self.createLengthAndHeader(type: Common.AMDTP_PKT_TYPE_ACK)
		if let status = self.m_status {
			self.m_data[4] = UInt8(status & 0xff)
		}
		let length = self.m_dataSize - Common.AMTP_PREFIX_SIZE_IN_PACKET  - Common.AMDTP_CRC_SIZE_IN_PACKET
		let crc_index = Common.AMTP_PREFIX_SIZE_IN_PACKET + length
		let crc = CRC32.CalcCrc32(crcInit: 0xFFFFFFFF, length: length, byte: self.m_data, offset:Common.AMTP_PREFIX_SIZE_IN_PACKET)
		self.m_data[crc_index] = UInt8(crc & 0xff)
		self.m_data[crc_index+1] = UInt8((crc >> 8) & 0xff)
		self.m_data[crc_index+2] = UInt8((crc >> 16) & 0xff)
		self.m_data[crc_index+3] = UInt8((crc>>24) & 0xff)
	}
	
	private func createDataPacket(){
		self.createLengthAndHeader(type: Common.AMDTP_PKT_TYPE_DATA)
		if let count = self.m_counter {
			self.m_data[4] = UInt8(count & 0xff)
			self.m_data[5] = UInt8((count >> 8) & 0xff)
			self.m_data[6] = UInt8((count >> 16 ) & 0xff)
			self.m_data[7] = UInt8((count >> 24) & 0xff)
		}
		let length = self.m_dataSize - Common.AMTP_PREFIX_SIZE_IN_PACKET  - Common.AMDTP_CRC_SIZE_IN_PACKET
		let crc_index = Common.AMTP_PREFIX_SIZE_IN_PACKET + length
		let crc = CRC32.CalcCrc32(crcInit: 0xFFFFFFFF, length: length, byte: self.m_data, offset:Common.AMTP_PREFIX_SIZE_IN_PACKET)
		self.m_data[crc_index] = UInt8(crc & 0xff)
		self.m_data[crc_index+1] = UInt8((crc >> 8) & 0xff)
		self.m_data[crc_index+2] = UInt8((crc >> 16) & 0xff)
		self.m_data[crc_index+3] = UInt8((crc>>24) & 0xff)
	}
	
	private func createLengthAndHeader(type:Int){
		let data_length = self.m_dataSize - Common.AMTP_PREFIX_SIZE_IN_PACKET
		self.m_data[0] = UInt8(data_length & 0xff)
		self.m_data[1] = UInt8((data_length >> 8) & 0xff )
		var header:Int = 0
		if type == Common.AMDTP_PKT_TYPE_DATA {
			header = (Common.AMDTP_PKT_TYPE_DATA << Common.PACKET_TYPE_BIT_OFFSET)
		}
		else if type == Common.AMDTP_PKT_TYPE_ACK{
			header = (Common.AMDTP_PKT_TYPE_ACK << Common.PACKET_TYPE_BIT_OFFSET)
		}
		header =  header | (self.m_serialNumber << Common.PACKET_SN_BIT_OFFSET)
		if self.m_encrypted{
			header =  header | (1 << Common.PACKET_ENCRYPTION_BIT_OFFSET)
		}
		if self.m_enableAck{
			header = header | (1 << Common.PACKET_ACK_BIT_OFFSET)
		}
		self.m_data[2] = UInt8(header & 0xff)
		self.m_data[3] = UInt8((header >> 8) & 0xff )
		
		
		
	}
	public func getData()->Data{
		return Data(self.m_data)
	}
	
}
