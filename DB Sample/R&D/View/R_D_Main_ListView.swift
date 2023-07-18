//
//  R&D_ListView.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import SwiftUI
import EAMKit
import Combine

struct R_D_Main_ListView: View {
  @StateObject var viewModel = R_D_ListViewModel()
  
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

class R_D_ListViewModel: ObservableObject {
    
  @Published var items: [any WOItemProtocol] = []
  
  init() {
    fetch()
  }
  
  func fetch() {
    let results = db.woItem.fetchResults()
    items = results
  }
  
  func addItem() {

    db.woItem.write() { item in
      item.timestamp = Date()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.fetch()
      }
    }
  }
}

struct R_DListView_Previews: PreviewProvider {
  static var previews: some View {
    R_D_Main_ListView()
  }
}

