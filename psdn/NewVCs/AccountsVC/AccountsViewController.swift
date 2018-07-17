//
//  AccountsViewController.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Presentr
import NVActivityIndicatorView

class AccountsViewController: baseViewController,NVActivityIndicatorViewable {

    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = false
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.light
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.datasource = AccountsDataSource()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Fetching Data...", messageFont: UIFont(name: "Lato-Medium", size: 20), type: NVActivityIndicatorType(rawValue: 4), color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .black, textColor: .white)
        
            let instance = Service.sharedInstance
            RealmDBManager.sharedInstance.printDbPath()
            instance.synchroniseDatabaseWithBlockchain()
        


        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Data Fetched...")
        }
//
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.stopAnimating()
        }

        
        
        
     
        setupNavBar()
        self.view.backgroundColor = .white
    
       
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
      
    }
    
    func setupNavBar() {
        
        // TODO Add plus icon Still blurry
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(AccountsViewController.goToSettings), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AccountsViewController.addNewAccount))
        addBarButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = addBarButton
    }

    @objc func goToSettings() {
        let vc = SettingsViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func addNewAccount() {
        let popup = PopupVC(nibName: nil, bundle: nil)
        popup.controller = self
        customPresentViewController(presenter, viewController: popup, animated: true, completion: nil)
       
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: transCellView.width, height: transCellView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeViewController = HomeVC(nibName: nil, bundle: nil)
        
        guard let account = datasource?.item(indexPath) as? RealmModel_Account else {return}
        
        
        homeViewController.address = account.address
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
