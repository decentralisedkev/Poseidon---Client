//
//  baseSendVC.swift
//  psdn
//
//  Created by BlockChainDev on 03/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

class baseSendVC: UIPageViewController{

    static var package : SendPackage = SendPackage()
//    {
//        didSet{
//            updateControllers(packageIn: package)
//            processPackage()
//        }
//    }
    var pages : [baseSendVC] = []
    var controller : SendVC?
    
    init(controllerVC : SendVC) {
        self.controller = controllerVC
//        self.package = SendPackage.init()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       
    }
    
    init() {
//        self.package = SendPackage.init()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func processPackage() { // override to do more when package is editted
        
    }
    
}

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        guard let nextVC = nextViewController as? baseSendVC else {return}
        nextVC.processPackage()
        setViewControllers([nextVC], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        guard let prevVC = previousViewController as? baseSendVC else {return}
        prevVC.processPackage()
        setViewControllers([prevVC], direction: .reverse, animated: animated, completion: nil)
    }
    
}

extension baseSendVC: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController as! baseSendVC) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        
        return pages[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController as! baseSendVC) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
    
        return pages[nextIndex]
    }
}

extension baseSendVC: UIPageViewControllerDelegate {}
