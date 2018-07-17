//
//  SummaryVC.swift
//  psdn
//
//  Created by BlockChainDev on 03/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Hello
import NVActivityIndicatorView
import NotificationBannerSwift
class SummaryVC: baseSendVC,NVActivityIndicatorViewable {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(baseSendVC.package.toAddress, baseSendVC.package.amount)
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
        self.view.addSubview(addressLabel)
        self.view.addSubview(amountLabel)
        self.view.addSubview(sendButton)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(60)
        }

        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)
            make.left.equalTo(addressLabel.snp.left)
            make.right.equalTo(addressLabel.snp.right)
            make.height.equalTo(addressLabel.snp.height)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        sendButton.addTarget(self, action: #selector(sendTransaction), for: .touchUpInside)
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 30)
        label.textAlignment = .center
         label.adjustsFontSizeToFitWidth = true
        label.text = "Summary"
        label.textColor = .black
        return label
    }()
    
    let addressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 20)
        label.textAlignment = .center
         label.adjustsFontSizeToFitWidth = true
        label.text = "Address :"
        label.textColor = .black
        return label
    }()
    
    let amountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Thin", size: 20)
        label.textAlignment = .center
        label.text = "Amount :"
        label.textColor = .black
        return label
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("Send", for: .normal)
        return button
    }()
    
    @objc func sendTransaction() {
        guard let controller = controller else {return}
        var transactions = controller.transactions
        guard let fromAddr = controller.transactions[0].address?.address else {return}
         let realmInstance = RealmDBManager.sharedInstance
        guard let addr = realmInstance.fetchObjectWithPrimaryKey(object: RealmModel_Account(), key: fromAddr) else {return}
      
        guard var scriptHash = controller.transactions[0].asset?.scriptHash else {return}
        scriptHash = String(scriptHash.dropFirst(2))  //MARK: The scriphash has 0x and so we cut it off here
        guard let type = controller.transactions[0].asset?.type else {return}
        guard let toAddr = baseSendVC.package.toAddress else {return}
        guard let amount = stringAmountToFixed8(amount: baseSendVC.package.amount) else {return}
        let size = CGSize(width: 30, height: 30)
         DispatchQueue.main.async {
        self.startAnimating(size, message: "Creating Transaction...", messageFont: UIFont(name: "Lato-Medium", size: 20), type: NVActivityIndicatorType(rawValue: 4), color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .darkGray, textColor: .white)
        }
        if type != "NEP5" {
            // utxo -- Contract transaction
            print("We got a NEP", amount)
            let(inp, changeAmount) = CalculateInputsNeeded(transactions: transactions, total : amount)
            guard let inputs = inp else {return}
            
            print("Sending amount", amount, "Change ", changeAmount)
            let ct = FormTransactionFromInputs(inputs: inputs, changeAmount: changeAmount, scriptHash: scriptHash, fromAddr : addr, toAddr: toAddr, total : amount)
            guard let contractTransaction = ct else {return}

            let wallet = WalletManager.sharedInstance
            wallet.GetMnemonic { (seed) in
                if let seed = seed {
                     DispatchQueue.main.async {
                  NVActivityIndicatorPresenter.sharedInstance.setMessage("Signing Transaction...")
                    }
                    if let response = wallet.PrepareContractTransactionAndSign(trans: contractTransaction, keys: [], mnemonic: seed) {
                         DispatchQueue.main.async {
                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Sending transaction to http://seed5.neo.org:20332")
                        }
//                        (wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata))
                        wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata, completionHandler: { (success) in
                            DispatchQueue.main.async {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                            }
                            if success {
                                let message = response.txid

                                DispatchQueue.main.async {
                                    let subtitle = NSAttributedString(string: message,
                                                                                 attributes: [NSAttributedStringKey.font: UIFont(name: "Lato-Thin", size: 14)])
                                    let title = NSAttributedString(string: "Success",
                                                                                 attributes: [NSAttributedStringKey.font: UIFont(name: "Lato-Medium", size: 14)])
                                    let banner = NotificationBanner(attributedTitle: title, attributedSubtitle: subtitle, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
//                                    let banner = NotificationBanner(title: "Success", subtitle: message, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                                    banner.autoDismiss = true
                                    banner.onTap = {
//                                        UIPasteboard.general.string = message
                                        banner.dismiss()
                                    }
                                    self.dismiss(animated: true, completion: nil)
                                    banner.show()
                                    banner.onTap = {
//                                        UIPasteboard.general.string = message
                                        banner.dismiss()
                                    }
                                }
    
                            } else {
                                DispatchQueue.main.async {
                                     self.dismiss(animated: false, completion: nil)
                                    let banner = NotificationBanner(title: "Failure", subtitle: "Transaction Failed", leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
                                    banner.show()
                                    
                                }

                            }
                        })
                        
//                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Sending transaction to https://seed1.neo.org:20331")
//                        (wallet.SendTransaction(rpcUrl: "https://seed1.neo.org:20331", txdata: response.txdata))
//
//                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Sending transaction to http://test3.cityofzion.io:8880")
//                        (wallet.SendTransaction(rpcUrl: "http://test3.cityofzion.io:8880", txdata: response.txdata))
//
//                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Sending transaction to http://test2.cityofzion.io:8880")
//                        (wallet.SendTransaction(rpcUrl: "http://test2.cityofzion.io:8880", txdata: response.txdata))
                     
                        

                            
                        
                        
                        
                    }

                }
            }
        } else {
            //NEP5
            // We can just form the transaction and send like normal -- It will be invocation
            var trans = Transaction(TransType: 209)
            trans.Version = 1
           
            
              guard let change = addr.external.value, let index = addr.index.value else {return}
            var keys = [SigningKeys]()
            keys.append(SigningKeys(external: change, index: index))
            
            var sc = ScriptBuilder()
            sc.Operation = "transfer"
            sc.Scripthash = scriptHash
            sc.Args.append(fromAddr)
            sc.Args.append(toAddr)
            
            sc.Args.append(amount) // change this to the string variation instead -- Try string again, nodes were stuck last time tried
            
            let wallet = WalletManager.sharedInstance
            wallet.GetMnemonic { (seed) in
                if let seed = seed {
                    DispatchQueue.main.async {
                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Signing Transaction...")
                    }
                    
                    
                    if let response = wallet.PrepareInvocationTransactionAndSign(trans: trans, script: sc, keys: keys, mnemonic: seed) {
//                        wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata, completionHandler: { (success) in}
//                           print(wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata))
//                        print(wallet.SendTransaction(rpcUrl: "https://seed1.neo.org:20331", txdata: response.txdata))
//                        print(wallet.SendTransaction(rpcUrl: "http://test3.cityofzion.io:8880", txdata: response.txdata))
//                        print(wallet.SendTransaction(rpcUrl: "http://test2.cityofzion.io:8880", txdata: response.txdata))
//                        print(response.txid)
                         DispatchQueue.main.async {
                            NVActivityIndicatorPresenter.sharedInstance.setMessage("Sending transaction to http://seed5.neo.org:20332")
                        }
                            //                        (wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata))
                            wallet.SendTransaction(rpcUrl: "http://seed5.neo.org:20332", txdata: response.txdata, completionHandler: { (success) in
                                 DispatchQueue.main.async {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                }
                                if success {
                                    let message = response.txid

                                    DispatchQueue.main.async {
                                        let subtitle = NSAttributedString(string: message,
                                                                          attributes: [NSAttributedStringKey.font: UIFont(name: "Lato-Thin", size: 14)])
                                        let title = NSAttributedString(string: "Success",
                                                                       attributes: [NSAttributedStringKey.font: UIFont(name: "Lato-Medium", size: 14)])
                                        let banner = NotificationBanner(attributedTitle: title, attributedSubtitle: subtitle, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                                        banner.autoDismiss = true
                                        self.dismiss(animated: true, completion: nil)
                                        banner.show()
                                        banner.onTap = {
//                                            UIPasteboard.general.string = message
                                            banner.dismiss()
                                        }
                                        
                                    }
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: false, completion: nil)
                                        let banner = NotificationBanner(title: "Failure", subtitle: "Transaction Failed", leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
                                        banner.show()
                                        
                                    }
                                    
                                }
                            })
                        
                    }
                    
                 
                }

            }
            
        }
        
        
    }
    
    override func processPackage() {
          guard let controller = controller else {return}
        guard let amount = baseSendVC.package.amount, let address = baseSendVC.package.toAddress else {self.sendButton.isEnabled = false; sendButton.backgroundColor = .darkGray;return}
        guard let symbol = controller.transactions[0].asset?.symbol  else {return}
        sendButton.backgroundColor = transactionReceivedColor
        sendButton.isEnabled = true
        amountLabel.text = "Amount: " + String(describing: amount) + " " + symbol
        addressLabel.text = "Address: " + String(describing: address)
    }
    
    func stringAmountToFixed8(amount : String?) -> Int64? {
        guard let amount = amount else {return 0}
                    guard var am = HelloStringToFixed8(amount) else {return nil}
                    guard var ams = Int(am) else {return nil }
            return Int64(ams)
        
    }
    
}
