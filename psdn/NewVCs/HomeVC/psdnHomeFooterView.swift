//
//  psdnFooterView.swift
//  psdn
//
//  Created by BlockChainDev on 23/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

class HomeFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var height: CGFloat {
        return 120
    }
    
    class var width: CGFloat {
        return UIScreen.main.nativeBounds.width
    }

    func setupMainView() {
        self.backgroundColor = .white
    }
    func setupViews() {
        setupMainView()
        setupClaim()
    }
    func setupClaim() {
        var cb = UIButton()
        
        
        cb.titleLabel?.font = UIFont(name: "Lato-Light", size: 35.0)
        
        cb.setTitle("Claim ", for: .normal)
        cb.setTitleColor(UIColor.white, for: UIControlState.normal)
        cb.layer.cornerRadius = 8
        cb.backgroundColor = claimBGColor
        self.addSubview(cb)
        cb.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(HomeFooterView.height - CGFloat(20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
