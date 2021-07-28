import SwiftUISugar

struct AddNewCardView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var credential: CardSetupCredential
    @Binding var availableCards: [Card]
    @State private var cardDetails = StripeCardDetails()
    @State private var cardIsValid = false

    @StateObject
    private var coordinator = Current.cardSetupCoordinator()

    var body: some View {
        VStack(spacing: 0) {
            TitleSubtitleContentView(title: title, subtitle: subtitle) {
                VStack(spacing: .grid(5)) {
                    HStack(spacing: .grid(5)) {
                        StripePaymentCardTextField(cardDetails: $cardDetails, cardIsValid: $cardIsValid)
                            .padding(.vertical, .grid(1))
                            .modifier(RoundedThinOutlineContainer(padded: false))
                        if coordinator.state.isLoading {
                            ActivityIndicator(color: .rythmico.gray90)
                        }
                    }
                    .animation(.rythmicoSpring(duration: .durationShort), value: coordinator.state.isLoading)

                    Spacer()

                    HStack(spacing: .grid(2)) {
                        Image(systemSymbol: .lockFill).rythmicoFont(.footnoteBold)
                        Text("Your payment info is stored securely.").rythmicoTextStyle(.footnoteBold)
                    }
                    .foregroundColor(.rythmico.gray90)
                }
                .frame(maxWidth: .grid(.max))
                .padding([.horizontal, .bottom], .grid(5))
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
        .navigationBarTitle(title)
        .navigationBarItems(trailing: CloseButton(action: dismiss))
        .accentColor(.rythmico.purple)
        .interactiveDismissDisabled(interactiveDismissDisabled)
        .disabled(coordinator.state.isLoading)
        .onSuccess(coordinator, perform: coordinatorSucceeded)
        .alertOnFailure(coordinator)
    }

    var title: String { "Add New Card" }

    @SpacedTextBuilder
    var subtitle: Text {
        "Enter"
        "credit/debit card".text.rythmicoFontWeight(.bodyBold)
        "details to setup payment for the lesson plan."
    }

    var confirmButtonEnabled: Bool {
        cardIsValid
    }

    var interactiveDismissDisabled: Bool {
        !cardDetails.isEmpty || coordinator.state.isLoading
    }

    func dismiss() {
        navigator.dismiss(screen: currentScreen)
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
