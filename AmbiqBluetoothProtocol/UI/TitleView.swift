//
//  TitleView.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/18/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
class TitleView:UIView{
	
	var m_label:UILabel!
	var m_scanButton:UIButton!
	var m_scanStatus:Int!
	var m_constraint = sConstraint()
	var m_clientDelegate:ClientlDelegate!

	override init(frame: CGRect) {
        super.init(frame: frame)
    }
	
	init(delgate:ClientlDelegate){
	  super.init(frame:CGRect())
	  self.setup()
	  self.m_clientDelegate = delgate
	}
	let SCANN_STATUS_STOPPED = 0
	let SCANN_STATUS_WORKING = 1
	struct constantsFontColor
    {
        static let setupLabelFontIphone = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
        static let setupLabelFontIpad = UIFont(name:"HelveticaNeue-Bold", size: 22.0)!
        static let setupLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let scanButtonFontIphone  = UIFont(name:"Helvetica", size: 16.0)!
		static let scanButtonFontIpad  = UIFont(name:"Helvetica", size: 22.0)!
		static let scanButtonColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		
    }
	
	
	struct sConstraint
    {
        var titleLabelFont:UIFont!
        var titleLabelVpos :CGFloat = 0.0
		var titleLabeWidthFrac:CGFloat = 0.0
		var scanButtonFont:UIFont!
		var scanButtonHpos:CGFloat = 0.0
		var scanButtonVpos:CGFloat = 0.0
        var scanButtonWidthFrac :CGFloat = 0.0
        var scanButtonHeightFrac:CGFloat = 0.0
    }
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup(){
		self.setupConstraints()
		self.addControls()
		self.setControlConstraint()
		self.m_scanStatus = SCANN_STATUS_STOPPED
	}
	func setupConstraints()
    {
        
		self.m_constraint.titleLabelFont = constantsFontColor.setupLabelFontIphone
		self.m_constraint.titleLabelVpos = 0.5
		self.m_constraint.scanButtonFont = constantsFontColor.scanButtonFontIphone
		self.m_constraint.scanButtonHpos = 0.7
		self.m_constraint.scanButtonVpos = 0.8
		self.m_constraint.scanButtonWidthFrac = 0.3
		self.m_constraint.scanButtonHeightFrac = 0.5
	}
		
	
	func addControls(){
		self.m_label =  Common.createlabel("Ambiq BLE Protocol", font: self.m_constraint.titleLabelFont, color: constantsFontColor.setupLabelColor, autoSizeConstraints: false)
		self.addSubview(self.m_label)
		self.m_scanButton = Common.createButton("scan", font:self.m_constraint.scanButtonFont , tcolor: constantsFontColor.scanButtonColor, bcolor: UIColor.white, alpha: 1.0, autoSizeConstraints: false)
		//self.m_scanButton.sizeToFit()
		self.addSubview(self.m_scanButton)
		self.m_scanButton.addTarget(self, action: #selector(self.scanButtonAction), for: .touchUpInside)
	}
	
	func setControlConstraint(){
		self.setLabelConstraint()
		self.setScanButtonConstraint()
	}
	
	func setLabelConstraint(){
		self.m_label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		self.m_label.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
		self.m_label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
	}
	
	func setScanButtonConstraint(){
		self.m_scanButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
		self.m_scanButton.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
		//self.m_scanButton.topAnchor.constraint(equalTo: self.m_label.bottomAnchor).isActive = true
	}
	
	@objc func scanButtonAction(){
		if self.m_scanStatus == SCANN_STATUS_STOPPED{
			self.m_scanButton.setTitle("stop scan", for: UIControl.State.normal)
			self.m_scanStatus = SCANN_STATUS_WORKING
			self.m_clientDelegate.scan()
		}
		else{
			self.m_scanButton.setTitle("scan", for: UIControl.State.normal)
			self.m_scanStatus = SCANN_STATUS_STOPPED
			self.m_clientDelegate.stopScan()
		}
	}
	
	public func isScanned()->Bool{
		if self.m_scanStatus == SCANN_STATUS_STOPPED{
			return false
		}
		else {
			return true
		}
	}
	
	
	
	
	
	
}
