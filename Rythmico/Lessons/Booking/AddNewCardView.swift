import SwiftUI
import TextBuilder

struct AddNewCardView: View {
    @Environment(\.presentationMode) private var presentationMode

    var credential: CardSetupCredential
    @Binding var availableCards: [Card]
    @State private var cardDetails = StripeCardDetails()
    @State private var cardIsValid = false

    @StateObject
    private var coordinator = Current.cardSetupCoordinator()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TitleSubtitleContentView(title: "Add New Card", subtitle: subtitle) {
                    VStack(spacing: .spacingMedium) {
                        HStack(spacing: .spacingMedium) {
                            StripePaymentCardTextField(cardDetails: $cardDetails, cardIsValid: $cardIsValid)
                                .padding(.vertical, .spacingUnit)
                                .modifier(RoundedThinOutlineContainer(padded: false))
                            if coordinator.state.isLoading {
                                ActivityIndicator(color: .rythmicoGray90)
                            }
                        }
                        .animation(.rythmicoSpring(duration: .durationShort), value: coordinator.state.isLoading)

                        Spacer()

                        HStack(spacing: .spacingUnit * 2) {
                            Image(systemSymbol: .lockFill).rythmicoFont(.footnoteBold)
                            Text("Your payment info is stored securely.").rythmicoTextStyle(.footnoteBold)
                        }
                        .foregroundColor(.rythmicoGray90)
                    }
                    .frame(maxWidth: .spacingMax)
                    .padding([.horizontal, .bottom], .spacingMedium)
                }

                StripeSetupIntentLink(
                    credential: credential,
                    cardDetails: cardDetails,
                    coordinator: coordinator
                ) { action in
                    FloatingView {
                        RythmicoButton("Save Card", style: RythmicoButtonStyle.primary(), action: action)
                    }
                }
                .disabled(!confirmButtonEnabled)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CloseButton(action: dismiss))
        }
        .accentColor(.rythmicoPurple)
        .sheetInteractiveDismissal(interactiveDismissalEnabled)
        .disabled(coordinator.state.isLoading)
        .onSuccess(coordinator, perform: coordinatorSucceeded)
        .alertOnFailure(coordinator)
    }

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter"
        "credit/debit card".text.rythmicoFontWeight(.bodyBold)
        "details to setup payment for the lesson plan."
    }

    var confirmButtonEnabled: Bool {
        cardIsValid
    }

    var interactiveDismissalEnabled: Bool {
        cardDetails.isEmpty && !coordinator.state.isLoading
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    func coordinatorSucceeded(_ newCard: Card) {
        availableCards.append(newCard)
        dismiss()
    }
}

#if DEBUG
struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView(credential: .stub, availableCards: .constant([]))
    }
}
#endif
