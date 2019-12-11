//
//  CharacteristicTitleView.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/25/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
//
//   CharacteristicTitleView.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/24/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class  CharacteristicTitleView:UIView{
	
	var m_label:UILabel!
	//var m_connectButton:UIButton!
	var m_backButton:UIButton!
	var m_constraint = sConstraint()
	var m_service_delegate:ServiceDelegate!
	var m_characteristic_title_view_delegate:CharacteristicTitleViewDelegate!
	var m_peripheral:CBPeripheral!
	var m_service:CBService!
	override init(frame: CGRect) {
        super.init(frame: frame)
    }
	
	init(delgate:ServiceDelegate, charateristicTitleViewDelegate:CharacteristicTitleViewDelegate, p:CBPeripheral, service:CBService){
	  super.init(frame:CGRect())
	  self.setup()
	  self.m_service_delegate = delgate
	  self.m_characteristic_title_view_delegate = charateristicTitleViewDelegate
	  self.m_peripheral  = p
	  self.m_service = service
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	struct constantsFontColor
	{
		static let setupLabelFontIphone = UIFont(name:"HelveticaNeue-Bold", size: 18.0)!
		static let setupLabelFontIpad = UIFont(name:"HelveticaNeue-Bold", size: 25.0)!
		static let setupLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let buttonFontIphone  = UIFont(name:"Helvetica", size: 16.0)!
		static let buttonFontIpad  = UIFont(name:"Helvetica", size: 22.0)!
		static let buttonColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
	}

    struct sConstraint
    {
        var titleLabelFont:UIFont!
		var buttonFont:UIFont!
		var backButtonWidthFrac:CGFloat = 0.0
		var connectButtonWidthFrac :CGFloat = 0.0
    }

	func setup(){
		init_constraints()
		add_controls()
		set_constraints()
		NotificationCenter.default.addObserver(self, selector: #selector(self.disconnectAction(_:)), name: .didLostConnection, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.connectAction(_:)), name: .didDiscoverCharateristic, object: nil)
		
    }

    private func init_constraints()
    {
		self.m_constraint.titleLabelFont = constantsFontColor.setupLabelFontIphone
		self.m_constraint.buttonFont  = constantsFontColor.buttonFontIphone
		self.m_constraint.backButtonWidthFrac = 0.15
		self.m_constraint.connectButtonWidthFrac = 0.3
	}

	private func add_controls(){
		self.m_label = Common.createlabel("Characteriscs", font: self.m_constraint.titleLabelFont, color: UIColor.white, autoSizeConstraints: false)
		self.m_label.backgroundColor = constantsFontColor.setupLabelColor
		self.m_label.textAlignment = .center
		self.m_label.sizeToFit()
		self.m_backButton = Common.createButton("Back", font: self.m_constraint.buttonFont, tcolor: UIColor.white, bcolor: constantsFontColor.buttonColor, alpha: 1.0, autoSizeConstraints: false)
		//self.m_connectButton = Common.createButton("Disconnect", font: self.m_constraint.buttonFont, tcolor: UIColor.white, bcolor: constantsFontColor.buttonColor, alpha: 1.0, autoSizeConstraints: false)
		self.m_backButton.sizeToFit()
		//self.m_connectButton.sizeToFit()
		self.m_backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
		//self.m_connectButton.addTarget(self, action: #selector(self.connectButtonAction(_:)), for: .touchUpInside)
		self.backgroundColor = constantsFontColor.setupLabelColor
		self.addSubview(self.m_label)
		self.addSubview(self.m_backButton)
		//self.addSubview(self.m_connectButton)
	}
	
	private func set_constraints(){
		let marginGuide = self.layoutMarginsGuide
		self.m_backButton.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
		self.m_backButton.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		self.m_backButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		
		self.m_label.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		self.m_label.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		self.m_label.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
		self.m_label.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
		
//		self.m_connectButton.leftAnchor.constraint(equalTo: self.m_label.rightAnchor).isActive = true
//		self.m_connectButton.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
//		self.m_connectButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
//		self.m_connectButton.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true
		
	}
	
	func removeObserver(){
		NotificationCenter.default.removeObserver(self)
	}
	
	func addObserver(){
		NotificationCenter.default.addObserver(self, selector: #selector(self.disconnectAction(_:)), name: .didLostConnection, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.connectAction(_:)), name: .didDiscoverCharateristic, object: nil)
	}
	
	@objc func backAction(_ sender: UIButton){
		self.cleanup()
		self.m_characteristic_title_view_delegate.service_release()
		
	}
	
	@objc func connectButtonAction(_ sender: UIButton){
		
		if let text = sender.titleLabel?.text{
			if text == "Disconnect"{
				self.m_service_delegate.Disconnect(p: self.m_peripheral)
			}
			else {
				self.m_service_delegate.Connect(p: self.m_peripheral)
				
			}
		}
	}
	
	@objc func disconnectAction(_ notification: Notification){
		DispatchQueue.main.async {
			//self.m_connectButton.setTitle("Connect", for: .normal)
			self.m_label.text = "Disconnected"
			self.m_label.textColor = UIColor.red
		}
	}
	
	@objc func connectAction(_ notification: Notification){
		DispatchQueue.main.async {
		    //self.m_connectButton.setTitle("Disconnect", for: .normal)
			self.m_label.text = "Characteriscs"
			self.m_label.textColor = UIColor.white
			
		}
	}
	
	func cleanup(){
		removeObserver()
	}
}

    
