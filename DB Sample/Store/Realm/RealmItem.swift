//
//  RealmItem.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import Foundation
import RealmSwift

class RealmItem: Object, Identifiable {
  @Persisted var timestamp: Date?
  
  var id: Date {
    timestamp ?? Date()
  }
}
