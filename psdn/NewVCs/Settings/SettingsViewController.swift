//
//  AnotherViewController.swift
//  psdn
//
//  Created by BlockChainDev on 11/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let label : UILabel = {
       let label = UILabel()
  
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont(name: "Lato-Medium", size: 35)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wallet = WalletManager.sharedInstance
        wallet.GetMnemonic { (seed) in
            if let seed = seed {
                DispatchQueue.main.async {
                    self.label.text = "Recovery Phrase:\n\n"+seed
                }
                
            }
        }
        self.view.backgroundColor = .white
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(300)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
