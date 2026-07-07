import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    ContentUnavailableView("No Crossings Yet", systemImage: "tray", description: Text("Tap + to log your first one."))
                } else {
                    List {
                        ForEach(store.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(Theme.headlineFont)
                                        .foregroundStyle(Theme.textPrimary)
                                    Text("UTC Offset (hrs): " + String(format: "%.1f", item.value2))
                                        .font(Theme.captionFont)
                                        .foregroundStyle(Theme.textSecondary)
                                    if !item.notes.isEmpty {
                                        Text(item.notes)
                                            .font(Theme.captionFont)
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                }
                                Spacer()
                            }
                            .listRowBackground(Theme.cardBackground)
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Timezone Tally")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAddSheet = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addItemButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddItemView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }
}

struct AddItemView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    @State private var titleText: String = ""
    @State private var value2Text: String = ""
    @State private var notesText: String = ""
    @FocusState private var focusedField: Field?

    enum Field { case title, value2, notes }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Timezone", text: $titleText)
                        .focused($focusedField, equals: .title)
                        .accessibilityIdentifier("addTitleField")
                    TextField("UTC Offset (hrs)", text: $value2Text)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("addValue2Field")
                        .focused($focusedField, equals: .value2)
                    TextField("Notes (optional)", text: $notesText)
                        .focused($focusedField, equals: .notes)
                        .accessibilityIdentifier("addNotesField")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .navigationTitle("Add Crossing")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Crossing(title: titleText.isEmpty ? "Crossing" : titleText, value2: Double(value2Text) ?? 0, notes: notesText)
                        if store.add(item) {
                            dismiss()
                        }
                    }
                    .accessibilityIdentifier("addSaveButton")
                    .disabled(titleText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
