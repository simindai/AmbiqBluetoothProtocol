//
//  ViewController.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/18/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import UIKit

var log_msg:String = "log:\n"
var log_delegate:LogDelegate?
class ViewController: UIViewController,ClientlDelegate,CentralManagerDelegate,ServiceDelegate, MenuViewDelegate, LogDelegate,UITableViewDataSource,UITableViewDelegate{
	
	

	var m_titleView :TitleView!
	let m_tableView = UITableView()
	var m_peripheral_label :UILabel!
	var m_menuView:MenuView!
	var m_safeArea:UILayoutGuide!
	var m_tableViewCellHeight:CGFloat!
	var m_constraint = sConstraint()
	var m_client:Client!
	var m_ConnectView:ConnectView!
	var m_blackView:UIView!
	var m_timer:Timer?
	var m_connectTimer:Timer?
	var m_peripheralController:PeripheralViewController?
	var m_name = ["peripheral_1", "peripheral_2", "peripheral_3", "peripheral_4", "peripheral_5"]
	let MINIMUM_TABLE_VIEW_CELL_HEIGHT:CGFloat = 40.0
	var m_serviceController:ServiceViewController?
	struct constantsFontColor
    {
        static let pLabelFontIphone = UIFont(name:"Helvetica", size: 16.0)!
        static let pLabelFontIpad = UIFont(name:"Helvetica", size: 22.0)!
		static let pLabelBGColor = UIColor(red: 0/255, green: 168/255, blue: 236/255, alpha: 1.0)
		static let pLabelTitleColor = UIColor.white
    }
	
	struct sConstraint{
		var cell_height_frac:CGFloat = 0.0
		var connenct_view_height_offset :CGFloat = 0.0
		var connect_view_height_fract:CGFloat = 0.0
		
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.m_client = Client(cmDelegate: self)
		self.m_ConnectView.clipsToBounds = true
		self.m_ConnectView.layer.cornerRadius = 10.0
		self.m_ConnectView.startAnimate()
	}
	override func loadView() {
		super.loadView()
		view.backgroundColor = .white
		self.m_safeArea = self.view.layoutMarginsGuide
		setupView()
		
		self.m_tableViewCellHeight =  (Common.deviceConstants.screenHeight) / (m_constraint.cell_height_frac)
        if( m_tableViewCellHeight <  MINIMUM_TABLE_VIEW_CELL_HEIGHT ) {
            m_tableViewCellHeight = MINIMUM_TABLE_VIEW_CELL_HEIGHT
        }
		log_delegate = self
	}
	
	
	func setupView(){
		init_constraint()
		addControls()
		self.setupTitleView()
		self.self.setupPeripheralLabelView()
		self.setupTableView()
		self.setupMenuView()
		self.addBlackView()
		self.setupConnectView()
	    self.m_ConnectView.isHidden = true
		self.m_blackView.isHidden = true
		self.addObserver()
	}
	
//	@objc private func enterBackGround(){
////		if self.m_titleView.isScanned(){
////			self.stopScan()
////		}
////		self.m_client.cleanup()
////		NotificationCenter.default.removeObserver(self)
//	}
//
//	@objc private func enterForeGround(){
////		if self.m_titleView.isScanned(){
////			self.scan()
////		}
////		self.addObserver()
//	}
	
	
	private func addControls(){
		self.m_titleView = TitleView(delgate: self)
		self.view.addSubview(self.m_titleView)
		self.m_peripheral_label = Common.createlabel("Nearby Peripheral Devices", font: constantsFontColor.pLabelFontIphone, color: constantsFontColor.pLabelTitleColor, autoSizeConstraints: false)
		self.m_menuView = MenuView(delegate: self)
		self.view.addSubview(self.m_peripheral_label)
		self.view.addSubview(self.m_tableView)
		self.view.addSubview(self.m_menuView)
	}
	private func init_constraint(){
		self.m_constraint.cell_height_frac = 10
		self.m_constraint.connenct_view_height_offset = -70.0
		self.m_constraint.connect_view_height_fract = 0.15
	
	}
	
	func setupConnectView(){
		//self.m_ConnectView = ConnectView()
		//self.view.addSubview(self.m_ConnectView)
		self.m_ConnectView.translatesAutoresizingMaskIntoConstraints = false
		self.m_ConnectView.centerXAnchor.constraint(equalTo: self.m_safeArea.centerXAnchor).isActive = true
		self.m_ConnectView.centerYAnchor.constraint(equalTo: self.m_safeArea.centerYAnchor, constant: self.m_constraint.connenct_view_height_offset).isActive = true
		self.m_ConnectView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: self.m_constraint.connect_view_height_fract).isActive = true
		self.m_ConnectView.widthAnchor.constraint(equalTo: self.m_ConnectView.heightAnchor, multiplier: 1.0).isActive = true
	}
	
	func addBlackView(){
		
		self.m_blackView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
		self.m_blackView.backgroundColor = UIColor.white
		self.m_blackView.alpha = 0.75 // Change the alpha depending on how much transparency you require
		self.view.addSubview(self.m_blackView)
		self.m_ConnectView = ConnectView()
		self.m_ConnectView.backgroundColor = UIColor.black
		self.m_blackView.addSubview(self.m_ConnectView)
		
	}
	func setupTitleView(){
		
		self.m_titleView.translatesAutoresizingMaskIntoConstraints = false
		self.m_titleView.topAnchor.constraint(equalTo: self.m_safeArea.topAnchor).isActive = true
		self.m_titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.m_titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.m_titleView.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: 0.05).isActive = true
		
	}
	
	func setupPeripheralLabelView(){
		
		self.m_peripheral_label.textAlignment = .center
		self.m_peripheral_label.backgroundColor = constantsFontColor.pLabelBGColor
		self.m_peripheral_label.topAnchor.constraint(equalTo: self.m_titleView.bottomAnchor).isActive = true
		self.m_peripheral_label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_peripheral_label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		self.m_peripheral_label.heightAnchor.constraint(equalTo: self.m_safeArea.heightAnchor, multiplier: 0.05).isActive = true
	}
	func setupTableView(){
		
		self.m_tableView.translatesAutoresizingMaskIntoConstraints = false
		self.m_tableView.topAnchor.constraint(equalTo: self.m_peripheral_label.bottomAnchor).isActive = true
		self.m_tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		self.m_tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		self.m_tableView.bottomAnchor.constraint(equalTo: self.m_menuView.topAnchor).isActive = true
		self.m_tableView.register(ClientTableCell.self, forCellReuseIdentifier:NSStringFromClass(ClientTableCell.self) )
		//self.m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
		return self.m_client.getPeriheralDeviceCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ClientTableCell.self), for: indexPath) as! ClientTableCell
		cell.accessoryType = .disclosureIndicator
		let (name, dbm, service_count) = self.m_client.getPeripheralData(index: indexPath.row)
		cell.updateCell(name: name, dbm: dbm, serviceCount: service_count)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.m_tableViewCellHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row > self.m_client.getPeriheralDeviceCount() - 1{
			return
		}
		let (_, _, _ ) = self.m_client.getPeripheralData(index: indexPath.row)
		
		self.m_blackView.isHidden = false
		self.m_ConnectView.isHidden = false
		self.m_ConnectView.startAnimate()
		if self.m_connectTimer == nil {
			self.m_connectTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(self.connectTick), userInfo: nil, repeats: true)
		}
		self.m_client.connectPeripheral(index: indexPath.row)
	}
	
	
	@objc func connectTick() {
		self.m_blackView.isHidden = true
		self.m_ConnectView.isHidden = true
		self.m_ConnectView.stopAnmiate()
		self.m_connectTimer?.invalidate()
		self.m_connectTimer = nil
		let alert = UIAlertController(title: "Alert", message: "Time out for connection", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func menuClientAction() {
		return
	}
	
	func menuPeripheralAction() {
		self.m_client.cleanup()
		self.stopScan()
		NotificationCenter.default.removeObserver(self)
	    launchPeripheralController()
	}
	
	func menuLogAction() {
		//self.m_client.cleanup()
		//	self.stopScan()
		//NotificationCenter.default.removeObserver(self)
	    let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller , animated: false, completion: nil)
	}
	func resume(){
		if self.m_titleView.isScanned(){
		    self.scan()
		}
		self.addObserver()
	}
	
	func addObserver(){
		NotificationCenter.default.addObserver(self, selector: #selector(self.launchServiceView), name:Notification.Name.didDiscoverService, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.updateRssi), name:Notification.Name.didReadRSSI, object: nil)
		//NotificationCenter.default.addObserver(self, selector: #selector(self.enterBackGround), name: UIApplication.willResignActiveNotification, object: nil)
		//NotificationCenter.default.addObserver(self, selector: #selector(self.enterForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
	}
	func launchPeripheralController() {
		let peripheralController = PeripheralViewController(delegate: self)
		peripheralController.modalPresentationStyle = .fullScreen
		self.present(peripheralController, animated: false, completion: nil)
		
	}
	
	func lanuchClientController() {
		resume()
	}
	
	func lanuchLogController(isBack:Bool) {
	    let log_controller = LogViewController()
		log_controller.modalPresentationStyle = .fullScreen
		self.present(log_controller , animated: false, completion: nil)
	}
	
	
	
	
}

