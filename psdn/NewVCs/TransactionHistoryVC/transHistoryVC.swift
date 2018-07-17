//
//  TransactionsHistoryVC.swift
//  psdn
//
//  Created by BlockChainDev on 24/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Presentr
import RealmSwift
class transHistoryVC: baseViewController {
    
    var footerView : transFooterView = transFooterView(frame: .zero)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupFooterView()
        footerView.controller = self
        setupCollectionView()
        
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
      
    }
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.white

        collectionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.footerView.snp.top)
        }
    }
    
    init(_ data : Any) {
        super.init(nibName: nil, bundle: nil)
        guard let transactionsData = data as? Results<RealmModel_Transaction> else {return}
        footerView.address = transactionsData[0].address?.address
        footerView.transactions = transactionsData
        print(transactionsData)
        self.datasource = transDatsSource(transactionsData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFooterView() {
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(transFooterView.height)
        }
    }
}

extension transHistoryVC {

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        let ds = datasource?.headerItem(indexPath.section)
        if let totalPrice = ds as? String {
            self.navigationItem.title = totalPrice
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        print("View coming back")
         self.navigationItem.title = ""
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: transCellView.width, height: transCellView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Transation pressed")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: transHeaderCellView.width, height: transHeaderCellView.height)
    }
}
