//
//  CD_WOItemHandler.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import CoreData

class CD_WOItemHandler: WOItemDBHandler {
  
  override func fetchResults() -> [ObjectType] {
    
    return DBManager.fetchCoreDataResults(type: Item.self)
  }
  
  override func write(
    callback: @escaping (ObjectType) -> Void) {
      
      DBManager.writeInCoreData(type: Item.self) { item in
        callback(item as! Item)
      }
    }
}
