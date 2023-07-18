//
//  ListView.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import SwiftUI
import EAMKit
import Combine

struct ListView: View {
  @StateObject var viewModel = ListViewModel()
  
  var body: some View {
    List {
      ForEach(viewModel.items, id: \.timestamp) { item in
        Text(item.timestamp?.formatted(date: .complete, time: .complete) ?? "Date")
      }
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          viewModel.addItem()
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

class ListViewModel: ObservableObject {
  
  private var fetchedItems: DB_Sample.FetchedResults<Item>?
  
  @Published var items: [any ItemProtocol] = []
  var cancelBag = Set<AnyCancellable>()
  
  init() {
    let store = MainStore.instance
    fetchedItems = DB_Sample.FetchedResults<Item>(contextType: .main, predicate: nil, sort: [NSSortDescriptor(key: "timestamp", ascending: false)])
   
    items = fetchedItems?.objects ?? []
    fetchedItems?
      .onChange
      .sink(receiveValue: { items in
        self.items = items
      })
      .store(in: &cancelBag)
  }
  
  func addItem() {
    let store = MainStore.instance

    try! store.write({ context in
      let item = Item.insert(in: context)
      item.timestamp = Date()
    }, in: .main)
  }
}

struct ListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView()
  }
}

protocol ItemProtocol {
  var timestamp: Date? { get }
}

extension Item: ItemProtocol {}
extension RealmItem: ItemProtocol {}
