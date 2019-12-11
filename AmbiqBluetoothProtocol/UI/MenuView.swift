//
//  MenuView.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/19/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit

class MenuView:UIView{
	var m_clientLabel:UILabel!
	var m_clientButton:UIButton!
	var m_serverLabel:UILabel!
	var m_serverButton:UIButton!
	var m_logLabel:UILabel!
	var m_logButton:UIButton!
	
	var m_constraint = sConstraint()
	var m_menuStatus:Int!
	var m_delegate:MenuViewDelegate?
	
	var m_buttonClientOnImg:UIImage?
	var m_buttonClientOffImg:UIImage?
	var m_buttonServerOnImg:UIImage?
	var m_buttonServerOffImg:UIImage?
	var m_buttonLogOnImg:UIImage?
	var m_buttonLogOffImg:UIImage?
	
	var m_clientImg:UIImage?
	var m_serverImg:UIImage?
	var m_logImg:UIImage?
	var m_isBack:Bool = false
	
	public static let MENU_CLIENT = 0
	public static let MENU_SERVER = 1
	public static let MENU_LOG = 2
	
	struct constantsFontColor
    {
        static let labelFontIphone = UIFont(name:"Helvetica", size: 12.0)!
        static let labelFontIpad = UIFont(name:"Helvetica", size: 22.0)!
        static let labelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
    }
	
	struct sConstraint
    {
        var labelFont:UIFont!
        var buttonHeightFrac :CGFloat = 0.0
		var clientButtonHpos:CGFloat = 0.0
		var logButtonHpos:CGFloat = 0.0
    }
	
	//
	init(delegate:MenuViewDelegate?, status:Int=MenuView.MENU_CLIENT,isBack:Bool=false){
		super.init(frame:CGRect())
		self.m_delegate = delegate
		self.m_menuStatus = status
		self.m_isBack = isBack
		self.setup()
	}
	
	override init(frame: CGRect){
	  super.init(frame: frame)
		
	  
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup(){
		init_image()
		init_constraint()
		addControls()
		setupConstraint()
		self.addTopBorder(with: UIColor.gray, andWidth: 0.5)
		if self.m_isBack{
			self.enableBackButton()
		}
		
	}
	
	private func init_image(){
		self.m_buttonClientOnImg =  UIImage(named: "client_on")!
		self.m_buttonClientOffImg = UIImage(named: "client_off")!
		self.m_buttonServerOnImg =  UIImage(named: "server_on")!
		self.m_buttonServerOffImg = UIImage(named: "server_off")!
		self.m_buttonLogOnImg =  UIImage(named: "log_on")!
		self.m_buttonLogOffImg = UIImage(named: "log_off")!
		if self.m_menuStatus == MenuView.MENU_CLIENT{
			self.m_clientImg = self.m_buttonClientOnImg
			self.m_serverImg = self.m_buttonServerOffImg
			self.m_logImg = self.m_buttonLogOffImg
			
		}
		else if self.m_menuStatus == MenuView.MENU_SERVER{
			self.m_clientImg = self.m_buttonClientOffImg
			self.m_serverImg = self.m_buttonServerOnImg
			self.m_logImg = self.m_buttonLogOffImg
			
		}
		else {
			self.m_clientImg = self.m_buttonClientOffImg
			self.m_serverImg = self.m_buttonServerOffImg
			self.m_logImg = self.m_buttonLogOnImg
			
		}
		
	}
	
	private func init_constraint(){
		//var screenHeight = UIScreen.main.bounds.size.height
		//var screenWidth = UIScreen.main.bounds.size.width
		self.m_constraint.labelFont = constantsFontColor.labelFontIphone
		self.m_constraint.buttonHeightFrac = 0.7
		self.m_constraint.clientButtonHpos = -40.0
		self.m_constraint.logButtonHpos = 40.0
	}
	
	private func addControls(){
		self.m_clientButton = Common.createButtonWithImage(self.m_clientImg!, x: 0, y: 0, width: 0, height: 0)
		self.addSubview(self.m_clientButton)
		self.m_clientLabel = Common.createlabel("client", font: self.m_constraint.labelFont, color: constantsFontColor.labelColor, autoSizeConstraints: false)
		self.addSubview(self.m_clientLabel)
		self.m_clientButton.addTarget(self, action: #selector(self.client_button_action), for: .touchUpInside)
		
		self.m_serverButton = Common.createButtonWithImage(self.m_serverImg!, x: 0, y: 0, width: 0, height: 0)
		self.addSubview(self.m_serverButton)
		self.m_serverLabel = Common.createlabel("server", font: self.m_constraint.labelFont, color: constantsFontColor.labelColor, autoSizeConstraints: false)
		self.addSubview(self.m_serverLabel)
		self.m_serverButton.addTarget(self, action: #selector(self.server_button_action), for: .touchUpInside)
		
		self.m_logButton = Common.createButtonWithImage(self.m_logImg!, x: 0, y: 0, width: 0, height: 0)
		
		self.addSubview(self.m_logButton)
		self.m_logLabel = Common.createlabel("log", font: self.m_constraint.labelFont, color: constantsFontColor.labelColor, autoSizeConstraints: false)
		self.addSubview(self.m_logLabel)
		self.m_logButton.addTarget(self, action: #selector(self.log_button_action), for: .touchUpInside)
	}
	
	private func setupConstraint(){
		let marginGuide = self.layoutMarginsGuide
		self.m_serverButton.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor).isActive = true
		self.m_serverButton.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		self.m_serverButton.heightAnchor.constraint(equalTo: marginGuide.heightAnchor, multiplier: self.m_constraint.buttonHeightFrac).isActive = true
		self.m_serverButton.widthAnchor.constraint(equalTo: self.m_serverButton.heightAnchor).isActive = true
		self.m_serverLabel.centerXAnchor.constraint(equalTo: self.m_serverButton.centerXAnchor).isActive = true
		self.m_serverLabel.topAnchor.constraint(equalTo: self.m_serverButton.bottomAnchor).isActive = true
		
		self.m_clientButton.rightAnchor.constraint(equalTo: self.m_serverButton.leftAnchor, constant: self.m_constraint.clientButtonHpos).isActive = true
		self.m_clientButton.centerYAnchor.constraint(equalTo: self.m_serverButton.centerYAnchor).isActive = true
		self.m_clientButton.heightAnchor.constraint(equalTo: self.m_serverButton.heightAnchor).isActive = true
		self.m_clientButton.widthAnchor.constraint(equalTo: self.m_clientButton.heightAnchor).isActive = true
		self.m_clientLabel.centerXAnchor.constraint(equalTo: self.m_clientButton.centerXAnchor).isActive = true
		self.m_clientLabel.topAnchor.constraint(equalTo: self.m_clientButton.bottomAnchor).isActive = true
		
		self.m_logButton.leftAnchor.constraint(equalTo: self.m_serverButton.rightAnchor, constant: self.m_constraint.logButtonHpos).isActive = true
		self.m_logButton.centerYAnchor.constraint(equalTo: self.m_serverButton.centerYAnchor).isActive = true
		self.m_logButton.heightAnchor.constraint(equalTo: self.m_serverButton.heightAnchor).isActive = true
		self.m_logButton.widthAnchor.constraint(equalTo: self.m_logButton.heightAnchor).isActive = true
		self.m_logLabel.centerXAnchor.constraint(equalTo: self.m_logButton.centerXAnchor).isActive = true
		self.m_logLabel.topAnchor.constraint(equalTo: self.m_logButton.bottomAnchor).isActive = true
	}
	
	public func enableBackButton(){
		self.m_clientButton.setImage(nil, for: UIControl.State())
		self.m_clientButton.setTitleColor(.black, for: .normal)
		self.m_clientButton.setTitle("<", for: .normal)
		self.m_clientLabel.alpha = 0.1
		
		self.m_serverButton.isEnabled = false
		self.m_serverButton.alpha = 0.1
		self.m_serverLabel.alpha = 0.1
		
	}
	
	public func disableClientButton(){
		//self.m_clientButton.setImage(nil, for: UIControl.State())
		//self.m_clientButton.setTitleColor(.black, for: .normal)
		//self.m_clientButton.setTitle("<", for: .normal)
		self.m_clientButton.isEnabled = false
		self.m_clientButton.alpha = 0.4
		self.m_clientLabel.alpha = 0.4
		
	}
	
	public func disableServerButton(){
		self.m_serverButton.isEnabled = false
		self.m_serverButton.alpha = 0.4
		self.m_serverLabel.alpha = 0.4
	}
	@objc func client_button_action(){

		self.m_delegate?.menuClientAction()
	}
	
	@objc func server_button_action(){
		self.m_delegate?.menuPeripheralAction()
	}
	@objc func log_button_action(){
		self.m_delegate?.menuLogAction()
	}
	
	
	func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
		border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
		self.addSubview(border)
	}

	
	
	
	
	
	
	
	
	
}
