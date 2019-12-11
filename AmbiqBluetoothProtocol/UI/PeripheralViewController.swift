//
//  PeripheralViewController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/26/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation

import UIKit
import CoreBluetooth
// Apple peripheral don't provide advertisement interval, duration parameter setting api
// advertisement key only provide local name and service uuid
// ambiq server --
class PeripheralViewController: UIViewController, MenuViewDelegate, CBPeripheralManagerDelegate,UITableViewDelegate,  UITableViewDataSource{
	

	var m_titleLabel:UILabel!
	var m_tableView:UITableView!
	var m_menuView:MenuView!
	var m_peripheralManager: CBPeripheralManager?
	var m_ambiqService:AmbiqService!
	var m_constraint = sConstraint()
	var m_safeArea:UILayoutGuide!
	var m_deviceInfo_add = false
	var m_ambiq_add = false
	var m_receiveDataOffset = 0
	var m_receiveDataUInt8:[UInt8] = []
	var m_lastRecSerialNumber:Int = 0
	var m_receivedSerialNumber:Int = 0
	var m_receiveDataLength:Int = 0
	var m_receivedDataType = (Common.AMDTP_PKT_TYPE_UNKNOWN)
	var m_maimumDataSize = 0
	var m_sendCount:UInt8 = 0
	var m_sendSerialNumber:Int = 0
	var m_clientDelegate:ClientlDelegate!
	var m_sendDataToClient = false
	struct constantsFontColor
    {
        static let titleLabelFontIphone = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
        static let titleLabelFontIpad = UIFont(name:"HelveticaNeue-Bold", size: 22.0)!
        static let titleLabelColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		
    }
	struct sConstraint
    {
		var titleLabelFont:UIFont!
		var titleLabelHeightFrac:CGFloat = 0.0
		var menuViewHeightFrac:CGFloat = 0.0
    }
	
	init(delegate:ClientlDelegate)
    {
        super.init(nibName:nil, bundle: nil)
		self.m_clientDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Start up the CBPeripheralManager
		self.m_safeArea = self.view.layoutMarginsGuide
        m_peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
		setup()
		
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Don't keep it going while we're not showing.
        m_peripheralManager?.stopAdvertising()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setup(){
		self.init_constraints()
		self.add_control()
		self.setupTitleView()
		self.setupTableView()
		self.setupMenuView()
		self.m_ambiqService = AmbiqService()
	}
	
	
	
	private func init_constraints(){
		self.m_constraint.titleLabelHeightFrac = 0.1
		self.m_constraint.titleLabelFont = constantsFontColor.titleLabelFontIphone
		self.m_constraint.menuViewHeightFrac = 0.1
	}
	
	private func add_control(){
		self.m_titleLabel = Common.createlabel("Ambiq Blue EVB", font: self.m_constraint.titleLabelFont, color: constantsFontColor.titleLabelColor, autoSizeConstraints: false)
		self.m_tableView = UITableView()
		self.m_menuView = MenuView(delegate: self,status:MenuView.MENU_SERVER)
		self.view.addSubview(self.m_titleLabel)
		self.view.addSubview(self.m_tableView)
		self.view.addSubview(self.m_menuView)
	}
	
	private func setupTitleView(){
		self.m_titleLabel.textAlignment = .center
		self.m_titleLabel.backgroundColor = UIColor.white
		self.m_titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.m_titleLabel.topAnchor.constraint(equalTo: self.m_safeArea.topAnchor).isActive = true
		self.m_titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.m_titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.m_titleLabel.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: self.m_constraint.titleLabelHeightFrac).isActive = true
	}
	
	private func setupTableView(){
		self.m_tableView.translatesAutoresizingMaskIntoConstraints = false
		self.m_tableView.topAnchor.constraint(equalTo: self.m_titleLabel.bottomAnchor).isActive = true
		self.m_tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		self.m_tableView.bottomAnchor.constraint(equalTo: self.m_menuView.topAnchor).isActive = true
		self.m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.m_tableView.delegate = self
		self.m_tableView.dataSource = self
	}
	
	func setupMenuView(){
		self.m_menuView.backgroundColor = UIColor.white
		self.m_menuView.translatesAutoresizingMaskIntoConstraints = false
		self.m_menuView.bottomAnchor.constraint(equalTo:self.m_safeArea.bottomAnchor).isActive = true
		self.m_menuView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: 0.1).isActive = true
		self.m_menuView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_menuView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//return 0
		return self.m_ambiqService.getService().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if cell.detailTextLabel == nil{
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.textLabel?.numberOfLines = 0
		cell.detailTextLabel?.numberOfLines = 0
		cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.textColor = UIColor.gray
		let (service_str, characteristic_str) = self.m_ambiqService.getServiceStr(index: indexPath.row)
		cell.textLabel?.text = service_str
		cell.detailTextLabel?.text = characteristic_str
		return cell
	}
    func startAdvertise(){
		//print("startAdvertise")
		log_msg.appendWithTime("startAdvertise")
		_ = self.m_ambiqService.getAdvertiseUUID()
		self.m_peripheralManager?.startAdvertising([
			CBAdvertisementDataServiceUUIDsKey : [Common.AMBIQ_SERVICE_DEVICE_INFO_UUID,Common.AMBIQ_SERVICE_UUID]
				   ])
	}
	
	func stopAdvertise(){
		self.m_peripheralManager?.stopAdvertising()
	}
	
	func menuClientAction(){
		cleanup()
		self.dismiss(animated: true, completion: nil)
		self.m_clientDelegate.resume()
	}
	func menuPeripheralAction(){
		return
	}
	
	func menuLogAction() {
	//	cleanup()
		//self.dismiss(animated: true, completion: nil)
		let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller, animated: true, completion: nil)
	}
	
	func cleanup(){
		self.m_peripheralManager?.removeAllServices()
		self.m_peripheralManager?.stopAdvertising()
		self.m_receiveDataOffset = 0
		self.m_receiveDataLength = 0
		self.m_lastRecSerialNumber = 0
		self.m_receivedSerialNumber = 0
		self.m_sendSerialNumber = 0
		self.m_receiveDataUInt8.removeAll()
		self.m_maimumDataSize = 0
		self.m_sendCount = 0
		self.m_sendDataToClient = false
	}
	
   
   



}
	
	
