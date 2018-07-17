//
//  HomeViewController.swift
//  psdn
//
//  Created by BlockChainDev on 09/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit


class NavViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        
    }
    
    func setupMainView() {
        self.view.backgroundColor = mainBGColor
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = mainBGColor
        self.navigationBar.isTranslucent = false
       
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    
}
