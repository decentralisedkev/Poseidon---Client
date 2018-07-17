//
//  homeVC.swift
//  psdn
//
//  Created by BlockChainDev on 22/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Presentr

class HomeVC: baseViewController {
    
    var footerView : HomeFooterView = HomeFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var address : String?
    
    private let refreshControl = UIRefreshControl()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFooterView()
        setupCollectionView()
        setupNavBar()
        setupMainView()
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl.tintColor = mainBGColor
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
    }
    @objc func refreshData() {
        let service = Service.sharedInstance
        guard let address = address else {self.refreshControl.endRefreshing();return}
        service.fetchOutputsAndSaveInDatabase(address: address) { (success) in
            if success {
                
                
                // update the spent utxos
                service.checkForSpentUTXOs()
                 service.fetchAndSaveTokenTransactionHistory(address: address)
                 self.loadData()
                 self.refreshControl.endRefreshing()
                
            } else {
                print("We failed")
                self.refreshControl.endRefreshing()
            }
        }
       
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        if let address = self.address {
            self.datasource = HomeDataSource(address) //TODO: this is slow, prefetch would solve
        }
    }
    func setupCollectionView() {
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
       
        collectionView?.backgroundColor = UIColor.white
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.footerView.snp.top)
        }

    }
    
    @objc func showQR(){
        
        let popup = QRCodePopupViewController(nibName: nil, bundle: nil)
        popup.address = self.address
        customPresentViewController(presenter, viewController: popup, animated: true, completion: nil)
        
    }
    
    func setupFooterView() {
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(HomeFooterView.height)
        }
    }
    
    func setupNavBar() {
let addBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "qr"), style: .plain, target: self, action: #selector(HomeVC.showQR))
//        let addBarButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(HomeVC.showQR))
        addBarButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = addBarButton
        
        //TODO: icon looks blurry to me
    }
    
    func setupMainView(){
        self.view.backgroundColor = .white
    }
}
extension HomeVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = transHistoryVC(datasource?.item(indexPath))
        print(RealmDBManager.sharedInstance.printDbPath())
        navigationController?.pushViewController(vc, animated: true)
    }
}
