import SwiftUIEncore

struct PaymentMethodChoiceList: View {
    var cards: NonEmpty<[Card]>
    @Binding
    var selectedCard: Card

    var body: some View {
        ChoiceList(data: cards, id: \.id, selection: Binding($selectedCard), padding: padding) { card, state in
            HStack(spacing: .grid(4)) {
                Image(uiImage: card.brand.logo)
                VStack(alignment: .leading, spacing: 0) {
                    Text(card.brand.name).rythmicoTextStyle(state.isSelected ? .bodyBold : .bodyMedium)
                    HStack(spacing: .grid(4)) {
                        Text(formattedLastFourDigits(for: card)).rythmicoTextStyle(state.isSelected ? .bodyMedium : .body)
                        Text(formattedExpiryDate(for: card)).rythmicoTextStyle(state.isSelected ? .bodyMedium : .body)
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private let padding = ChoiceItemViewDefaultPadding => (\.vertical, .init(.grid(2.5)))

    private func formattedLastFourDigits(for card: Card) -> String {
        "• • • • " + card.lastFourDigits
    }

    private static let expiryDateFormatter = Current.dateFormatter(format: .custom("'exp:' MM/yy"))
    private func formattedExpiryDate(for card: Card) -> String {
        "exp: " +
        Self.expiryDateFormatter.string(from: DateComponents(calendar: Current.calendar(), year: card.expiryYear, month: card.expiryMonth).date!)
    }
}

#if DEBUG
struct PaymentMethodChoiceList_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(NonEmptyArray<Card>(.mastercardStub, .visaStub), Card.mastercardStub) { cards, selectedCard in
            PaymentMethodChoiceList(cards: cards.wrappedValue, selectedCard: selectedCard)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
