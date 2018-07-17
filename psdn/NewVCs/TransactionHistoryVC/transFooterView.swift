//
//  transFooterView.swift
//  psdn
//
//  Created by BlockChainDev on 24/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Presentr
import RealmSwift

class transFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupViews()
    }
    
    var topSpacing : CGFloat = 10
    var leftSpacing : CGFloat = 10
    var middleSpacing : CGFloat = 10
    
     var sendButton = UIButton()
     var receiveButton = UIButton()
    
    var controller : transHistoryVC?
    var address : String?
    
    var transactions : Results<RealmModel_Transaction>!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var height: CGFloat {
        return 60
    }
    
    class var width: CGFloat {
        return UIScreen.main.nativeBounds.width
    }
    
    func setupMainView() {
        self.backgroundColor = .white
    }
    func setupViews() {
        setupMainView()
        setupSendButton()
        setupReceiveButton()
    }
    
    let presenter: Presentr = {
        
        let customPresenter = Presentr(presentationType: .bottomHalf)
        
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = false
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.dark
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()

    let sendPresenter: Presentr = {
        let presenter = Presentr(presentationType: .bottomHalf)
        presenter.transitionType = .coverVertical
        presenter.dismissTransitionType = .crossDissolve
        presenter.keyboardTranslationType = .moveUp
        return presenter
    }()
    
    func setupSendButton() {
       
        
        sendButton.addTarget(self, action:#selector(showSendVC), for: .touchUpInside)
        sendButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        sendButton.backgroundColor = UIColor(red: 60, green: 59, blue: 137)
        self.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-topSpacing)
            make.left.equalTo(self.snp.left).offset(leftSpacing)
            make.width.equalTo(self.snp.width).multipliedBy(0.5).offset(-2 * leftSpacing)
            make.top.equalToSuperview().offset(topSpacing)
        }
    }
    
    func setupReceiveButton() {
        receiveButton.addTarget(self, action:#selector(showQR), for: .touchUpInside)
        self.addSubview(receiveButton)
        receiveButton.backgroundColor = UIColor(red: 60, green: 59, blue: 137)
        receiveButton.setTitle("Receive", for: .normal)
        receiveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        receiveButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 14.0)
        receiveButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-leftSpacing)
            make.top.equalTo(sendButton.snp.top)
            make.bottom.equalTo(sendButton.snp.bottom)
            make.width.equalTo(self.snp.width).multipliedBy(0.5).offset(-2 * leftSpacing)
        }
    }
    
    @objc func showQR(){
        // TODO: Settings not implemented yet
        
        let popup = QRCodePopupViewController(nibName: nil, bundle: nil)
        popup.address = self.address
        
        controller?.customPresentViewController(presenter, viewController: popup, animated: true, completion: nil)
        
    }

    @objc func showSendVC(){
        // TODO: Settings not implemented yet
        
        let popup = SendVC(transactions)
        
        controller?.customPresentViewController(sendPresenter, viewController: popup, animated: true, completion: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

