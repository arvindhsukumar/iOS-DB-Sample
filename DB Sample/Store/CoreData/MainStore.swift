//
//  MainStore.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import Foundation
import CoreData
import EAMKit

public class MainStore {
  public static var instance: MainStore = MainStore()
  public var persistentContainer: NSPersistentContainer
  public var mainQueueContext: NSManagedObjectContext!
  public var backgroundContext: NSManagedObjectContext!
  
  private static let dbName = "EAM360"
  
  public static var dbPathURL: URL? {
    
    var dbUrl = FileManager.default.urls(
      for: .applicationSupportDirectory,
         in: .userDomainMask).last
    dbUrl?.appendPathComponent("\(dbName).sqlite")
    return dbUrl
  }
  
  private init() {
    self.persistentContainer = NSPersistentContainer(name: "DB_Sample")
    persistentContainer.loadPersistentStores { [weak self] (_, error) in
      
      guard let weakSelf = self else {
        return
      }
      
      if let _ = error {
        fatalError("Unable to load persistent stores")
      }
      
      weakSelf.setupContexts()
    
      NotificationCenter.default.postOnMainThread(name: .coreDataInit, object: nil)
    }
  }
  
  private func setupContexts() {
    createContexts()
    registerForSaveNotifications()
  }
  
  private func createContexts() {
    /* Let’s reuse background context and we’ll only have to manage two contexts.
        This keeps our Core Data structure simple to understand and it
        prevents having multiple out of sync contexts. */
    mainQueueContext = persistentContainer.viewContext
    backgroundContext = persistentContainer.newBackgroundContext()

    [mainQueueContext, backgroundContext].forEach { (context) in
      /* Added this to resolve the delay in updating changes from
           background thread to main thread */
      context?.stalenessInterval = 0
      /* When the constraints are the same, overwrite the values of
           the stored entity with the new values. */
      context?.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
  }
  
  private func registerForSaveNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.mainContextDidSave(_:)),
      name: NSNotification.Name.NSManagedObjectContextDidSave,
      object: mainQueueContext
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.backgroundContextDidSave(_:)),
      name: NSNotification.Name.NSManagedObjectContextDidSave,
      object: backgroundContext
    )
  }
  
  @objc func mainContextDidSave(_ note: Notification) {
    backgroundContext.performMergeChanges(from: note)
  }
  
  @objc func backgroundContextDidSave(_ note: Notification) {
    mainQueueContext.performMergeChanges(from: note)
  }
  
  /// Returns the default batch size that we use to set for fetch request.
  ///
  /// It's very important to set the batch size to some small size,
  /// which improves the performance and reduces the memory consumption.
  /// This way, CoreData retrieves a subset of objects at a time
  /// from the underlying database,
  /// and automatically fetches more as we scroll or access.
  public static var defaultBatchSize: Int {
    return 20
  }
}

extension MainStore: Store {
  public typealias Context = NSManagedObjectContext

  public enum ContextType: String {
    case main, background
  }

  public func write(_ changes: @escaping (NSManagedObjectContext) -> Void, in contextType: ContextType) throws {
    let context = self.context(for: contextType)
//    try context.save()
    
    Task {
      try await context.perform {
        changes(context)
        try context.save()
      }
    }
  }
  
  public func context(for contextType: ContextType) -> NSManagedObjectContext {
    switch contextType {
    case .main:
      return mainQueueContext
    case .background:
      return backgroundContext
    }
  }
}
