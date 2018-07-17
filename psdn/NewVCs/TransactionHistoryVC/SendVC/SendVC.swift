//
//  SendVC.swift
//  psdn
//
//  Created by BlockChainDev on 02/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import PageMenu
import RealmSwift

class SendVC: baseSendVC {

    var transactions : Results<RealmModel_Transaction>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller : SendAddressVC = SendAddressVC(controllerVC: self)
        controller.title = "Address" // pay with qr or paste
        let controller2 : SendAmountVC = SendAmountVC(controllerVC: self)
        controller2.title = "Amount" // numpad to enter amount, plus fees
//        var controller3 : UIViewController = UIViewController(nibName: nil, bundle: nil)
//        controller3.title = "Add NEO/GAS" // If Invocation transanction, user can add NEO/GAS with it
        let controller4 : SummaryVC = SummaryVC(controllerVC: self)
        controller4.title = "Summary"
        pages.append(contentsOf: [controller,controller2, controller4])
        
//        self.package = SendPackage()
        
        self.dataSource = self
        self.delegate   = self
        
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource = self
    }
    
    init(_ transactions : Results<RealmModel_Transaction>) {
        self.transactions = transactions
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
