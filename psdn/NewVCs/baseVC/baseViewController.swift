//
//  baseVCViewController.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

// The structure for baseVC has been adapted from https://github.com/bhlvoong/LBTAComponents/tree/master/LBTAComponents/Classes

import UIKit


open class baseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    var collectionView : UICollectionView? = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
    
    var flowLayout : UICollectionViewLayout? {
        didSet {
            guard let flowLayout = flowLayout else {return}
            collectionView?.collectionViewLayout = flowLayout
        }
    }
    
    open var datasource: baseDataSource? {
        didSet {
            if let cellClasses = datasource?.cellClasses() {
                for cellClass in cellClasses {
                    collectionView?.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
                }
            }
            
            if let headerClasses = datasource?.headerClasses() {
                for headerClass in headerClasses {
                    collectionView?.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerClass.identifier)
                }
            }
            
            if let footerClasses = datasource?.footerClasses() {
                for footerClass in footerClasses {
                    collectionView?.register(footerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerClass.identifier)
                }
            }
            
            collectionView?.reloadData()
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        guard let cv = collectionView else {return}
        self.view.addSubview(cv)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(baseViewCell.self, forCellWithReuseIdentifier: baseViewCell.identifier)
        collectionView?.register(baseViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: baseViewCell.identifier)
        collectionView?.register(baseViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: baseViewCell.identifier)
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        
        var flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        let cellSpacingLeft : CGFloat = 15
        let cellSpacingRight = cellSpacingLeft
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-(cellSpacingLeft+cellSpacingRight), height: HomeCellView.height)
        flowLayout.minimumLineSpacing = 12.0
        flowLayout.sectionFootersPinToVisibleBounds = true
        flowLayout.sectionInset = UIEdgeInsetsMake(20, cellSpacingLeft, 0, cellSpacingRight)
        self.flowLayout = flowLayout
    }

}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Lato-Thin", size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension baseViewController {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfSections() ?? 0
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if datasource?.numberOfItems(section) == 0 {
            self.collectionView?.setEmptyMessage("No data available for this address")
        } else {
                self.collectionView?.restore()
            
        }
        return datasource?.numberOfItems(section) ?? 0
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: baseViewCell
        
        if let cls = datasource?.cellClass(indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cls.identifier, for: indexPath) as! baseViewCell
            
        } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
            let cls = cellClasses[indexPath.section]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cls.identifier, for: indexPath) as! baseViewCell
        } else if let cls = datasource?.cellClasses().first {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cls.identifier, for: indexPath) as! baseViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseViewCell.identifier, for: indexPath) as! baseViewCell
        }
        
        cell.controller = self
        cell.datasourceItem = datasource?.item(indexPath)
        return cell
        
        
        
    }
    
    open func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    @objc open func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if let width = (datasource?.cellClass(indexPath as IndexPath)?.width),  let height = (datasource?.cellClass(indexPath as IndexPath)?.height) {
            return CGSize(width: width , height: height)
        }
        return CGSize(width:self.view.frame.width, height: 20)
        
    }
    
     open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView: baseViewCell
        
        if kind == UICollectionElementKindSectionHeader {
            if let classes = datasource?.headerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (classes[indexPath.section].identifier), for: indexPath) as! baseViewCell
            } else if let cls = datasource?.headerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cls.identifier, for: indexPath) as! baseViewCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: baseViewCell.identifier, for: indexPath) as! baseViewCell
            }
            reusableView.datasourceItem = datasource?.headerItem(indexPath.section)
            
        } else {
            if let classes = datasource?.footerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (classes[indexPath.section].identifier), for: indexPath) as! baseViewCell
            } else if let cls = datasource?.footerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: (cls).identifier, for: indexPath) as! baseViewCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: baseViewCell.identifier, for: indexPath) as! baseViewCell
            }
            reusableView.datasourceItem = datasource?.footerItem(indexPath.section)
        }
        
        reusableView.controller = self
        
        return reusableView
    }
    
}

