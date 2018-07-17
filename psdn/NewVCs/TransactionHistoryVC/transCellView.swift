//
//  psdnTransactionHistoryCellView.swift
//  psdn
//
//  Created by BlockChainDev on 24/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

import UIKit
import RealmSwift

struct transCellItem {
    var type : String
    var amount : String
    var blockNumber : String
    var txid : String
}

class transCellView: baseViewCell {
    
    lazy var typeLabel : UILabel = UILabel()
    lazy var amountLabel : UILabel = UILabel()
    lazy var blockNumberLabel : UILabel = UILabel()
    
    override var datasourceItem: Any? {
        didSet {
            guard let data = datasourceItem as? transCellItem else{return}
            self.typeLabel.text = data.type
            if data.type == "Received" {
                self.amountLabel.textColor = transactionReceivedColor
            } else {
                self.amountLabel.textColor = transactionSentColor
            }
            self.amountLabel.text = data.amount
            self.blockNumberLabel.text  = data.blockNumber
        }
    }
    
    override class var identifier: String {
        return String(describing: self)
    }
    
    override class var height: CGFloat {
        return 90
    }
    
    override class var width: CGFloat {
        return 200
    }
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        setupMainView()
        setuptypeLabel()
        setupblockNumberLabel()
        setupamountLabel()
    }
    
    func setupMainView() {
        
        self.backgroundColor = mainBGColor
        self.layer.opacity = 0.1
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = false
        
        
    }
    
    func setuptypeLabel() {
        self.contentView.addSubview(typeLabel)
        
        typeLabel.textColor = .white
        typeLabel.font = UIFont(name: "Lato-Medium", size: 18)
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.left.equalTo(self.snp.left).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
    }
    
    func setupblockNumberLabel() {
        self.contentView.addSubview(blockNumberLabel)
        blockNumberLabel.textColor = .white
        blockNumberLabel.font = UIFont(name: "Lato-ThinItalic", size: 16)
        blockNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.typeLabel)
            make.top.equalTo(typeLabel.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
    }
    
    func setupamountLabel() {
        amountLabel.textAlignment = .right
        amountLabel.textColor = .white
        amountLabel.font = UIFont(name: "Lato-Light", size: 18)
        self.contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-23)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
    }
    
}



