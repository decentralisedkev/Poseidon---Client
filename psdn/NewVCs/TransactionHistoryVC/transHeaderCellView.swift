//
//  transHeaderCell.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

class transHeaderCellView: baseViewCell {
    
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = "$34,890.90"
        label.textAlignment = .center
        
        label.font = UIFont(name: "Lato-Bold", size: 64)
        label.textColor = mainBGColor
        return label
    }()
    
    override var datasourceItem: Any? {
        didSet {
            guard let str = datasourceItem as! String? else {return}
            priceLabel.text = str
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPriceLabel()
        self.backgroundColor = .white
        
    }
    
    override class var identifier: String {
        return String(describing: self)
    }
    
    override class var height: CGFloat {
        return 200
    }
    
    override class var width: CGFloat {
        return UIScreen.main.nativeBounds.width
    }
    func setupPriceLabel(){
        self.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            //            make.top.equalTo(self.snp.top).offset(0)
            make.width.equalToSuperview()
            make.height.equalTo(transHeaderCellView.height)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


