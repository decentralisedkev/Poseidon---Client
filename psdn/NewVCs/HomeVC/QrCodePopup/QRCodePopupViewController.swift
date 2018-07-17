//
//  QRCodePopupViewController.swift
//  psdn
//
//  Created by BlockChainDev on 27/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import QRCode

class QRCodePopupViewController: UIViewController {

    var address : String?{
        didSet {
            addressLabel.text = address
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.backgroundColor = mainBGColor.withAlphaComponent(0.2)
        // Do any additional setup after loading the view.
        self.view.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalToSuperview().offset(10)
        }
        var qrCode = QRCode(address!)
        qrCode?.size = CGSize(width: 200, height: 200)
        qrImageView.image = qrCode?.image
        
        self.view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qrImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(60)
        }
        
        UIPasteboard.general.string = address
    }
    let addressLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Lato-Thin", size: 25)
        label.textColor = .white
        return label
    }()
    
    let qrImageView : UIImageView = {
        let imgvw = UIImageView()
        imgvw.backgroundColor = .red
        return imgvw
    }()
    
}
