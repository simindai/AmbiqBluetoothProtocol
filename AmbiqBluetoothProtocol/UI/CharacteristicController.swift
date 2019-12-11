//
//  CharacteristicController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/25/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class CharacteristicController: UIViewController, CharacteristicTitleViewDelegate, MenuViewDelegate, UITableViewDelegate,  UITableViewDataSource{
	
	
	var m_titleView:CharacteristicTitleView!
	var m_tableView:UITableView!
	var m_menuView:MenuView!
	var m_safeArea:UILayoutGuide!
	var m_constraint = sConstraint()
	var m_peripheral:CBPeripheral!
	var m_delegate:ServiceDelegate!
	var m_characteristicDelegate:CharacteristicDelegate!
	var m_rxCharacteristic:CBCharacteristic?
	
	var m_service:CBService!
	init(delegate:ServiceDelegate, characteriscDelegate:CharacteristicDelegate, periapheral:CBPeripheral, s:CBService)
	{
		self.m_peripheral = periapheral
		self.m_delegate = delegate
		self.m_service = s
		self.m_characteristicDelegate = characteriscDelegate
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
	
	func setup(){
		self.init_constraints()
		self.add_control()
		self.setupTitleView()
		self.setupTableView()
		self.setupMenuView()
		
	}
	
	private func init_constraints(){
		self.m_constraint.titleViewHeightFrac = 0.1
		self.m_constraint.menuViewHeightFrac = 0.1
	}
	
	private func add_control(){
		self.m_titleView  = CharacteristicTitleView(delgate: self.m_delegate,charateristicTitleViewDelegate:self,p: self.m_peripheral,service: self.m_service)
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
		self.m_tableView.leftAnchor.constraint(equalTo: self.m_safeArea.leftAnchor).isActive = true
		self.m_tableView.rightAnchor.constraint(equalTo: self.m_safeArea.rightAnchor).isActive = true
		self.m_tableView.bottomAnchor.constraint(equalTo: self.m_menuView.topAnchor).isActive = true
		self.m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.m_tableView.delegate = self
		self.m_tableView.dataSource = self
	}
	
	func setupMenuView(){
		self.m_menuView.translatesAutoresizingMaskIntoConstraints = false
		self.m_menuView.bottomAnchor.constraint(equalTo:self.m_safeArea.bottomAnchor).isActive = true
		self.m_menuView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: 0.1).isActive = true
		self.m_menuView.leftAnchor.constraint(equalTo: self.m_safeArea.leftAnchor).isActive = true
		self.m_menuView.rightAnchor.constraint(equalTo: self.m_safeArea.rightAnchor).isActive = true
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let characteristics = self.m_service.characteristics{
			return characteristics.count + 1
		}
		else {
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			return
		}
		if let characteristics = self.m_service.characteristics, characteristics.count >= indexPath.row{
			let characteristic = characteristics[indexPath.row-1]
			let uuid_str = characteristic.uuid.uuidString
			if uuid_str.lowercased() == Common.AMBIQ_CHARACTERISTIC_RX.uuidString.lowercased(){
				self.launchAmbiqController(rx: true, characteristic: characteristic)
			}
			else if uuid_str.lowercased() == Common.AMBIQ_CHARACTERISTIC_TX.uuidString.lowercased(), let rx = self.m_rxCharacteristic{
				self.launchAmbiqController(rx: false, characteristic: rx)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if cell.detailTextLabel == nil{
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.textColor = UIColor.gray
		cell.detailTextLabel?.numberOfLines = 0
		if indexPath.row == 0{
			let uuid_str = self.m_service.uuid.uuidString
			if let name = Common.KNOWN_UUID[uuid_str.lowercased()]{
				cell.textLabel?.text = name
			}
			else {
				cell.textLabel?.text = "Custom Service"
			}
			cell.detailTextLabel?.text = uuid_str
		}
		else {
			if let characteristics = self.m_service.characteristics, characteristics.count >= indexPath.row{
				let characteristic = characteristics[indexPath.row-1]
				var uuid_str = characteristic.uuid.uuidString
				if let name = Common.KNOWN_UUID[uuid_str.lowercased()]{
					cell.textLabel?.text = name
				}
				else {
					cell.textLabel?.text = "Custom Characteristics"
				}
				let property_str = Common.getCharacteristicPropertyStr(Characteristic: characteristic)
				uuid_str.append("\n \(property_str)")
				cell.detailTextLabel?.text = uuid_str
				if characteristic.uuid.uuidString == Common.AMBIQ_CHARACTERISTIC_RX.uuidString ||
				    characteristic.uuid.uuidString == Common.AMBIQ_CHARACTERISTIC_TX.uuidString
				{
					cell.accessoryType = .disclosureIndicator
					if characteristic.uuid.uuidString == Common.AMBIQ_CHARACTERISTIC_RX.uuidString{
						self.m_rxCharacteristic = characteristic
					}
				}
			}
		}
		return cell
	}
	
	func launchAmbiqController(rx:Bool, characteristic:CBCharacteristic){
		var rx_controller:AmbiqRxController?
		var tx_controller:AmbiqTxController?
		if rx {
			rx_controller = AmbiqRxController(delegate: self.m_delegate, peripheral: self.m_peripheral, characteristic: characteristic)
		}
		else {
			tx_controller  = AmbiqTxController(delegate: self.m_delegate, peripheral: self.m_peripheral,  characteristic: characteristic)
		}
		DispatchQueue.main.async {
			let transition = CATransition()
			transition.duration = 0.5
			transition.type = CATransitionType.push
			transition.subtype = CATransitionSubtype.fromRight
			transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
			if let window = self.view.window {
					window.layer.add(transition, forKey: kCATransition)
			}
			if let controller = rx_controller{
				controller.modalPresentationStyle = .fullScreen
				self.present(controller, animated: false, completion: nil)
			}
			if let controller = tx_controller{
				controller.modalPresentationStyle = .fullScreen
				self.present(controller, animated: false, completion: nil)
			}
		}
	}
	
	func service_release() {
		DispatchQueue.main.async {
			//self.m_characteristicDelegate.charateistisc_release()
			self.view.window!.layer.removeAllAnimations()
			let transition = CATransition()
			transition.duration = 0.5
			transition.type = CATransitionType.push
			transition.subtype = CATransitionSubtype.fromLeft
			transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
			self.view.window!.layer.add(transition, forKey: kCATransition)
			self.dismiss(animated: false, completion: nil)
			self.m_characteristicDelegate.charateistisc_release()
		}
		
	}
	
	func menuClientAction() {
		return
	}
	
	func menuPeripheralAction() {
		return
	}
	
	func menuLogAction() {
		let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller , animated: false, completion: nil)
		
	}
	


}




