//
//  baseDataSource.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

open class baseDataSource: NSObject {
    
    public var objects: [Any]?
    
    ///The cell classes that will be used to render out each section.
    open func cellClasses() -> [baseViewCell.Type] {
        return []
    }
    
    ///If you want more fine tuned control per row, override this method to provide the proper cell type that should be rendered
    open func cellClass(_ indexPath: IndexPath) -> baseViewCell.Type? {
        return nil
    }
    
    ///Override this method to provide your list with what kind of headers should be rendered per section
    open func headerClasses() -> [baseViewCell.Type]? {
        return []
    }
    
    ///Override this method to provide your list with what kind of footers should be rendered per section
    open func footerClasses() -> [baseViewCell.Type]? {
        return []
    }
    
    open func numberOfItems(_ section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    open func numberOfSections() -> Int {
        return 1
    }
    
    ///For each row in your list, override this to provide it with a specific item. Access this in your baseViewCell by overriding datasourceItem.
    open func item(_ indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
    
    ///If your headers need a special item, return it here.
    open func headerItem(_ section: Int) -> Any? {
        return nil
    }
    
    ///If your footers need a special item, return it here
    open func footerItem(_ section: Int) -> Any? {
        return nil
    }
    
}
