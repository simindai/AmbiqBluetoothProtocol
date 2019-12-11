//
//  ConnectView.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/22/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
class ConnectView:UIView{
	var m_connectLabel:UILabel!
	var m_indicateView:UIActivityIndicatorView!
	var m_constraints = sConstraint()

	 struct constantsFontColor
	 {
		 static let labelFontIphone = UIFont(name:"Helvetica", size: 16.0)!
		 static let labelFontIpad = UIFont(name:"Helvetica", size: 22.0)!
	 }

	 struct sConstraint
	 {
		 var labelFont:UIFont!
		 var labelHeightFrac:CGFloat = 0.0
	 }
	 
	 override init(frame: CGRect){
	   super.init(frame: frame)
		self.setup()
	 }
	 
	 required init?(coder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	 }
	 
		
	
	func  setup(){
		self.init_constraints()
		self.add_controls()
		self.setupConstraints()
		
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.gray.cgColor
		
	}
	
	func init_constraints(){
		self.m_constraints.labelFont = constantsFontColor.labelFontIphone
		self.m_constraints.labelHeightFrac = 0.6
	}
	
	func add_controls(){
		self.m_connectLabel = Common.createlabel("Connecting...", font: self.m_constraints.labelFont, color: UIColor.white, autoSizeConstraints: false)
		self.m_connectLabel.textAlignment = .center
		self.m_connectLabel.adjustsFontSizeToFitWidth = true
		self.m_indicateView = UIActivityIndicatorView(style: .white)
		self.m_indicateView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.m_connectLabel)
		self.addSubview(self.m_indicateView)
	}
	
	
	func setupConstraints(){
		let margin_guide = self.layoutMarginsGuide
		self.m_indicateView.topAnchor.constraint(equalTo: margin_guide.topAnchor).isActive = true
		self.m_indicateView.leftAnchor.constraint(equalTo: margin_guide.leftAnchor).isActive = true
		self.m_indicateView.rightAnchor.constraint(equalTo: margin_guide.rightAnchor).isActive = true
		self.m_indicateView.heightAnchor.constraint(equalTo: margin_guide.heightAnchor, multiplier: self.m_constraints.labelHeightFrac).isActive = true
		
		self.m_connectLabel.leftAnchor.constraint(equalTo: self.m_indicateView.leftAnchor).isActive = true
		self.m_connectLabel.rightAnchor.constraint(equalTo: self.m_indicateView.rightAnchor).isActive = true
		self.m_connectLabel.topAnchor.constraint(equalTo: self.m_indicateView.bottomAnchor).isActive = true
		self.m_connectLabel.bottomAnchor.constraint(equalTo: margin_guide.bottomAnchor).isActive = true
	}
	
	func startAnimate(){
		self.m_indicateView.startAnimating()
	}
	
	func stopAnmiate(){
		self.m_indicateView.stopAnimating()
	}
	
	public func updateLabelText(str:String){
		self.m_connectLabel.text = str
	}
}
