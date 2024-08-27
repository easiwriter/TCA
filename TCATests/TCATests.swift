//
//  TCATests.swift
//  TCATests
//
//  Created by Keith Lander on 26/08/2024.
//

import ComposableArchitecture
import XCTest
@testable import TCA

final class resetItems: XCTestCase {
    @MainActor
    func testItemsReset() async {
        let store = TestStore(initialState: ContentFeature.State(context: TCAApp.sharedModelContainer.mainContext)) {
            ContentFeature()}
        if store.state.items.count > 0 {
            await store.send(.itemsReset) {
                $0.items = [Item]()
            }
        }
    }
}

final class addButtonTest: XCTestCase {
    @MainActor
    func testItemButtonTapped() async {
        let store = TestStore(initialState: ContentFeature.State(context: TCAApp.sharedModelContainer.mainContext)) {
            ContentFeature()}
        
        let item = Item(
            timestamp: Date())
        await store.send(.itemButtonTapped(item: item)) {
            $0.items.append(item)
        }
        let item1 = Item(
            timestamp: Date())
        await store.send(.itemButtonTapped(item: item1)) {
            $0.items.append(item1)
        }
    }
}

final class deleteButtonTest: XCTestCase {
    @MainActor
    func testDeleteItemButtonTapped() async {
        let store = TestStore(initialState: ContentFeature.State(context: TCAApp.sharedModelContainer.mainContext)) {
            ContentFeature()}
        let offsets = IndexSet(integer: 0)
        await store.send(.itemDeleteButtonTapped(offsets: offsets)) {
            $0.deleteItems(offsets: offsets)
        }
    }
}


