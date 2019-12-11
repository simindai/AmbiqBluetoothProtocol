//
//  clientTableCell.swift
//  AmbiqBluetoothProtocol
//
//  Created by app_dev on 11/19/19.
//  Copyright © 2019 app_dev. All rights reserved.
//

import Foundation
import UIKit
class ClientTableCell :UITableViewCell
{
    fileprivate var m_sigStrengthImgView:UIImageView!
    fileprivate var m_dbmLabel: UILabel!
	fileprivate var m_deviceNameLabel: UILabel!
	fileprivate var m_deviceServiceLabel: UILabel!
	
	fileprivate var m_singalLevel5Image:UIImage!
	fileprivate var m_singalLevel4Image:UIImage!
	fileprivate var m_singalLevel3Image:UIImage!
	fileprivate var m_singalLevel2Image:UIImage!
	fileprivate var m_singalLevel1Image:UIImage!
	fileprivate var m_singalLevel0Image:UIImage!
	
	fileprivate var m_constraint = sConstraint()
	struct constantsFontColor
    {
        static let dbmLabelFontIphone = UIFont(name:"Helvetica", size: 12.0)!
        static let dbmLabelFontIpad = UIFont(name:"Helvetica", size: 22.0)!
		static let deviceNameLabelFontiPhone = UIFont(name:"Helvetica", size: 16.0)!
		static let deviceNameLabelFontiPad = UIFont(name:"Helvetica", size: 22.0)!
		static let serviceNameLabelFontiPhone = UIFont(name:"Helvetica", size: 12.0)!
		static let serviceNameLabelFontiPad = UIFont(name:"Helvetica", size: 22.0)!
		static let labelColor = UIColor.black
    }
	
	struct sConstraint
    {
        var dbmLabelFont:UIFont!
		var deviceNameLabelFont:UIFont!
		var serviceLabelFont:UIFont!
        var signalImgeHeightFrac :CGFloat = 0.0
    }

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	
	public func updateLevelImg(dbm:Int){
		
		if dbm <  Common.signalConstants.LEVEL_1 || dbm >= 0{
			self.m_sigStrengthImgView.image = self.m_singalLevel0Image
		}
		else if dbm >= Common.signalConstants.LEVEL_1 && dbm < Common.signalConstants.LEVEL_2{
			self.m_sigStrengthImgView.image = self.m_singalLevel1Image
		}
		else if dbm >= Common.signalConstants.LEVEL_2 && dbm < Common.signalConstants.LEVEL_3{
			self.m_sigStrengthImgView.image = self.m_singalLevel2Image
		}
		else if dbm >= Common.signalConstants.LEVEL_3 && dbm < Common.signalConstants.LEVEL_4{
			self.m_sigStrengthImgView.image = self.m_singalLevel3Image
		}
		else if dbm >= Common.signalConstants.LEVEL_4 && dbm < Common.signalConstants.LEVEL_5{
			self.m_sigStrengthImgView.image = self.m_singalLevel4Image
		}
		else {
			self.m_sigStrengthImgView.image = self.m_singalLevel5Image
		}
	}
	
	public func updatedbmLabel(dbm:Int,color:UIColor){
		var str = "\(String(dbm))"
		if dbm >= 0 {
			str = "---"
		}
		 self.m_dbmLabel.text = str 
		//self.m_dbmLabel.textColor = color
	}
	
	public func updateDeviceNameLabel(name:String, color:UIColor){
		self.m_deviceNameLabel.text = name
		//self.m_deviceNameLabel.textColor = color
   	}
	
	public func updateServiceLabel(serviceCount:Int, color:UIColor){
		var service_str = "No Service"
		if serviceCount > 0 {
		    service_str = "\(serviceCount) Service"
		}
		self.m_deviceServiceLabel.text = service_str
		//self.m_deviceServiceLabel.textColor = color
	}
	private func setup(){
		init_image()
		init_constraints()
		add_control()
		set_constraints()
	}
	
	private func init_image(){
		self.m_singalLevel0Image = UIImage(named: "signal_level_0")
		self.m_singalLevel1Image = UIImage(named: "signal_level_1")
		self.m_singalLevel2Image = UIImage(named: "signal_level_2")
		self.m_singalLevel3Image = UIImage(named: "signal_level_3")
		self.m_singalLevel4Image = UIImage(named: "signal_level_4")
		self.m_singalLevel5Image = UIImage(named: "signal_level_5")
	}
	
	private func init_constraints(){
		self.m_constraint.dbmLabelFont = constantsFontColor.dbmLabelFontIphone
		self.m_constraint.deviceNameLabelFont = constantsFontColor.deviceNameLabelFontiPhone
		self.m_constraint.serviceLabelFont = constantsFontColor.serviceNameLabelFontiPhone
		self.m_constraint.signalImgeHeightFrac = 0.5
	}
	
	
	private func add_control(){
		self.m_sigStrengthImgView = UIImageView(image: self.m_singalLevel0Image)
		self.m_sigStrengthImgView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.m_sigStrengthImgView)
		self.m_dbmLabel = Common.createlabel("---", font: self.m_constraint.dbmLabelFont, color:constantsFontColor.labelColor , autoSizeConstraints: false)
		self.m_dbmLabel.textAlignment = .center
		self.contentView.addSubview(self.m_dbmLabel)
		self.m_deviceNameLabel = Common.createlabel("Unknown", font: self.m_constraint.deviceNameLabelFont, color:constantsFontColor.labelColor , autoSizeConstraints: false)
		self.m_deviceNameLabel.textAlignment = .center
		self.contentView.addSubview(self.m_deviceNameLabel)
		self.m_deviceServiceLabel = Common.createlabel("No Service", font: self.m_constraint.serviceLabelFont, color:constantsFontColor.labelColor , autoSizeConstraints: false)
		self.contentView.addSubview(self.m_deviceServiceLabel)
		self.m_deviceServiceLabel.textAlignment = .center
	}
	
	private func set_constraints(){
        let marginGuide = contentView.layoutMarginsGuide
		self.m_sigStrengthImgView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		self.m_sigStrengthImgView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		self.m_sigStrengthImgView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: self.m_constraint.signalImgeHeightFrac).isActive = true
		self.m_sigStrengthImgView.widthAnchor.constraint(equalTo: self.m_sigStrengthImgView.heightAnchor).isActive = true
		
		self.m_dbmLabel.topAnchor.constraint(equalTo: self.m_sigStrengthImgView.bottomAnchor).isActive = true
		self.m_dbmLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		self.m_dbmLabel.leftAnchor.constraint(equalTo: self.m_sigStrengthImgView.leftAnchor).isActive = true
		self.m_dbmLabel.rightAnchor.constraint(equalTo: self.m_sigStrengthImgView.rightAnchor).isActive = true
		self.m_deviceNameLabel.topAnchor.constraint(equalTo: self.m_sigStrengthImgView.topAnchor).isActive = true
		self.m_deviceNameLabel.bottomAnchor.constraint(equalTo: self.m_sigStrengthImgView.bottomAnchor).isActive = true
		self.m_deviceNameLabel.leftAnchor.constraint(equalTo: self.m_sigStrengthImgView.rightAnchor).isActive = true
		self.m_deviceNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true

		self.m_deviceServiceLabel.topAnchor.constraint(equalTo: self.m_deviceNameLabel.bottomAnchor).isActive = true
		self.m_deviceServiceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		self.m_deviceServiceLabel.leftAnchor.constraint(equalTo: self.m_dbmLabel.rightAnchor).isActive = true
		self.m_deviceServiceLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
	}
	
	func updateCell(name:String, dbm:Int, serviceCount:Int){
		print("name: \(name) \(dbm)")
		let color = UIColor.black
		if dbm >= 0 {
//			color = UIColor.gray
			self.selectionStyle = .none
			self.m_dbmLabel.isEnabled = false
			self.m_deviceNameLabel.isEnabled = false
			self.m_deviceServiceLabel.isEnabled = false
			
		}
		else{
			self.selectionStyle = .default
			self.m_dbmLabel.isEnabled = true
			self.m_deviceNameLabel.isEnabled = true
			self.m_deviceServiceLabel.isEnabled = true
		}
		
		self.updatedbmLabel(dbm: dbm, color:color)
		self.updateDeviceNameLabel(name: name,color:color)
		self.updateLevelImg(dbm: dbm)
		self.updateServiceLabel(serviceCount: serviceCount,color:color)
	}
	
    



}

