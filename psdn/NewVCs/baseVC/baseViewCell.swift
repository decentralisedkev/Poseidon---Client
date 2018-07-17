//
//  baseViewCell.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit


open class baseViewCell: UICollectionViewCell {
    
    open var datasourceItem: Any?
    open weak var controller: baseViewController?
    
    var standardLabel : UILabel = UILabel()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var height: CGFloat {
        return 90
    }
    
    class var width: CGFloat {
        return 200
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        print("DATA")
        super.init(frame: frame)
        setupViews()
        
        let array = [UIColor.red, UIColor.green, UIColor.blue]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        
        self.backgroundColor = array[randomIndex]

    }
    
    
    open func setupViews() {
        self.addSubview(standardLabel)
        standardLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
