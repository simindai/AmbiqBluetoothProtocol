//
//  Notification.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/25/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
extension Notification.Name{
	static let didDiscoverService = Notification.Name("didDiscoverService")
	static let didDiscoverCharateristic = Notification.Name("didDiscoverCharateristic")
    static let didLostConnection = Notification.Name("didLostConnection")
	static let didReadRSSI = Notification.Name("didReadRSSI")
}
