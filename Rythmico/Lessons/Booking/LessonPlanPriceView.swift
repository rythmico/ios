import FoundationSugar
import SwiftUISugar

struct LessonPlanPriceView: View {
    var price: Price
    var showTermsOfService: Bool

    private static let priceFormatter = Current.numberFormatter(format: .price)

    var body: some View {
        VStack(spacing: .grid(4)) {
            HStack(spacing: .grid(4)) {
                Text("Price per lesson").rythmicoTextStyle(.bodyBold).frame(maxWidth: .infinity, alignment: .leading)
                Text(Self.priceFormatter.string(from: price)).rythmicoTextStyle(.bodyBold).multilineTextAlignment(.trailing)
            }
            .foregroundColor(.rythmicoForeground)

            Group {
                Text("Payment will be automatically taken on the day of each lesson.").rythmicoTextStyle(.callout)
                if showTermsOfService {
                    Text {
                        "By confirming your booking you agree to our "
                        "terms of service and policies".text.underline()
                        "."
                    }
                    .rythmicoTextStyle(.callout)
                    .onTapGesture(perform: Current.urlOpener.openTermsAndConditionsURL)
                }
            }
            .foregroundColor(.rythmicoGray90)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, .grid(6))
        .padding(.horizontal, .grid(4))
        .modifier(RoundedGrayedDialog())
    }
}

#if DEBUG
struct LessonPlanPriceView_Previews: PreviewProvider {
    static var stub: [(showTermsOfService: Bool, price: Price)] {
        Bool.allCases * [.nonDecimalStub, .exactDecimalStub, .inexactDecimalStub]
    }

    static var previews: some View {
        ForEach(0..<stub.count, id: \.self) { i in let stub = stub[i]
            LessonPlanPriceView(
                price: stub.price,
                showTermsOfService: stub.showTermsOfService
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
