//
//  WOItemDBHandler.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import Foundation

class WOItemDBHandler: DBNewHandlerProtocol {
  
  typealias ObjectType = WOItemProtocol
  
  func fetchResults() -> [ObjectType] {
    return []
  }
  
  func write(
    callback: @escaping (ObjectType) -> Void) { }
}
