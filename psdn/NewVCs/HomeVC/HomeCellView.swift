//
//  psdnCellView.swift
//  psdn
//
//  Created by BlockChainDev on 23/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift

class HomeCellView: baseViewCell {
    
    lazy var symbolLabel : UILabel = UILabel()
    lazy var coinPriceLabel : UILabel = UILabel()
    lazy var nameLabel : UILabel = UILabel()
    

    override var datasourceItem: Any? {
        didSet {
            guard let results = datasourceItem as? Results<RealmModel_Transaction> else {return}
            if results[0].asset?.type != "NEP5" {
                
                processTransactions(type: "UTXOBASED", results)
            } else {
                processTransactions(type: "NEP5", results)
            }
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
        self.symbolLabel.text = "NEO"
        self.coinPriceLabel.text = "250 Neo"
        self.nameLabel.text  = "Not trading"
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupViews() {
        setupMainView()
        setupSymbolLabel()
        setupNameLabel()
        setupCoinPriceLabel()
    }
    
    func setupMainView() {
        
        self.backgroundColor = mainBGColor
        self.layer.opacity = 0.1
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = false
        
        
    }
    
    func setupSymbolLabel() {
        self.contentView.addSubview(symbolLabel)
        
        symbolLabel.textColor = .white
        symbolLabel.font = UIFont(name: "Lato-Medium", size: 18)
        symbolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.left.equalTo(self.snp.left).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
    }
    
    func setupNameLabel() {
        self.contentView.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Lato-Thin", size: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.symbolLabel)
            make.top.equalTo(symbolLabel.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
    }

    func setupCoinPriceLabel() {
        coinPriceLabel.textAlignment = .right
        coinPriceLabel.textColor = .white
        coinPriceLabel.font = UIFont(name: "Lato-Light", size: 18)
        self.contentView.addSubview(coinPriceLabel)
        coinPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-23)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
    }
    
}

extension HomeCellView {
    
    
    func processTransactions(type: String, _ results : Results<RealmModel_Transaction>) {
        
        
        guard let name = results[0].asset?.name else {return}
        guard let symbol = results[0].asset?.symbol else {return}
        
        var total : Double = 0
        
        if type == "NEP5" {
            total = sumNEP5Transactions(results: results)
            
        } else {
            total = sumUTXOBasedTransaction(results: results)
            
        }
        self.coinPriceLabel.text = String(describing: total) + " " + symbol
        self.nameLabel.text = name
        self.symbolLabel.text = symbol
    }
}

