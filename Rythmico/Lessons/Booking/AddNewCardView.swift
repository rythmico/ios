import SwiftUI

struct AddNewCardView: View {
    @Environment(\.presentationMode) private var presentationMode

    @Binding var availableCards: [Checkout.Card]
    @State private var cardDetails = StripeCardDetails()
    @State private var cardIsValid = false

    @StateObject
    private var coordinator = Current.addNewCardCoordinator()

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
                            Image(systemSymbol: .lockFill)
                            Text("Your payment info is stored securely.")
                        }
                        .foregroundColor(.rythmicoGray90)
                        .rythmicoFont(.footnoteBold)
                    }
                    .padding([.horizontal, .bottom], .spacingMedium)
                }

                StripeSetupIntentLink(
                    clientSecret: clientSecret,
                    cardDetails: cardDetails,
                    coordinator: coordinator
                ) { action in
                    FloatingView {
                        Button("Save Card", action: action).primaryStyle()
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

    var subtitle: [MultiStyleText.Part] {
        "Enter ".color(.rythmicoGray90) +
        "credit/debit card".color(.rythmicoGray90).style(.bodyBold) +
        " details to setup payment for the lesson plan.".color(.rythmicoGray90)
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

    func coordinatorSucceeded(_ newCard: Checkout.Card) {
        availableCards.append(newCard)
        dismiss()
    }
}

private let clientSecret = "seti_1HbVOrKYZ0dQzslEXS6mVexF_secret_IBtBJAtyxvQZmmumfICX510ChcazReG"

#if DEBUG
struct AddNewCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCardView(availableCards: .constant([]))
    }
}
#endif
