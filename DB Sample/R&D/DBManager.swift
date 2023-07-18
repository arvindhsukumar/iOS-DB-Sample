//
//  DBHandler.swift
//  DB Sample
//
//  Created by Gopinath on 17/07/23.
//

import Foundation
import CoreData
import EAMKit
import RealmSwift

enum DBInstanceType {
  case coreData
  case realm
}

let defaultDB: DBInstanceType = .realm
let db = DBManager.shared.defaultDB
let realm_db = DBManager.shared.realmDB

class DBManager {
  
  static var shared = DBManager()

  var defaultDB: DefaultDBObjectHandler = CD_DBManager()
  var realmDB: DefaultDBObjectHandler = RLM_DBManager()

  static func fetchCoreDataResults<T: NSManagedObject>(type: T.Type) -> [T] {
    let frc = DB_Sample.FetchedResults<T>(contextType: .main)
    let results = frc.objects
    return results
  }
  
  static func writeInCoreData<T: NSManagedObject>(
    type: T.Type,
    callback: @escaping (AnyObject) -> Void) {
      let store = MainStore.instance

      try! store.write({ context in
        let item = T.insert(in: context)
        callback(item)
      }, in: .main)
    }
  
  static func fetchRealmResults<T: Object>(type: T.Type) -> [T] {
    let frc = RealmFetchedResults<T>(contextType: .main)
    let results = frc.objects
    return results
  }
  
  static func writeInRealm<T: Object>(
    type: T.Type,
    callback: @escaping (AnyObject) -> Void) {
      let store = RealmStore.instance

      try! store.write({ context in
        let item = T.insert(in: context)
        callback(item)
      }, in: .main)
    }
}


protocol WOItemProtocol: AnyObject {
  var timestamp: Date? { get set }
}

extension Item: WOItemProtocol { }
extension RealmItem: WOItemProtocol { }
