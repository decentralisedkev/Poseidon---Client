//
//  RealmDBManager.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//
// We need to get rid of those "!" when trying realm, safely open the database


import UIKit
import RealmSwift

class RealmDBManager {
    private var database:Realm
    static let sharedInstance = RealmDBManager()
    private init() {
        database = try! Realm()
    }
    func printDbPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    func fetchObjects<T: Object>(object: T) -> Results<T> {
        database = try! Realm()
        let results: Results<T> =   database.objects(T.self)
        return results
    }
    func fetchObjectsWithFilter<T: Object>(object: T, filter : NSPredicate) -> Results<T> {
         database = try! Realm()
        let results: Results<T> =  database.objects(T.self).filter(filter)
        return results
    }
    func fetchObjectWithPrimaryKey<T: Object>(object: T, key : Any) -> T? {
         database = try! Realm()
        let result: T? = database.object(ofType: T.self, forPrimaryKey: key)
        return result
    }
    func addObject<T: Object>(object: T)   {
         database = try! Realm()
        try! self.database.write {
            self.database.add(object, update: true)
            print("Added new object")
        }
        
    }
    func modifyObject<T: Object>(object: T)   {
         database = try! Realm()
        do {
            self.database.beginWrite()
            self.database.add(object, update: true)
            try self.database.commitWrite()
        } catch {
            print(error)
        }
        
    }
    
    func addObjectThreadSafe<T : Object>(object : T) {
        let realm = try! Realm()
        let objectRef = ThreadSafeReference(to: object)
        guard let safeObject = realm.resolve(objectRef) else {
            return // person was deleted
        }
        addObject(object: safeObject)
    }
    
    
    func checkObjectExist<T: Object>(object: T, key : Any) -> Bool{
         database = try! Realm()
         return database.object(ofType: T.self, forPrimaryKey: key) != nil
    }
    func removeAllFromDatabase()  {
         database = try! Realm()
        try! database.write {
            database.deleteAll()
        }
    }
    func removeObject<T: Object>(object: T) {
         database = try! Realm()
        try! database.write {
             database.delete(object)
        }
       
    }
    func removeObjectWithKey<T: Object>(object: T, key: String) {
         database = try! Realm()
        let obj = fetchObjectWithPrimaryKey(object: object, key: key)
        if let obj = obj {
            removeObject(object: obj)
        }
    }
}
