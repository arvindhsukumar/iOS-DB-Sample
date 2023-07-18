//
//  R_L_Wrapper.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import CoreData
import EAMKit
import RealmSwift


class WOItemWrapper: DBHandlerProtocol {
  
  typealias ObjectType = WOItemProtocol
  
  static func fetchResults(
    fromInstance instance: DBInstanceType = defaultDB) -> [ObjectType] {
    
    var results: [any WOItemProtocol]?
    switch instance {
      
    case .coreData:
      results = DBManager.fetchCoreDataResults(type: Item.self)
      
    case .realm:
      results = DBManager.fetchRealmResults(type: RealmItem.self)
    }
    
    return results ?? []
  }
  
  static func write(
    inInstance instance: DBInstanceType = defaultDB,
    callback: @escaping (ObjectType) -> Void) {
      
      switch instance {
        
      case .coreData:
        DBManager.writeInCoreData(type: Item.self) { item in
          callback(item as! WOItemProtocol)
        }
      case .realm:
        DBManager.writeInRealm(type: RealmItem.self) { item in
          callback(item as! WOItemProtocol)
        }
      }
    }
}
