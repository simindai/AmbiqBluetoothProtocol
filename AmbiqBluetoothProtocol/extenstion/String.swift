//
//  String.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 12/2/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
extension String {
	
	mutating public func appendWithTime(_ str:String){
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss.SSS"
		let time_str = formatter.string(from: date)
		if self.count > 50000{
			self = substringToFirstCharWithoutChar(of: "\n")
		}
		self.append("\(time_str) \(str)\n")
		
		
		
	}
	
	func substringToFirstCharWithoutChar(of char: Character) -> String
    {
        guard let pos = self.firstIndex(of: char) else { return self }
		let index = self.index(pos, offsetBy: 1)
		let subString = self[index...]
        return String(subString)
    }


}
