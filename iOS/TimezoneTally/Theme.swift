import SwiftUI

/// Unique visual identity for Timezone Tally.
enum Theme {
    static let accent = Color(red: 0.247, green: 0.318, blue: 0.710)
    static let background = Color(red: 0.039, green: 0.051, blue: 0.118)
    static let cardBackground = Color(red: 0.099, green: 0.111, blue: 0.178)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
