//
//  common.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/18/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class Common
{
   struct deviceConstants
   {
	   //UI constants
	   static let iPhone4_HEIGHT = 480
	   static let iPhone5_HEIGHT = 568
	   static let iPhoneSE_HEIGHT = 568
	   static let iPhone6_HEIGHT = 667
	   static let iPhone7_HEIGHT = 667
	   static let iPhone6P_HEIGHT = 736
	   static let iPhone7P_HEIGHT = 736
	   static let iPhoneXr_HEIGHT = 896
	   static let iPhoneXs_HEIGHT = 812
	   static let iPhoneXsMAX_HEIGHT = 896
	   
	   static let iPADMini_WIDTH = 1024
	   static let iPADPRO_WIDTH = 1112
	   
	   static let screenWidth = UIScreen.main.bounds.size.width
	   static let screenHeight = UIScreen.main.bounds.size.height
   }
	
	struct signalConstants{
		static let LEVEL_5:Int = -30
		static let LEVEL_4 :Int = -67
		static let LEVEL_3 :Int = -70
		static let LEVEL_2 :Int = -80
		static let LEVEL_1:Int = -90
	}
   
	struct bleConnectionConstants{
		static let connected:Int = 0
		static let disconnected :Int = 1
	}
	public static let SYSTEM_ID_BYTE:[UInt8] = [0x01,0x02,0x03,0x04,0x05,0x5F,0x00,0x00]
	public static let IEEE_11073_CERT_BYTE:[UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00 ]
	public static let SET_CCC_BYTE :[UInt8] = [0x01]
	
	public static let ATT_UUID_DEVICE_INFO_SERVICE_UUID : CBUUID = CBUUID(string: "180A")
	public static let AMBIQ_SERVICE_UUID:CBUUID = CBUUID(string: "00002760-08C2-11E1-9073-0E8AC72E1011")
	public static let AMBIQ_SERVICE_DEVICE_INFO_UUID:CBUUID = CBUUID(string: "00002760-08C2-11E1-9073-0E8AC72E1000")
	public static let ATT_UUID_CLIENT_CHARACTERISTIC_CONFIGURATION: CBUUID = CBUUID(string: "2902")
	public static let ATT_UUID_CHARACTERISTIC_MANUFACTURE_NAME:CBUUID = CBUUID(string:"2A29")
	public static let ATT_UUID_CHARACTERISTIC_SYSTEM_ID:CBUUID = CBUUID(string:"2A23")
	public static let ATT_UUID_CHARACTERISTIC_MODEL_NUMBER:CBUUID = CBUUID(string:"2A24")
	public static let ATT_UUID_CHARACTERISTIC_SERIAL_NUMBER:CBUUID = CBUUID(string:"2A25")
	public static let ATT_UUID_CHARACTERISTIC_FIRMEARE_REVISION:CBUUID = CBUUID(string:"2A26")
	public static let ATT_UUID_CHARACTERISTIC_HARDWARE_REVISION:CBUUID = CBUUID(string:"2A27")
	public static let ATT_UUID_CHARACTERISTIC_SOFTWARE_REVISION:CBUUID = CBUUID(string:"2A28")
	public static let ATT_UUID_CHARACTERISTIC_11073_CERT_DATA:CBUUID = CBUUID(string:"2A2A")
	
	public static let AMBIQ_CHARACTERISTIC_RX:CBUUID = CBUUID(string: "00002760-08C2-11E1-9073-0E8AC72E0011")
	public static let AMBIQ_CHARACTERISTIC_TX:CBUUID = CBUUID(string: "00002760-08C2-11E1-9073-0E8AC72E0012")
	public static let AMBIQ_CHARACTERISTIC_ACK:CBUUID = CBUUID(string: "00002760-08C2-11E1-9073-0E8AC72E0013")
	
	public static let AMBIQ_CLEINT_COMMAND_REQUEST_SERVER_SEND:UInt8 = 1
	public static let AMBIQ_CLIENT_COMMAND_STOP_SERVER_SEND:UInt8 = 2
	
	
	// as a demo project, device infomration should be in compliance with Ambiq blue3 EVB
	// here the code converted from svc_dis.c
	public static let MANUFACTURE_NAME:Data? = "Arm. Ltd.".data(using: .utf8)
	public static let SYSTEM_ID:Data? = Data(SYSTEM_ID_BYTE)
	public static let MODAL_NUMBER:Data? = "Cordio model num".data(using: .utf8)
	public static let SERIAL_NUMBER:Data? = "Cordio serial num".data(using: .utf8)
	public static let FIRMWARE_REVISION:Data? = "Cordio fw rev".data(using: .utf8)
	public static let HARDWARE_REVISION:Data? = "Cordio hw rev".data(using: .utf8)
	public static let SOFTWARE_REVISION:Data? = "Cordio sw rev".data(using: .utf8)
	public static let IEEE_11073_CERT_DATA:Data? = Data(IEEE_11073_CERT_BYTE)
	public static let CCC_SET:Data? = Data(SET_CCC_BYTE)
	
	public static let AMDTP_PKT_TYPE_UNKNOWN:Int = 0
	public static let AMDTP_PKT_TYPE_DATA:Int = 1
	public static let AMDTP_PKT_TYPE_ACK:Int = 2
	public static let AMDTP_PKT_TYPE_CONTROL:Int = 3
	public static let AMDTP_PKT_TYPE_MAX :Int = 4
	
	public static let AMDTP_STATUS_SUCCESS :UInt8 = 0
	public static let AMDTP_STATUS_CRC_ERROR:UInt8 = 1
	public static let AMDTP_STATUS_INVALID_METADATA_INFO:UInt8 = 2
	public static let AMDTP_STATUS_INVALID_PKT_LENGTH :UInt8 = 3
	public static let AMDTP_STATUS_INSUFFICIENT_BUFFER:UInt8 = 4
	public static let AMDTP_STATUS_UNKNOWN_ERROR:UInt8 = 5
	public static let AMDTP_STATUS_BUSY :UInt8 = 6
	public static let AMDTP_STATUS_NOTIFY_DISABLED :UInt8 = 7
	public static let AMDTP_STATUS_TX_NOT_READY :UInt8 = 8
	public static let AMDTP_STATUS_RESEND_REPLY :UInt8 = 9
	public static let AMDTP_STATUS_RECEIVE_CONTINUE :UInt8 = 10
	public static let AMDTP_STATUS_RECEIVE_DONE :UInt8 = 11
	public static let AMDTP_STATUS_MAX:UInt8 = 12
	
	public static let AMDTP_LENGTH_SIZE_IN_PACKET :Int = 2
	public static let AMDTP_HEAD_SIZE_IN_PACKET :Int  = 2
	public static let AMDTP_CRC_SIZE_IN_PACKET:Int = 4
	public static let AMTP_PREFIX_SIZE_IN_PACKET :Int = AMDTP_LENGTH_SIZE_IN_PACKET + AMDTP_HEAD_SIZE_IN_PACKET
	
	public static let PACKET_TYPE_BIT_OFFSET :Int = 12
	public static let PACKET_TYPE_BIT_MASK :Int = (0xF << PACKET_TYPE_BIT_OFFSET)
	public static let PACKET_SN_BIT_OFFSET :Int = 8
	public static let PACKET_SN_BIT_MASK :Int = (0xF << PACKET_SN_BIT_OFFSET)
	public static let PACKET_ENCRYPTION_BIT_OFFSET :Int = 7
	public static let PACKET_ENCRYPTION_BIT_MASK :Int = (0x1 << PACKET_ENCRYPTION_BIT_OFFSET)
	public static let PACKET_ACK_BIT_OFFSET :Int = 6
	public static let PACKET_ACK_BIT_MASK :Int = (0x1 << PACKET_ACK_BIT_OFFSET)
	
	
	public static let CONNECTED = 1
	public static let DISCONNECTED = 0
	
	
	
	
	// A dictionary of known service names and type (keyed by service uuid)
	// https://github.com/currantlabs/ble/blob/master/uuid.go
	//https://www.bluetooth.com/specifications/gatt/services/
	public static var KNOWN_UUID :[String:String] =  [
		"00002760-08c2-11e1-9073-0e8ac72e1011": "Ambiq Service",
		"00002760-08c2-11e1-9073-0e8ac72e1000": "Ambiq Device Info  ",
		"00002760-08c2-11e1-9073-0e8ac72e0011": "Ambiq RX",
		"00002760-08c2-11e1-9073-0e8ac72e0012": "Ambiq TX",
		"00002760-08c2-11e1-9073-0e8ac72e0013": "Ambiq ACK",
		"1800": "Generic Access Service",
		"1801": "Generic Attribute Service",
		"1802": "Immediate Alert Service",
		"1803": "Link Loss Service",
		"1804": "Tx Power Service",
		"1805": "Current Time Service",
		"1806": "Reference Time Update Service",
		"1807": "Next DST Change Service",
		"1808": "Glucose Service",
		"1809": "Health Thermometer Service",
		"180a": "Device Information Service",
		"180d": "Heart Rate Service",
		"180e": "Phone Alert Status Service",
		"180f": "Battery Service",
		"1810": "Blood Pressure Service",
		"1811": "Alert Notification Service",
		"1812": "Human Interface Device Service",
		"1813": "Scan Parameters Service",
		"1814": "Running Speed and Cadence Service",
		"1815": "Cycling Speed and Cadence Service",

//		// A dictionary of known descriptor names and type (keyed by attribute uuid)
		"2800": "Primary Service",
		"2801": "Secondary Service",
		"2802": "Include",
		"2803": "Characteristic",
//
//		// A dictionary of known descriptor names and type (keyed by descriptor uuid)
		"2900": "Characteristic Extended Properties",
		"2901": "Characteristic User Description",
		"2902": "Client Characteristic Configuration",
		"2903": "Server Characteristic Configuration",
		"2904": "Characteristic Presentation Format",
		"2905": "Characteristic Aggregate Format",
		"2906": "Valid Range",
		"2907": "External Report Reference",
		"2908": "Report Reference",

//		// A dictionary of known characteristic names and type (keyed by characteristic uuid)
		"2a00": "Device Name",
		"2a01": "Appearance",
		"2a02": "Peripheral Privacy Flag",
		"2a03": "Reconnection Address",
		"2a04": "Peripheral Preferred Connection Parameters",
		"2a05": "Service Changed",
		"2a06": "Alert Level",
		"2a07": "Tx Power Level",
		"2a08": "Date Time",
		"2a09": "Day of Week",
		"2a0a": "Day Date Time",
		"2a0c": "Exact Time 256",
		"2a0d": "DST Offset",
		"2a0e": "Time Zone",
		"2a0f": "Local Time Information",
		"2a11": "Time with DST",
		"2a12": "Time Accuracy",
		"2a13": "Time Source",
		"2a14": "Reference Time Information",
		"2a16": "Time Update Control Point",
		"2a17": "Time Update State",
		"2a18": "Glucose Measurement",
		"2a19": "Battery Level",
		"2a1c": "Temperature Measurement",
		"2a1d": "Temperature Type",
		"2a1e": "Intermediate Temperature",
		"2a21": "Measurement Interval",
		"2a22": "Boot Keyboard Input Report",
		"2a23": "System ID",
		"2a24": "Model Number String",
		"2a25": "Serial Number String",
		"2a26": "Firmware Revision String",
		"2a27": "Hardware Revision String",
		"2a28": "Software Revision String",
		"2a29": "Manufacturer Name String",
		"2a2a": "IEEE 11073-20601 Regulatory Certification Data List",
		"2a2b": "Current Time",
		"2a31": "Scan Refresh",
		"2a32": "Boot Keyboard Output Report",
		"2a33": "Boot Mouse Input Report",
		"2a34": "Glucose Measurement Context",
		"2a35": "Blood Pressure Measurement",
		"2a36": "Intermediate Cuff Pressure",
		"2a37": "Heart Rate Measurement",
		"2a38": "Body Sensor Location",
		"2a39": "Heart Rate Control Point",
		"2a3f": "Alert Status",
		"2a40": "Ringer Control Point",
		"2a41": "Ringer Setting",
		"2a42": "Alert Category ID Bit Mask",
		"2a43": "Alert Category ID",
		"2a44": "Alert Notification Control Point",
		"2a45": "Unread Alert Status",
		"2a46": "New Alert",
		"2a47": "Supported New Alert Category",
		"2a48": "Supported Unread Alert Category",
		"2a49": "Blood Pressure Feature",
		"2a4a": "HID Information",
		"2a4b": "Report Map",
		"2a4c": "HID Control Point",
		"2a4d": "Report",
		"2a4e": "Protocol Mode",
		"2a4f": "Scan Interval Window",
		"2a50": "PnP ID",
		"2a51": "Glucose Feature",
		"2a52": "Record Access Control Point",
		"2a53": "RSC Measurement",
		"2a54": "RSC Feature",
		"2a55": "SC Control Point",
		"2a5b": "CSC Measurement",
		"2a5c": "CSC Feature",
		"2a5d": "Sensor Location"]
	
    // A delay function
   static func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }

	// create label with text, font size and text color
	static func createlabel(_ text:String, font: UIFont,  color:UIColor, autoSizeConstraints:Bool)->UILabel
	{
		let label = UILabel()
		label.backgroundColor = UIColor.clear
		label.font = font
		label.textColor = color
		label.text = text
		if( autoSizeConstraints == false) {
			label.translatesAutoresizingMaskIntoConstraints = false
		}
		return label
	}
		
	static func createButton (_ text:String, font: UIFont,  tcolor:UIColor, bcolor:UIColor,alpha:CGFloat,autoSizeConstraints:Bool)->UIButton
	{
		let button = UIButton(type: .custom)
		button.backgroundColor = bcolor
		button.titleLabel?.font = font
		button.setTitle(text, for: UIControl.State.normal)
		button.setTitleColor(tcolor,for: UIControl.State.normal)
		if( autoSizeConstraints == false) {
			button.translatesAutoresizingMaskIntoConstraints = false
		}
		button.alpha = alpha
		return button
	}
	
	// create button that load image as background
	static func createButtonWithImage(_ image:UIImage, x:CGFloat, y: CGFloat, width: CGFloat,height:CGFloat)->UIButton
	{
		//let image = UIImage(named: imageName) as UIImage?
		let button = UIButton(type: .custom)
		button.backgroundColor = UIColor.clear
		if( width == 0 && height == 0) {
			button.frame = CGRect()
			button.translatesAutoresizingMaskIntoConstraints = false
		}
		else {
			button.frame = CGRect(x: x,y: y,width:width, height:height )
		}
		button.setImage(image, for: UIControl.State())
		
		return button
	}
	
	
	static func getCharacteristicPropertyStr(Characteristic:CBCharacteristic)->String{
		var str = "Property:"
		if Characteristic.properties.contains(.authenticatedSignedWrites){
			str.append(" signedWrite")
		}
		if Characteristic.properties.contains(.broadcast){
			str.append(" broadcast" )
		}
		if Characteristic.properties.contains(.extendedProperties){
			str.append(" extendProperty" )
		}
		if Characteristic.properties.contains(.indicate){
			str.append(" indicate" )
		}
		if Characteristic.properties.contains(.indicateEncryptionRequired){
			str.append(" indicateEncryp" )
		}
		if Characteristic.properties.contains(.notify){
			str.append(" notify" )
		}
		if Characteristic.properties.contains(.notifyEncryptionRequired){
			str.append(" notifyEncryp" )
		}
		if Characteristic.properties.contains(.read){
			str.append(" read" )
		}
		if Characteristic.properties.contains(.write){
			str.append(" write" )
		}
		if Characteristic.properties.contains(.writeWithoutResponse){
			str.append(" writeWithoutResponse" )
		}
		return str
	}
	
	static func getUInt32(byte:[UInt8],index:Int)->UInt32?{
		if byte.count <= (index + 3){
			return nil
		}
		return UInt32(byte[index]) +
		      ( UInt32(byte[index+1]) << 8) +
			  ( UInt32(byte[index+2]) << 16) +
			  ( UInt32(byte[index+3]) << 24)
	}
	
	static func getUInt16(byte:[UInt8],index:Int)->UInt16?{
		if byte.count <= (index + 1){
			return nil
		}
		return UInt16(byte[index]) +
		      ( UInt16(byte[index+1]) << 8)
			 
	}
	static func getUUIDName(uuid:CBUUID)->String?{
		_ = uuid.uuidString.lowercased()
		if let name = Common.KNOWN_UUID[uuid.uuidString.lowercased()]{
			return name
		}
		else {
			return nil
		}
	}

}


