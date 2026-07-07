import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("timezonetally_showNotes") private var showNotes: Bool = true
    @AppStorage("timezonetally_compactList") private var compactList: Bool = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Toggle("Show notes in list", isOn: $showNotes)
                        .accessibilityIdentifier("settingsShowNotesToggle")
                    Toggle("Compact list rows", isOn: $compactList)
                        .accessibilityIdentifier("settingsCompactToggle")
                }

                Section("Subscription") {
                    if store.isPro {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") { showPaywall = true }
                            .accessibilityIdentifier("settingsUpgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task {
                            await purchases.restore()
                            store.isPro = purchases.isPurchased
                        }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/tztally-app/privacy.html")!)
                        .accessibilityIdentifier("settingsPrivacyLink")
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/tztally-app/terms.html")!)
                        .accessibilityIdentifier("settingsTermsLink")
                    Text("Version 1.0")
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
