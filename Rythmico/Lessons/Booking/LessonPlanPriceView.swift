import SwiftUISugar

struct LessonPlanPriceView: View {
    var price: Price
    var showTermsOfService: Bool

    private static let priceFormatter = Current.numberFormatter(format: .price)

    var body: some View {
        Container(style: .box) {
            VStack(spacing: .grid(4)) {
                HStack(spacing: .grid(5)) {
                    Text("Price per lesson")
                        .rythmicoTextStyle(.bodyBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(Self.priceFormatter.string(from: price))
                        .rythmicoTextStyle(.bodyBold)
                        .multilineTextAlignment(.trailing)
                }
                .foregroundColor(.rythmico.foreground)

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
                .foregroundColor(.rythmico.foreground)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, .grid(6))
            .padding([.horizontal, .bottom], .grid(4))
        }
    }
}

#if DEBUG
struct LessonPlanPriceView_Previews: PreviewProvider {
    static var stub: [(showTermsOfService: Bool, price: Price)] {
        Array(Bool.allCases * [.nonDecimalStub, .exactDecimalStub, .inexactDecimalStub])
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
