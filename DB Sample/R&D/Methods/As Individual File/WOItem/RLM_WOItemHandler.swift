//
//  RLM_WOItemHandler.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import RealmSwift

class RLM_WOItemHandler: WOItemDBHandler {
  
  override func fetchResults() -> [ObjectType] {
    
    return DBManager.fetchRealmResults(type: RealmItem.self)
  }
  
  override func write(
    callback: @escaping (ObjectType) -> Void) {
      
      DBManager.writeInRealm(type: RealmItem.self) { item in
        callback(item as! WOItemProtocol)
      }
    }
}
