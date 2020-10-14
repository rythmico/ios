import SwiftUI
import NonEmpty

struct CardStackView: View {
    var cards: NonEmpty<[Checkout.Card]>
    @Binding
    var selectedCard: Checkout.Card
    var horizontalInset: CGFloat = .spacingMedium

    var body: some View {
        VStack(spacing: 0) {
            HDivider()
            ForEach(cards) { card in
                HStack(spacing: .spacingSmall) {
                    Image(uiImage: card.brand.logo)
                    VStack(alignment: .leading, spacing: .spacingUnit / 2) {
                        Text(card.brand.name)
                            .rythmicoFont(.bodySemibold)
                        HStack(spacing: .spacingSmall) {
                            Text(formattedLastFourDigits(for: card))
                            Text(formattedExpiryDate(for: card))
                        }
                        .rythmicoFont(.body)
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    RadialSelectionIndicator(isSelected: selectedCard == card)
                }
                .padding(.horizontal, horizontalInset)
                .padding(.vertical, .spacingExtraSmall)
                .contentShape(Rectangle())
                .onTapGesture { selectedCard = card }
                HDivider()
            }
        }
        .foregroundColor(.rythmicoGray90)
    }

    private func formattedLastFourDigits(for card: Checkout.Card) -> String {
        "• • • • " + card.lastFourDigits
    }

    private let expiryDateFormatter = Current.dateFormatter(format: .custom("'exp:' MM/yy"))
    private func formattedExpiryDate(for card: Checkout.Card) -> String {
        "exp: " +
        expiryDateFormatter.string(from: DateComponents(calendar: Current.calendar(), year: card.expiryYear, month: card.expiryMonth).date!)
    }
}

struct RadialSelectionIndicator: View {
    var isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Circle()
                    .fill(Color.rythmicoPurple)
                    .transition(
                        AnyTransition
                            .scale
                            .combined(with: .opacity)
                            .animation(.easeOut(duration: .durationMedium))
                    )
            }
            Circle()
                .strokeBorder(Color.rythmicoBackground, lineWidth: 3.5)
            Circle()
                .strokeBorder(Color.rythmicoPurple, lineWidth: 1.75)
        }
        .frame(width: 16, height: 16)
    }
}

#if DEBUG
struct CardStackView_Previews: PreviewProvider {
    struct Content: View {
        @State var cards = NonEmpty<[Checkout.Card]>(.mastercardStub, .visaStub)
        @State var selectedCard: Checkout.Card = .mastercardStub

        var body: some View {
            CardStackView(cards: cards, selectedCard: $selectedCard)
        }
    }

    static var previews: some View {
        Content()
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
#endif
