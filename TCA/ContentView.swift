//
//  ContentView.swift
//  TCA
//
//  Created by Keith Lander on 26/08/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@Reducer
struct ContentFeature {
    struct State: Equatable {
        var context: ModelContext
        var items = [Item]()
        
        init(context: ModelContext) {
            self.context = context
            fetchData()
        }
        
        mutating func fetchData() {
            do {
                let descriptor = FetchDescriptor<Item>()
                items = try context.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }
        
        mutating func deleteAll() {
            items.forEach { item in
                context.delete(item)
            }
            try? context.save()
            items = [Item]()
        }
        
        
        mutating func addItem(item: Item) {
            items.append(item)
            context.insert(item)
            try? context.save()
        }
        
        mutating func deleteItems(offsets: IndexSet) {
            guard items.count > 0 else {
                return
            }
            for index in offsets {
                context.delete(items[index])
                items.remove(atOffsets: offsets)
            }
            try? context.save()
        }
    }
    
    enum Action {
        case itemsReset
        case itemButtonTapped(item: Item)
        case itemDeleteButtonTapped(offsets: IndexSet)
    }
//    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .itemsReset:
                state.deleteAll()
                return .none
                
            case .itemButtonTapped(let item):
                state.addItem(item: item)
                return .none
                
            case .itemDeleteButtonTapped(let offsets):
                state.deleteItems(offsets: offsets)
                return .none
            }
        }
    }
}

struct ContentView: View {
    var store: StoreOf<ContentFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(
                self.store, observe: \.items
            ) { viewStore in
                List {
                    ForEach(viewStore.state) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!)")
                        } label: {
                            Text(item.timestamp!)
                        }
                    }
                    .onDelete { (indexSet) in
                        viewStore.send(.itemDeleteButtonTapped(offsets: indexSet))
                    }
                }
                .navigationTitle("TCA Example").font(.title3)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button("Add") {
                            viewStore.send(.itemButtonTapped(item: Item(timestamp:Date())))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: ContentFeature.State(context: TCAApp.sharedModelContainer.mainContext)) {
        ContentFeature()
            ._printChanges()
    })
}
