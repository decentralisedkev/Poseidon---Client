//
//  PopupVC.swift
//  psdn
//
//  Created by BlockChainDev on 27/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class PopupVC: UIViewController,NVActivityIndicatorViewable {

    var controller : AccountsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
    
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
        textField.becomeFirstResponder()
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 30)
        label.textAlignment = .center
        label.text = "New Account"
        label.textColor = .black
        return label
    }()
    
    let textField : SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField(frame: .zero)
        tf.placeholder = "Please Enter Account Name"
        tf.title = "Account Name"
        tf.tintColor = mainBGColor
        tf.selectedTitleColor = mainBGColor
        tf.selectedLineColor = .clear
       return tf
    }()

}

extension PopupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let input = textField.text {
            if input.count > 0 && input.count < 10  {
                addAccount(input)
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
    func addAccount(_ accountName : String) {
        
        let wallet = WalletManager.sharedInstance
        let currentIndex = WalletManager.sharedInstance.GetCurrentPathIndex()
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Creating New Address...", messageFont: UIFont(name: "Lato-Medium", size: 20), type: NVActivityIndicatorType(rawValue: 4), color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .black, textColor: .white)
        
        
        // Add Progress bar here
        wallet.GetMnemonic { (seed) in
            if let seed = seed {
                
                DispatchQueue.main.async {
                    let address = wallet.AddNewAddress(mnemonic: seed, Change: 0, Index: currentIndex, name: accountName,network: "TestNet")
                    self.dismiss(animated: false, completion: nil)
                    self.controller?.datasource = AccountsDataSource()
                    
                    self.stopAnimating()
                }

                //End Progress bar here
            }
        }
    }
}
