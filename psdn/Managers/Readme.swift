//
//  Readme.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

/*
 
 The managers declared in this folder, will be in charge of co-ordinating and managing their respective areas.
 
 For example:
 
 - Wallet Manager: This is in charge of managing features such as Wallet creation and wallet signing, and also sending off transactions
 - Realm Manager: The database used is Realm and this will be in charge of adding, deleting, querying and modifying items.
        - Should include an implementation of groupby in realmdb as it is not native to the language
 - SecEnclave: This handles the touchID Security, and decrypting the mnemonic
 - Service manager: handles the api calls that eventually put into the realmdb
 
 */
