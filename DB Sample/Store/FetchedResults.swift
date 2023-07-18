//
//  FetchedResults.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import Foundation
import Combine
import EAMKit
import CoreData
import RealmSwift

public final class FetchedResults<Object: NSManagedObject>: NSObject, FetchableResults, NSFetchedResultsControllerDelegate {
  
  public typealias FetchedResults = NSFetchedResultsController<Object>
  public typealias Store = MainStore
  
  public var fetchedResults: NSFetchedResultsController<Object>
  public var objects: [Object] = [] {
    didSet {
      onChange.send(objects)
    }
  }
    
  public var onChange = PassthroughSubject<[Object], Never>()
    
  private var changeSubscription: AnyCancellable?
    
  public init(results: NSFetchedResultsController<Object>) {
    self.fetchedResults = results
    super.init()
    setupOnChange()
  }
  
  public init(
    store: MainStore = MainStore.instance,
    contextType: MainStore.ContextType,
    predicate: NSPredicate? = nil,
    sort: Object.Sort? = nil) {
      
    let fetchRequest = NSFetchRequest<Object>(entityName: Object.entityName)
    fetchRequest.includesPendingChanges = true
    fetchRequest.fetchBatchSize = MainStore.defaultBatchSize
      
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sort ?? []
    
    self.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.context(for: contextType), sectionNameKeyPath: nil, cacheName: nil)
   
    try! fetchedResults.performFetch()
    self.objects = fetchedResults.fetchedObjects ?? []
    
    super.init()
    setupOnChange()
  }
    
  private func setupOnChange() {
    fetchedResults.delegate = self
  }
    
  public func updateSort(_ sort: [NSSortDescriptor]) {
    fetchedResults.fetchRequest.sortDescriptors = sort
    try? fetchedResults.performFetch()
  }
    
  public func updateFilter(_ predicate: NSPredicate) {
    fetchedResults.fetchRequest.predicate = predicate
    try? fetchedResults.performFetch()
  }
  
  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.objects = fetchedResults.fetchedObjects ?? []
  }
}


public final class RealmFetchedResults<Object: RealmSwift.Object>: NSObject, FetchableResults {
  
  public typealias FetchedResults = Results<Object>
  public typealias Store = RealmStore
  
  public var fetchedResults: Results<Object>
  public var objects: [Object] = [] {
    didSet {
      onChange.send(objects)
    }
  }
    
  public var onChange = PassthroughSubject<[Object], Never>()
    
  private var changeSubscription: RealmSwift.NotificationToken?
    
  public init(results: Results<Object>) {
    self.fetchedResults = results
    super.init()
    setupOnChange()
  }
  
  public init(
    store: RealmStore = RealmStore.instance,
    contextType: RealmStore.ContextType,
    predicate: NSPredicate? = nil,
    sort: Object.Sort? = nil) {
      
    let store = store ?? .instance
    fetchedResults = store.context(for: contextType).objects(Object.self)
    
    if let sort {
        fetchedResults = fetchedResults.sorted(byKeyPath: sort.keyPath, ascending: sort.ascending)
    }
    
    self.objects = Array(fetchedResults)

    super.init()
    setupOnChange()
  }
    
  private func setupOnChange() {
    changeSubscription = fetchedResults.observe({ change in
      switch change {
      case .initial(let results), .update(let results, _, _, _):
        self.objects = Array(results)
      default:
        break
      }
    })
  }
    
  public func updateSort(_ sort: Object.Sort) {
    
  }
    
  public func updateFilter(_ predicate: NSPredicate) {
    
  }
}


