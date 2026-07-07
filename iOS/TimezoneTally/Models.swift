import Foundation

/// A single logged crossing entry.
struct Crossing: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var value2: Double
    var notes: String = ""
    var dateAdded: Date = Date()

    init(id: UUID = UUID(), title: String, value2: Double, notes: String = "", dateAdded: Date = Date()) {
        self.id = id
        self.title = title
        self.value2 = value2
        self.notes = notes
        self.dateAdded = dateAdded
    }
}
