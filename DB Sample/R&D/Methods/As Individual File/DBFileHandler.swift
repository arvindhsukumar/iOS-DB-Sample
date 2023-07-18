//
//  DBFileHandler.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import Foundation

protocol DefaultDBObjectHandler {
  
  var woItem: WOItemDBHandler { get set }
}

protocol DBNewHandlerProtocol {
  
  associatedtype ObjectType
  func fetchResults() -> [ObjectType]
  func write(callback: @escaping (ObjectType) -> Void)
}

