//
//  R_D_Model.swift
//  DB Sample
//
//  Created by Gopinath on 17/07/23.
//

import CoreData
import EAMKit
import RealmSwift

enum DBObject {
  
  case woItem
  
  func write(inInstance instance: DBInstanceType = defaultDB,
             callback: @escaping (AnyObject) -> Void) {
    
    switch self {
      
    case .woItem:
      
      switch instance {
      case .coreData:
        DBManager.writeInCoreData(type: Item.self) { item in
          callback(item)
        }

      case .realm:
        DBManager.writeInRealm(type: RealmItem.self) { item in
          callback(item)
        }
      }
    }
  }
  
  func fetchResults(fromInstance instance: DBInstanceType? = nil) -> [AnyObject] {
    
    let instance = instance ?? defaultDB
    switch self {
      
    case .woItem:
      
      switch instance {
      case .coreData:
        return DBManager.fetchCoreDataResults(type: Item.self)
      case .realm:
        return DBManager.fetchRealmResults(type: RealmItem.self)
      }
    }
  }
}
