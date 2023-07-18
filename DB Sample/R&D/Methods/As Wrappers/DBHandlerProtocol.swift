//
//  DBHandlerProtocol.swift
//  DB Sample
//
//  Created by Gopinath on 18/07/23.
//

import Foundation

protocol DBHandlerProtocol {
  
  associatedtype ObjectType
}

extension DBHandlerProtocol {
  
  static func fetchResults(
    fromInstance instance: DBInstanceType = defaultDB) -> [ObjectType] {
    return []
  }
  
  static func write(
    inInstance instance: DBInstanceType = defaultDB,
    callback: @escaping (ObjectType) -> Void) { }
}
