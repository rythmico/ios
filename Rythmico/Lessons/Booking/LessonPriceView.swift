import SwiftUI

struct LessonPriceView: View {
    var price: Price
    var instrument: Instrument

    private let priceFormatter = Current.numberFormatter(format: .price)

    var body: some View {
        VStack(spacing: .spacingExtraSmall) {
            MultiStyleText(parts: priceDescription)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    var priceDescription: [MultiStyleText.Part] {
        priceFormatter.string(for: price).style(.headline).color(.rythmicoGray90) +
        " per lesson".color(.rythmicoGray90)
    }
}

#if DEBUG
struct LessonPriceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPriceView(price: .nonDecimalStub, instrument: .guitar)
            LessonPriceView(price: .exactDecimalStub, instrument: .guitar)
            LessonPriceView(price: .inexactDecimalStub, instrument: .guitar)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
