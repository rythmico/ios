import SwiftUI
import TextBuilder

struct LessonPlanBookingPriceView: View {
    var price: Price

    private static let priceFormatter = Current.numberFormatter(format: .price)

    var body: some View {
        VStack(spacing: .spacingSmall) {
            HStack(spacing: .spacingSmall) {
                Text("Price per lesson").frame(maxWidth: .infinity, alignment: .leading)
                Text(Self.priceFormatter.string(for: price)).multilineTextAlignment(.trailing)
            }
            .rythmicoFont(.bodyBold)
            .foregroundColor(.rythmicoForeground)

            Group {
                Text("Payment will be automatically taken on the day of each lesson.")
                Text {
                    "By confirming your booking you agree to our "
                    "terms of service and policies".text.underline()
                    "."
                }
                .onTapGesture(perform: Current.urlOpener.openTermsAndConditionsURL)
            }
            .rythmicoFont(.callout)
            .foregroundColor(.rythmicoGray90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, .spacingLarge)
        .padding(.horizontal, .spacingSmall)
        .modifier(RoundedGrayedDialog())
    }
}

#if DEBUG
struct LessonPriceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanBookingPriceView(price: .nonDecimalStub)
            LessonPlanBookingPriceView(price: .exactDecimalStub)
            LessonPlanBookingPriceView(price: .inexactDecimalStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
