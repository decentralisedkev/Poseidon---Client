//
//  secenclave.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import LocalAuthentication
import EllipticCurveKeyPair
import KeychainSwift

class SecEnclave {
    let context: LAContext! = LAContext()
    struct Shared {
        static let keypair: EllipticCurveKeyPair.Manager = {
            let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
            let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, flags: [.userPresence, .privateKeyUsage])
            let config = EllipticCurveKeyPair.Config(
                publicLabel: "com.kwopltd.encrypt.public",
                privateLabel: "com.kwopltd.encrypt.private",
                operationPrompt: "Encrypt Mnemonic",
                publicKeyAccessControl: publicAccessControl,
                privateKeyAccessControl: privateAccessControl,
                fallbackToKeychainIfSecureEnclaveIsNotAvailable: true
            )
            
            return EllipticCurveKeyPair.Manager(config: config)
        }()
    }
    
    func newECKeyPair() {
       // is this function needed?
//        context = LAContext()
        do {
            try Shared.keypair.deleteKeyPair()
            let key = try Shared.keypair.publicKey().data()
             print("Thi is being printed ")
            print(key.PEM)
        } catch {
            print(error)
            // TODO: catch error
        }
    }
    
    func encrypt(message : String) -> String?{
        do {
            guard let input = message.data(using: .utf8) else {
                return nil
                //TODO: Tell user could not encrypt
            }
            guard #available(iOS 10.3, *) else {
                return nil
                //TODO: Tell user "Can not encrypt on this device (must be iOS 10.3)"
            }
            let result = try Shared.keypair.encrypt(input)
            var digest = result.base64EncodedString()
            return digest
        } catch EllipticCurveKeyPair.Error.underlying(_, let underlying) where underlying.code == errSecUnimplemented {
            print("Unsupported device")
        } catch EllipticCurveKeyPair.Error.authentication(let authenticationError) where authenticationError.code == .userCancel {
            print("User cancelled/dismissed authentication dialog")
        } catch {
            print("Some other error occured. Error \(error)")
        }
        return nil
    }
    
    func decrypt(digest: String, returnDecryptedSeed: @escaping (_ seed:String) -> ()) {
        /*
         // usage
         decrypt(digest: dataAsString) { (seed) in
         DispatchQueue.main.async {
         print("Decrypted Seed:", seed)
         }
         // TODO: enum to check when fail and succeed
         }
         */
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                guard let encrypted = Data(base64Encoded: digest) else {return}
                
                let result = try Shared.keypair.decrypt(encrypted)
                
                guard let decrypted = String(data: result, encoding: .utf8) else {return}
                
                returnDecryptedSeed(decrypted)
            }catch {
                print("Error", error)
            }
            
            
            
        }
        
    }
}
