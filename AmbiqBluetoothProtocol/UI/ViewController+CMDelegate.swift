//
//  ViewController+CMDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/22/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
extension ViewController{
	func updatePeripheralTable(rowIndex:Int){
//		let index_path = IndexPath(row: rowIndex, section: 0)
//		self.m_tableView.reloadRows(at: [index_path], with: .top)
		self.m_tableView.reloadData()
	}
	
	@objc func updateRssi(_ notification: Notification) {
		if let peripheral = notification.object as? CBPeripheral, let rssi = notification.userInfo?["rssi"] as? NSNumber{
			
			self.m_client.updateRssi(p: peripheral, rssi: rssi)
			
			
			
			
			
			
			}
	}
	@objc func launchServiceView(_ notification: Notification) {
		if let peripheral = notification.object as? CBPeripheral{
			NotificationCenter.default.removeObserver(self)
			DispatchQueue.main.async {
			self.m_connectTimer?.invalidate()
			self.m_connectTimer = nil
			self.m_timer?.invalidate()
			self.m_timer = nil
			self.m_ConnectView.stopAnmiate()
			self.m_ConnectView.isHidden = true
			self.m_blackView.isHidden = true
			self.view.window!.layer.removeAllAnimations()
			let transition = CATransition()
			transition.duration = 0.5
			transition.type = CATransitionType.push
			transition.subtype = CATransitionSubtype.fromRight
			transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
			self.view.window!.layer.add(transition, forKey: kCATransition)
			//if self.m_serviceController == nil {
			  // self.m_serviceController = ServiceViewController(delegate: self, periapheral: peripheral)
			//}
			let service_controller = ServiceViewController(delegate: self, periapheral: peripheral)
			service_controller.modalPresentationStyle = .fullScreen
			self.present(service_controller, animated: false, completion: nil)
			
			}
		}
//

		
		
	}
	
	
}
