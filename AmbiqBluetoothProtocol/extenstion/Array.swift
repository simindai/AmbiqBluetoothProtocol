//
//  Array.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/21/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
extension Array {
mutating public func remove(at indexes: [Int]) {
	for index in indexes.sorted(by: >) {
		remove(at: index)
	}
}
}
