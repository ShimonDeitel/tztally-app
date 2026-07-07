import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                        .padding(.top, 32)

                    Text("Timezone Tally Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.textPrimary)

                    Text("Unlimited entries and a multi-city clock comparison view.")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Unlimited entries", systemImage: "infinity")
                        Label("All Pro features unlocked", systemImage: "star.fill")
                        Label("Supports future updates", systemImage: "heart.fill")
                    }
                    .font(Theme.headlineFont)
                    .foregroundStyle(Theme.textPrimary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .padding(.horizontal, 24)

                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPurchased {
                                store.isPro = true
                                dismiss()
                            }
                        }
                    } label: {
                        Group {
                            if purchases.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(purchases.product != nil ? "Unlock — \(purchases.product!.displayPrice)" : "Unlock Pro ($1.99/month)")
                            }
                        }
                        .font(Theme.headlineFont.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    .accessibilityIdentifier("paywallPurchaseButton")
                    .padding(.horizontal, 24)
                    .disabled(purchases.isLoading)

                    Button("Restore Purchases") {
                        Task {
                            await purchases.restore()
                            if purchases.isPurchased {
                                store.isPro = true
                                dismiss()
                            }
                        }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.textSecondary)

                    Button("Not Now") { dismiss() }
                        .accessibilityIdentifier("paywallDismissButton")
                        .font(Theme.captionFont)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.bottom, 24)

                    if let error = purchases.errorMessage {
                        Text(error).font(Theme.captionFont).foregroundStyle(.red)
                    }
                }
            }
        }
    }
}
