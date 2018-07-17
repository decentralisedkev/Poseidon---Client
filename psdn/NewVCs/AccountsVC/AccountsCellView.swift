//
//  psdnAccountsCellView.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift

class AccountsCellView: baseViewCell {
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.backgroundColor = mainBGColor.withAlphaComponent(0.7)
            }
            else
            {
                self.backgroundColor = mainBGColor
            }
        }
    }
    
    override var datasourceItem: Any? {
        didSet {
            guard let account = datasourceItem as? RealmModel_Account else {return}
            nameLabel.text = account.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = mainBGColor
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 1.0
        print("Hello")
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Medium", size: 23)
        label.textColor = .white
        label.text = "No Name"
        return label
    }()
    
    
    override func setupViews() {
        setupNameLabel()
    }
    
    func setupNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
