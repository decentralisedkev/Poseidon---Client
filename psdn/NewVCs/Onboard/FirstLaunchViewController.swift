//
//  FirstLaunchViewController.swift
//  psdn
//
//  Created by BlockChainDev on 11/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Hello
import SnapKit
import LocalAuthentication
import EllipticCurveKeyPair
import KeychainSwift
/*
 
 Upon first launch, the user will not have a mnemonic and will not have been through the onboarding process
 
 - Create mnemonic
 - Onboardin process
 
 */

class FirstLaunchViewController: UIViewController {
    
    let newWalletButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 24.0)
        
        button.setTitle("Create a new wallet ", for: .normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = mainBGColor
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        setupNewWalletButton()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupMainView() {
        self.view.backgroundColor = .white
    }
    
    func setupNewWalletButton() {
        self.view.addSubview(newWalletButton)
        newWalletButton.snp.makeConstraints { (make) -> Void in
            make.leftMargin.equalTo(self.view.snp.leftMargin).offset(0.5)
            make.rightMargin.equalTo(self.view.snp.rightMargin).offset(-0.5)
            make.height.equalTo(86)
            make.center.equalTo(self.view)
        }
        newWalletButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    @objc func buttonAction(sender: UIButton!) {

        let NeoWalletManager = WalletManager.sharedInstance
        let result = NeoWalletManager.NewWallet()
        if result {
            print("New Wallet was created")
        }
            let homeViewController = NavViewController(rootViewController: AccountsViewController())
            self.present(homeViewController, animated: true, completion: nil)

    }
    

    
}
