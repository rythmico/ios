import SwiftUI

struct LessonPlanBookingPriceView: View {
    private enum Const {
        static let termsAndConditionsURL = URL(string: "https://rythmico.webflow.io/legal/terms-and-policies")!
    }

    var price: Price

    private let priceFormatter = Current.numberFormatter(format: .price)

    var body: some View {
        VStack(spacing: .spacingSmall) {
            HStack(spacing: .spacingSmall) {
                Text("Price per lesson").frame(maxWidth: .infinity, alignment: .leading)
                Text(priceFormatter.string(for: price)).multilineTextAlignment(.trailing)
            }
            .rythmicoFont(.bodyBold)
            .foregroundColor(.rythmicoForeground)

            Group {
                Text("Payment will be automatically taken on the 1st of every month.")
                Text("By confirming your booking you agree to our ") + Text("terms of service and policies").underline() + Text(".")
            }
            .rythmicoFont(.callout)
            .foregroundColor(.rythmicoGray90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture(perform: presentTermsAndConditions)
        }
        .padding(.vertical, .spacingLarge)
        .padding(.horizontal, .spacingSmall)
        .modifier(RoundedGrayedDialog())
    }

    func presentTermsAndConditions() {
        Current.urlOpener.open(Const.termsAndConditionsURL)
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