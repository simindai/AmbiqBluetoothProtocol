//
//  LogViewController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 12/2/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
class LogViewController: UIViewController{
	
	var m_scrollView:UIScrollView!
	var m_stackView:UIStackView!
	var m_label:UILabel!
	var m_titleView:UIView!
	var m_titleLable:UILabel!
	var m_backButton:UIButton!
	var m_clearButton:UIButton!
	var m_constraint = sConstraint()
	
	var m_safeArea:UILayoutGuide!
	
	struct constantsFontColor
	{
		static let titleLabelFontIphone = UIFont(name:"HelveticaNeue-Bold", size: 20.0)!
		static let titleLabelFontIpad = UIFont(name:"HelveticaNeue-Bold", size: 25.0)!
		static let titleLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let buttonFontIphone  = UIFont(name:"Helvetica", size: 16.0)!
		static let buttonFontIpad  = UIFont(name:"Helvetica", size: 22.0)!
		static let buttonColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let msgLabelFontIphone = UIFont(name:"Helvetica", size: 12.0)!
		static let msgLabelFontIpad = UIFont(name:"Helvetica", size: 20.0)!
		static let msgLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
	}

    struct sConstraint
	{
        var msgLabelFont:UIFont!
		var titleViewHeightFrac:CGFloat = 0.0
		var titleLabelFont:UIFont!
		var buttonFont:UIFont!
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func loadView() {
		super.loadView()
		self.m_safeArea = self.view.layoutMarginsGuide
		self.view.backgroundColor = .white
		setupView()
	
	}
	
	func setupView(){
		self.init_constraints()
		self.addControl()
		self.setup_constraints()
	}
	private func init_constraints(){
		self.m_constraint.msgLabelFont = constantsFontColor.msgLabelFontIphone
		self.m_constraint.titleViewHeightFrac = 0.1
		self.m_constraint.titleLabelFont = constantsFontColor.titleLabelFontIphone
		self.m_constraint.buttonFont = constantsFontColor.buttonFontIphone
	}
	private func addControl(){
		self.m_titleView = UIView()
		self.m_titleView.translatesAutoresizingMaskIntoConstraints = false
		self.m_titleView.backgroundColor = .white
		
		self.m_titleLable = Common.createlabel("Log", font: self.m_constraint.titleLabelFont, color: constantsFontColor.titleLabelColor, autoSizeConstraints: false)
		self.m_backButton = Common.createButton("<", font: self.m_constraint.buttonFont, tcolor: constantsFontColor.buttonColor, bcolor: .white, alpha: 1.0, autoSizeConstraints: false)
		self.m_clearButton = Common.createButton("clear", font: self.m_constraint.buttonFont, tcolor: constantsFontColor.buttonColor, bcolor: .white, alpha: 1.0, autoSizeConstraints: false)
        self.m_backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
		self.m_clearButton.addTarget(self, action: #selector(self.clearAction(_:)), for: .touchUpInside)
		self.m_scrollView = UIScrollView()
		self.m_scrollView.backgroundColor = .white
		self.m_scrollView.translatesAutoresizingMaskIntoConstraints = false
		

		self.m_stackView = UIStackView()
		self.m_stackView.translatesAutoresizingMaskIntoConstraints = false
		self.m_stackView.axis = .vertical
		self.m_stackView.spacing = 10
		self.m_stackView.backgroundColor = .white
		self.m_label = Common.createlabel(log_msg, font: self.m_constraint.msgLabelFont, color: constantsFontColor.msgLabelColor, autoSizeConstraints: false)
		self.m_label.numberOfLines = 0
		
		self.view.addSubview(self.m_scrollView)
		self.view.addSubview(self.m_titleView)
		self.m_titleView.addSubview(self.m_titleLable)
		self.m_titleView.addSubview(self.m_backButton)
		self.m_titleView.addSubview(self.m_clearButton)
		self.m_scrollView.addSubview(self.m_stackView)
		
		
	}
	
	private func setup_constraints(){
		
		self.m_titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive =  true
		self.m_titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive =  true
		self.m_titleView.topAnchor.constraint(equalTo: self.m_safeArea.topAnchor).isActive = true
		self.m_titleView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: self.m_constraint.titleViewHeightFrac).isActive = true
	     
		self.m_titleLable.centerXAnchor.constraint(equalTo: self.m_titleView.centerXAnchor).isActive = true
		self.m_titleLable.centerYAnchor.constraint(equalTo: self.m_titleView.centerYAnchor).isActive = true
		self.m_backButton.centerYAnchor.constraint(equalTo: self.m_titleLable.centerYAnchor).isActive = true
		self.m_backButton.leftAnchor.constraint(equalTo: self.m_titleView.layoutMarginsGuide.leftAnchor).isActive = true
		self.m_clearButton.centerYAnchor.constraint(equalTo: self.m_titleLable.centerYAnchor).isActive = true
		self.m_clearButton.rightAnchor.constraint(equalTo: self.m_titleView.layoutMarginsGuide.rightAnchor).isActive = true
		
		
		self.m_scrollView.leadingAnchor.constraint(equalTo: self.m_safeArea.leadingAnchor).isActive =  true
		self.m_scrollView.trailingAnchor.constraint(equalTo: self.m_safeArea.trailingAnchor).isActive =  true
		self.m_scrollView.topAnchor.constraint(equalTo: self.m_titleView.bottomAnchor).isActive =  true
		self.m_scrollView.bottomAnchor.constraint(equalTo: self.m_safeArea.bottomAnchor).isActive =  true
		
	
		self.m_stackView.leadingAnchor.constraint(equalTo: self.m_scrollView.leadingAnchor).isActive =  true
		self.m_stackView.trailingAnchor.constraint(equalTo: self.m_scrollView.trailingAnchor).isActive =  true
		self.m_stackView.topAnchor.constraint(equalTo: self.m_scrollView.topAnchor).isActive =  true
		self.m_stackView.bottomAnchor.constraint(equalTo: self.m_scrollView.bottomAnchor).isActive =  true
		
		//self.m_stackView.widthAnchor.constraint(equalTo:self.view.widthAnchor).isActive = true

//		self.m_label.leftAnchor.constraint(equalTo: self.m_scrollView.leftAnchor).isActive =  true
//		self.m_label.rightAnchor.constraint(equalTo: self.m_scrollView.rightAnchor).isActive =  true
//		self.m_label.topAnchor.constraint(equalTo: self.m_scrollView.topAnchor).isActive =  true
//		//self.m_label.bottomAnchor.constraint(equalTo: self.m_scrollView.bottomAnchor).isActive =  true
		self.m_label.backgroundColor = .white
		
		self.m_stackView.addArrangedSubview(self.m_label)
	}
	
	@objc func backAction(_ send:UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func clearAction(_ send:UIButton) {
		log_msg.removeAll()
		self.m_label.text = log_msg
	}
	
	
	
}
