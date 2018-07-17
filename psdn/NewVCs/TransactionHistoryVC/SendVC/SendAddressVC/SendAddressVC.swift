//
//  SendAddressVC.swift
//  psdn
//
//  Created by BlockChainDev on 03/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class SendAddressVC: baseSendVC {
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
        textField.delegate = self

    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 30)
        label.textAlignment = .center
        label.text = "Pay To"
        label.textColor = .black
        return label
    }()
    
    let textField : SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField(frame: .zero)
        tf.placeholder = "Please enter the recipients address"
        tf.title = "Recipients Address"
        tf.tintColor = mainBGColor
        tf.selectedTitleColor = mainBGColor
        tf.selectedLineColor = .clear
        return tf
    }()
    
    
}

extension SendAddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let input = textField.text {
            baseSendVC.package.toAddress = input
//            controller?.pageMenu?.moveToPage(1)
            controller?.goToNextPage()
            if input.count == 20  {
                baseSendVC.package.toAddress = input
                //TODO: Need to double check that it is an address
                textField.resignFirstResponder()
            }
        }
        return false
}
}
