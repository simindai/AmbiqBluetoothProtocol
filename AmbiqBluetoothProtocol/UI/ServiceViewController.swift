//
//  ServiceViewController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/23/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class ServiceViewController: UIViewController, ServiceTitleViewDelegate,MenuViewDelegate, CharacteristicDelegate,  UITableViewDelegate,  UITableViewDataSource{
	
	

	var m_titleView:ServiceTitleView!
	var m_tableView:UITableView!
	var m_menuView:MenuView!
	var m_safeArea:UILayoutGuide!
	var m_constraint = sConstraint()
	var m_peripheral:CBPeripheral!
	var m_delegate:ServiceDelegate!
	var m_characteristicControler:CharacteristicController?
	
	init(delegate:ServiceDelegate, periapheral:CBPeripheral)
    {
		self.m_peripheral = periapheral
		self.m_delegate = delegate
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	struct constantsFontColor
	{
	}

    struct sConstraint
    {
		var titleViewHeightFrac:CGFloat = 0.0
		var menuViewHeightFrac:CGFloat = 0.0
    }
    
	
	override func viewDidLoad() {
	    super.viewDidLoad()
		self.view.backgroundColor = .white
		self.m_safeArea = self.view.layoutMarginsGuide
		setup()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//setup()
	}
	
	func setup(){
		self.init_constraints()
		self.add_control()
		self.setupTitleView()
		self.setupTableView()
		self.setupMenuView()
		NotificationCenter.default.addObserver(self, selector: #selector(self.launchCharacteristicView(_:)), name:Notification.Name.didDiscoverCharateristic, object: nil)
	}
	
	
	
	private func init_constraints(){
		self.m_constraint.titleViewHeightFrac = 0.1
		self.m_constraint.menuViewHeightFrac = 0.1
	}
	
	private func add_control(){
		self.m_titleView  = ServiceTitleView(delgate: self.m_delegate,serviceTitleViewDelegate:self,p: self.m_peripheral)
		self.m_tableView = UITableView()
		self.m_menuView = MenuView(delegate: self)
		self.m_menuView.disableClientButton()
		self.m_menuView.disableServerButton()
		self.view.addSubview(self.m_titleView)
		self.view.addSubview(self.m_tableView)
		self.view.addSubview(self.m_menuView)
	}
	
	private func setupTitleView(){
		self.m_titleView.translatesAutoresizingMaskIntoConstraints = false
		self.m_titleView.topAnchor.constraint(equalTo: self.m_safeArea.topAnchor).isActive = true
		self.m_titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.m_titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.m_titleView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: self.m_constraint.titleViewHeightFrac).isActive = true
	}
	
	private func setupTableView(){
		self.m_tableView.translatesAutoresizingMaskIntoConstraints = false
		self.m_tableView.topAnchor.constraint(equalTo: self.m_titleView.bottomAnchor).isActive = true
		self.m_tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		self.m_tableView.bottomAnchor.constraint(equalTo: self.m_menuView.topAnchor).isActive = true
		self.m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.m_tableView.delegate = self
		self.m_tableView.dataSource = self
	}
	
	func setupMenuView(){
		self.m_menuView.translatesAutoresizingMaskIntoConstraints = false
		self.m_menuView.bottomAnchor.constraint(equalTo:self.m_safeArea.bottomAnchor).isActive = true
		self.m_menuView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: 0.1).isActive = true
		self.m_menuView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_menuView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let s = self.m_peripheral.services{
			return s.count + 1
		}
		else {  return 1  }
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if cell.detailTextLabel == nil{
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.textColor = UIColor.gray
			if indexPath.row == 0{
				if let device_name = self.m_peripheral.name {
				    cell.textLabel?.text = "Device Name: \(device_name)"
				}
				else { cell.textLabel?.text = "Device Name: Unknown"}
				cell.detailTextLabel?.text = self.m_peripheral.identifier.uuidString
			}
			else {
				if let s = self.m_peripheral.services, s.count >= indexPath.row{
					let service = s[indexPath.row-1]
					let uuid_str = service.uuid.uuidString
					if let name = Common.KNOWN_UUID[uuid_str.lowercased()]{
						cell.textLabel?.text = name
					}
					else {
						cell.textLabel?.text = "Custom Service"
					}
					cell.detailTextLabel?.text = uuid_str
					cell.accessoryType = .disclosureIndicator
				}
			
			}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let services = self.m_peripheral.services{
			if indexPath.row > services.count{
				return
			}
			self.m_delegate.DisCharacteristic(p: self.m_peripheral, service: services[indexPath.row-1])
		
		}
	}
	func service_release(){
		DispatchQueue.main.async {
			self.m_delegate.Disconnect(p: self.m_peripheral)
			self.view.window!.layer.removeAllAnimations()
			let transition = CATransition()
			transition.duration = 0.5
			transition.type = CATransitionType.push
			transition.subtype = CATransitionSubtype.fromLeft
			transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
			self.view.window!.layer.add(transition, forKey: kCATransition)
			self.dismiss(animated: false, completion: nil)
			NotificationCenter.default.removeObserver(self)
			self.m_delegate.restoreObserver()
			
		}
	}
	
	func charateistisc_release() {
		//self.dismiss(animated: true, completion: nil)
		//self.m_characteristicControler?.view.removeFromSuperview()//
		//self.m_characteristicControler?.removeFromParent()
		//self.m_characteristicControler?.dismiss(animated: true, completion: nil)
		self.restoreObserver()
		
	}
	
	
	
	
	@objc func launchCharacteristicView(_ notification: Notification) {
	if let service = notification.object as? CBService{
		NotificationCenter.default.removeObserver(self)
		DispatchQueue.main.async {
			let transition = CATransition()
			transition.duration = 0.5
			transition.type = CATransitionType.push
			transition.subtype = CATransitionSubtype.fromRight
			transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
			if let window = self.view.window {
					window.layer.add(transition, forKey: kCATransition)
			}
//			if  self.m_characteristicControler == nil{
//				self.m_characteristicControler = CharacteristicController(delegate: self.m_delegate, characteriscDelegate: self,  periapheral: self.m_peripheral, s:service)
//			}
			let characteristicController = CharacteristicController(delegate: self.m_delegate, characteriscDelegate: self,  periapheral: self.m_peripheral, s:service)
			characteristicController.modalPresentationStyle = .fullScreen
			self.present(characteristicController, animated: false, completion: nil)
		}
	}
	
	}
	
	func restoreObserver(){
		NotificationCenter.default.addObserver(self, selector: #selector(self.launchCharacteristicView(_:)), name:Notification.Name.didDiscoverCharateristic, object: nil)
		
	}
	
	func menuClientAction() {
		return
	}
	
	func menuPeripheralAction() {
		return
	}
	
	func menuLogAction() {
		//self.m_delegate.Disconnect(p: self.m_peripheral)
		//self.dismiss(animated: false, completion: nil)
		//NotificationCenter.default.removeObserver(self)
		let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller , animated: false, completion: nil)
		

		
	}
	
}
