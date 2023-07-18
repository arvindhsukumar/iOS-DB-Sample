//
//  RealmStore.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import Foundation
import EAMKit
import RealmSwift

extension Realm: Context {}
extension Object: Storable {
  public static var entityName: String {
    return String(describing: self)
  }
  
  public typealias Sort = RealmSwift.SortDescriptor
  public typealias Context = Realm
  
  static public func insert(in context: Realm) -> Self {
    let object = Self.init()
    context.add(object)
    return object
  }
}

public class RealmStore: Store {
  public typealias Context = Realm
  
  public enum ContextType {
    case main, background
  }
  
  static public let instance = RealmStore()
  
  public func context(for contextType: ContextType) -> RealmSwift.Realm {
    switch contextType {
    case .main:
      return try! Realm(configuration: .defaultConfiguration)
    case .background:
      return try! Realm(configuration: .defaultConfiguration, queue: .global())
    }
  }
  
  public func write(_ changes: @escaping (Context) -> Void, in contextType: ContextType) throws {
    let realm = context(for: contextType)
    try realm.write {
      changes(realm)
    }
  }
}
