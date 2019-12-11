//
//  AmbiqTxController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/29/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class AmbiqTxController: UIViewController,MenuViewDelegate{
	
	var m_titleView:UIView!
	var m_titleLabel:UILabel!
	var m_backButton:UIButton!
	var m_actionView:UIView!
	var m_testLabel:UILabel!
	var m_txActionSwitch:UISwitch!
	var m_menuView:MenuView!
	//var m_logView:UIScrollView!
	//var m_logText:UILabel!
	var m_safeArea:UILayoutGuide!
	var m_constraint = sConstraint()
	var m_peripheral:CBPeripheral
	var m_delegate:ServiceDelegate!
	var m_rxCharacteristic:CBCharacteristic
	var m_service:CBService!
	
	
	init(delegate:ServiceDelegate, peripheral:CBPeripheral,  characteristic:CBCharacteristic)
	{
		self.m_peripheral = peripheral
		self.m_rxCharacteristic = characteristic
		self.m_delegate = delegate
		super.init(nibName:nil, bundle: nil)
		self.m_safeArea = self.view.layoutMarginsGuide
		set_up()
		self.view.backgroundColor = .white
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	struct constantsFontColor
	{
		static let setupLabelFontIphone = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
		static let setupLabelFontIpad = UIFont(name:"HelveticaNeue-Bold", size: 20.0)!
		static let setupLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let buttonFontIphone  = UIFont(name:"Helvetica", size: 16.0)!
		static let buttonFontIpad  = UIFont(name:"Helvetica", size: 22.0)!
		static let logFontIphone  = UIFont(name:"Helvetica", size: 12.0)!
		static let buttonColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
	}

	struct sConstraint
	{
		var titleViewHeightFrac:CGFloat = 0.0
		var testSwitchHeightFrac:CGFloat = 0.0
		var titleLableFont:UIFont!
		var buttonLabelFont:UIFont!
		var logLabelFont:UIFont!
	}
	
	func set_up(){
		self.init_constraints()
		self.add_controls()
		self.setup_titleView()
		self.setup_action_view()
		self.setup_view()
	}
	func init_constraints(){
		self.m_constraint.titleViewHeightFrac = 0.1
		self.m_constraint.testSwitchHeightFrac = 0.7
		self.m_constraint.titleLableFont = constantsFontColor.setupLabelFontIphone
		self.m_constraint.buttonLabelFont = constantsFontColor.buttonFontIphone
		self.m_constraint.logLabelFont = constantsFontColor.logFontIphone
	}
	
	func add_controls(){
		self.m_titleView = UIView()
		self.m_titleView.translatesAutoresizingMaskIntoConstraints = false
		self.m_titleLabel = Common.createlabel("Ambiq Tx characteristic", font:self.m_constraint.titleLableFont , color: constantsFontColor.setupLabelColor, autoSizeConstraints: false)
		self.m_titleLabel.textAlignment = .center
		self.m_backButton = Common.createButton("<", font: self.m_constraint.buttonLabelFont, tcolor: constantsFontColor.buttonColor, bcolor: UIColor.white, alpha: 1.0, autoSizeConstraints: false)
		self.m_backButton.addTarget(self, action: #selector(self.action_back(_:)), for: .touchUpInside)
		self.m_actionView = UIView()
		self.m_actionView.translatesAutoresizingMaskIntoConstraints = false
		self.m_testLabel = Common.createlabel("Request Server Send Test Data", font:self.m_constraint.buttonLabelFont , color: constantsFontColor.setupLabelColor, autoSizeConstraints: false)
		self.m_testLabel.textAlignment = .center
		self.m_txActionSwitch = UISwitch()
		self.m_txActionSwitch.translatesAutoresizingMaskIntoConstraints = false
		self.m_txActionSwitch.addTarget(self, action: #selector(self.action_switch(_:)), for: .valueChanged)
		self.m_menuView  = MenuView(delegate: self)
		self.m_menuView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(self.m_titleView)
		self.view.addSubview(self.m_actionView)
		self.view.addSubview(self.m_menuView)
		
		self.m_actionView.addSubview(self.m_testLabel)
		self.m_actionView.addSubview(self.m_txActionSwitch)
		
		self.m_titleView.addSubview(self.m_titleLabel)
		self.m_titleView.addSubview(self.m_backButton)
		self.m_titleView.backgroundColor = UIColor.white
		self.m_actionView.backgroundColor = UIColor.white
		self.m_actionView.layer.borderWidth = 0.5
		self.m_actionView.layer.borderColor = UIColor.gray.cgColor
		
		
	}

	func setup_titleView(){
		let magin_guide = self.m_titleView.layoutMarginsGuide
		self.m_titleLabel.centerXAnchor.constraint(equalTo: magin_guide.centerXAnchor).isActive = true
		self.m_titleLabel.centerYAnchor.constraint(equalTo: magin_guide.centerYAnchor).isActive = true
		self.m_backButton.leftAnchor.constraint(equalTo: magin_guide.leftAnchor).isActive = true
		self.m_backButton.centerYAnchor.constraint(equalTo: self.m_titleLabel.centerYAnchor).isActive = true
	}
	
	func setup_action_view(){
		let magin_guide = self.m_actionView.layoutMarginsGuide
		self.m_testLabel.leftAnchor.constraint(equalTo: magin_guide.leftAnchor).isActive = true
		self.m_testLabel.centerYAnchor.constraint(equalTo: magin_guide.centerYAnchor).isActive = true
		self.m_txActionSwitch.rightAnchor.constraint(equalTo: magin_guide.rightAnchor).isActive = true
		self.m_txActionSwitch.centerYAnchor.constraint(equalTo: self.m_testLabel.centerYAnchor).isActive = true
	}
	
	func setup_view(){
		self.m_titleView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		self.m_titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.m_titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.m_titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: self.m_constraint.titleViewHeightFrac).isActive = true
		self.m_actionView.topAnchor.constraint(equalTo: self.m_titleView.bottomAnchor).isActive = true
		self.m_actionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.m_actionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.m_actionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: self.m_constraint.titleViewHeightFrac).isActive = true
		
		self.m_menuView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
			self.m_menuView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
			self.m_menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
			self.m_menuView.bottomAnchor.constraint(equalTo: self.m_safeArea.bottomAnchor).isActive = true

		
	}
	

	@objc func action_back(_ send:UIButton){
	    clean_up()
		self.dismiss(animated: true, completion: nil)
    }
	
	@objc func action_switch(_ send:UISwitch){
		if send.isOn{
		    self.m_delegate.requestServerSendTestData(p: self.m_peripheral,rxCharacteristic: self.m_rxCharacteristic)
		}
		else {
			clean_up()
		}
	
	}

	func clean_up(){
		self.m_delegate.stopServerSendDataToClient(p: self.m_peripheral, rxCharacteristic: self.m_rxCharacteristic)
    }
	func menuClientAction() {
		
	}
	
	func menuPeripheralAction() {
		
	}
	
	func menuLogAction() {
		//self.m_delegate.stopTestDataToServer()
		let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller, animated: true, completion: nil)
	}

}


