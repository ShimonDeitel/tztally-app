import XCTest
@testable import TimezoneTally

@MainActor
final class TimezoneTallyTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.isPro = false
    }

    func testSeedCountBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.items.count, Store.freeLimit)
    }

    func testAddItemIncreasesCount() {
        let before = store.items.count
        let added = store.add(Crossing(title: "Test", value2: 0))
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testCannotAddBeyondFreeLimitWhenNotPro() {
        store.isPro = false
        for i in 0..<Store.freeLimit {
            _ = store.add(Crossing(title: "Item \(i)", value2: 0))
        }
        let result = store.add(Crossing(title: "Overflow", value2: 0))
        XCTAssertFalse(result)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProUserCanAddBeyondLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 3) {
            _ = store.add(Crossing(title: "Item \(i)", value2: 0))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit + 3)
    }

    func testDeleteRemovesItem() {
        let item = Crossing(title: "ToDelete", value2: 0)
        _ = store.add(item)
        XCTAssertTrue(store.items.contains(item))
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testUpdateModifiesItem() {
        var item = Crossing(title: "Original", value2: 0)
        _ = store.add(item)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.title, "Updated")
    }

    func testDeleteAtOffsets() {
        _ = store.add(Crossing(title: "A", value2: 0))
        _ = store.add(Crossing(title: "B", value2: 0))
        let count = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, count - 1)
    }

    func testPersistenceRoundTrip() {
        _ = store.add(Crossing(title: "Persisted", value2: 0))
        store.save()
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.title == "Persisted" }))
    }
}
