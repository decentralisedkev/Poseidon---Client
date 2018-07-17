//
//  SendAmountVC.swift
//  psdn
//
//  Created by BlockChainDev on 03/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SendAmountVC: baseSendVC {

    var balance  : Double = 0
    override func viewDidLoad() {
        guard let controller = controller else {return}
        balance = getCoinTotalBalance(controller.transactions)
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
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        nextButton.isEnabled = false
        nextButton.addTarget(self, action:#selector(nextPage), for: .touchUpInside)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let input = textField.text {
            nextButton.isEnabled = true
            if let inputAsDouble = Double(input)  {
                
                if balance >= inputAsDouble {
                    baseSendVC.package.amount = input
                } else {
                    baseSendVC.package.amount = nil
                }
                
                print(inputAsDouble)
                //TODO: Need to double check that it is an address
               
            } else {
                baseSendVC.package.amount = nil
            }
        } else {
            baseSendVC.package.amount = nil
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 30)
        label.textAlignment = .center
        label.text = "Amount to send"
        label.textColor = .black
        return label
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = claimBGColor
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    let textField : SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField(frame: .zero)
        tf.keyboardType = UIKeyboardType.decimalPad
        tf.placeholder = "Please enter the amount"
        tf.title = "Amount"
        tf.tintColor = mainBGColor
        tf.selectedTitleColor = mainBGColor
        tf.selectedLineColor = .clear
        return tf
    }()
    
    @objc func nextPage() {
        if let input = textField.text {
       
            if Double(input) != nil  {
            textField.resignFirstResponder()
//            controller?.pageMenu?.moveToPage(2)
                controller?.goToNextPage()
            //TODO: Need to double check that it is an address
               
            } else {
                baseSendVC.package.amount = nil
            }
        }
        
    }

    
}
extension SendAmountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let input = textField.text {

//            controller?.pageMenu?.moveToPage(1)
            if Double(input) != nil {
                baseSendVC.package.amount = input
                

                controller?.goToNextPage()
                
                print("Input printed")
                //TODO: Need to double check that it is an address
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
}
