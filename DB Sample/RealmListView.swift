//
//  RealmListView.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import SwiftUI
import Combine
import RealmSwift

struct RealmListView: View {
  @StateObject var viewModel = RealmListViewModel()

    var body: some View {
      List {
        ForEach(viewModel.items, id: \.id) { (item: RealmItem) in
          Text(item.timestamp?.formatted(date: .complete, time: .complete) ?? "")
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

class RealmListViewModel: ObservableObject {
  private var fetchedItems: RealmFetchedResults<RealmItem>?
  @Published var items: [RealmItem] = []
  var cancelBag = Set<AnyCancellable>()
  
  init() {
    let store = RealmStore.instance
    fetchedItems = RealmFetchedResults<RealmItem>(store: store, contextType: .main, predicate: nil, sort: RealmSwift.SortDescriptor(keyPath: "timestamp", ascending: false))

    fetchedItems?
      .onChange
      .sink(receiveValue: { items in
        self.items = items
      })
      .store(in: &cancelBag)
  }
  
  func addItem() {
    let store = RealmStore.instance

    try! store.write({ context in
      let item = RealmItem.insert(in: context)
      item.timestamp = Date()
    }, in: .main)
  }
}

struct RealmListView_Previews: PreviewProvider {
    static var previews: some View {
        RealmListView()
    }
}
