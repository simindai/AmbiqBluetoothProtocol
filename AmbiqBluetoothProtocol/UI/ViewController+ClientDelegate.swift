//
//  ViewController+ClientDelegate.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/20/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
extension ViewController{
	
	func scan(){
		if self.m_timer == nil {
		    self.m_timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector:#selector(self.tick), userInfo: nil, repeats: true)
		}
		self.m_client.scan()
	}
	
	func stopScan(){
		self.m_timer?.invalidate()
		self.m_timer = nil
		self.m_client.stopScan()
	}
	
	
	@objc func tick() {
		
		//self.m_client.readRssi()
		self.m_tableView.reloadData()
		
	}
}
