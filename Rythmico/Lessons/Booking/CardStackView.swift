import SwiftUISugar

struct CardStackView: View {
    var cards: NonEmpty<[Card]>
    @Binding
    var selectedCard: Card
    var horizontalInset: CGFloat = .grid(5)

    var body: some View {
        VStack(spacing: 0) {
            HDivider()
            ForEach(cards) { card in
                HStack(spacing: .grid(4)) {
                    Image(uiImage: card.brand.logo)
                    VStack(alignment: .leading, spacing: .grid(0.5)) {
                        Text(card.brand.name).rythmicoTextStyle(.bodySemibold)
                        HStack(spacing: .grid(4)) {
                            Text(formattedLastFourDigits(for: card)).rythmicoTextStyle(.body)
                            Text(formattedExpiryDate(for: card)).rythmicoTextStyle(.body)
                        }
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    RadialSelectionIndicator(isSelected: selectedCard == card)
                }
                .padding(.horizontal, horizontalInset)
                .padding(.vertical, .grid(3))
                .contentShape(Rectangle())
                .onTapGesture { selectedCard = card }
                HDivider()
            }
        }
        .foregroundColor(.rythmicoGray90)
    }

    private func formattedLastFourDigits(for card: Card) -> String {
        "• • • • " + card.lastFourDigits
    }

    private static let expiryDateFormatter = Current.dateFormatter(format: .custom("'exp:' MM/yy"))
    private func formattedExpiryDate(for card: Card) -> String {
        "exp: " +
        Self.expiryDateFormatter.string(from: DateComponents(calendar: Current.calendar(), year: card.expiryYear, month: card.expiryMonth).date!)
    }
}

struct RadialSelectionIndicator: View {
    @Environment(\.isEnabled) private var isEnabled

    var isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Circle()
                    .fill(color)
                    .transition(
                        (.scale + .opacity).animation(.easeOut(duration: .durationMedium))
                    )
            }
            Circle()
                .strokeBorder(Color(.systemBackground), lineWidth: 2.5)
            Circle()
                .strokeBorder(color, lineWidth: 1)
        }
        .frame(width: 16, height: 16)
        .animation(.rythmicoSpring(duration: .durationShort))
    }

    var color: Color {
        isEnabled ? .rythmicoPurple : .rythmicoGray20
    }
}

#if DEBUG
struct CardStackView_Previews: PreviewProvider {
    struct Content: View {
        @State var cards = NonEmpty<[Card]>(.mastercardStub, .visaStub)
        @State var selectedCard: Card = .mastercardStub

        var body: some View {
            CardStackView(cards: cards, selectedCard: $selectedCard)
        }
    }

    static var previews: some View {
        Group {
            Content()
            Content().disabled(true)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}
#endif
