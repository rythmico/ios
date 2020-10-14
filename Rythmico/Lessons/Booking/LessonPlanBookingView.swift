import SwiftUI
import PhoneNumberKit
import NonEmpty
import Sugar

struct LessonPlanBookingView: View {
    private var lessonPlan: LessonPlan
    private var application: LessonPlan.Application
    private var checkout: Checkout

    init(
        lessonPlan: LessonPlan,
        application: LessonPlan.Application,
        checkout: Checkout
    ) {
        self.lessonPlan = lessonPlan
        self.application = application
        self.checkout = checkout
        self._phoneNumber = .init(wrappedValue: checkout.phoneNumber)
        self._availableCards = .init(wrappedValue: checkout.availableCards)
        self._selectedCard = .init(wrappedValue: checkout.availableCards.first)
    }

    @State private var phoneNumber: Optional<PhoneNumber>
    @State private var phoneNumberInputError: Error?

    @State private var availableCards: [Checkout.Card]
    @State private var selectedCard: Checkout.Card?
    @State private var addingNewCard = false

    var body: some View {
        VStack(spacing: 0) {
            TitleSubtitleContentView(title: title, subtitle: subtitle) {
                ScrollView {
                    VStack(spacing: .spacingLarge) {
                        Group {
                            SectionHeaderContentView(title: "Lesson Schedule") {
                                ScheduleDetailsView(lessonPlan.schedule, tutor: application.tutor)
                            }

                            SectionHeaderContentView(title: "Contact Number") {
                                PhoneNumberInputView(phoneNumber: $phoneNumber, phoneNumberInputError: $phoneNumberInputError)
                            }

                            SectionHeaderContentView(title: "Price Per Lesson") {
                                LessonPriceView(price: checkout.pricePerLesson, instrument: lessonPlan.instrument)
                            }
                        }
                        .padding(.horizontal, .spacingMedium)

                        SectionHeaderContentView(title: "Payment Method", padding: EdgeInsets(horizontal: .spacingMedium)) {
                            if
                                let availableCards = NonEmpty(rawValue: availableCards),
                                let selectedCardBinding = Binding($selectedCard)
                            {
                                CardStackView(cards: availableCards, selectedCard: selectedCardBinding)
                            }
                        }

                        HDividerContainer {
                            Button("Add new card", action: addNewCard).quaternaryStyle()
                        }

                        Text("Payment will be automatically taken monthly.")
                            .foregroundColor(.rythmicoGray90)
                            .rythmicoFont(.calloutBold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, .spacingMedium)
                    }
                    .padding(.bottom, .spacingMedium)
                    .animation(.rythmicoSpring(duration: .durationShort), value: phoneNumberInputError != nil)
                }
            }
            FloatingView {
                Button("Confirm Booking", action: confirmAction).primaryStyle()
            }
            .disabled(!canConfirm)
        }
        .onChange(of: availableCards, perform: availableCardsChanged)
        .sheet(isPresented: $addingNewCard) {
            AddNewCardView(availableCards: $availableCards)
        }
    }

    private func availableCardsChanged(_ cards: [Checkout.Card]) {
        if selectedCard == nil, let firstCard = cards.first {
            selectedCard = firstCard
        }
    }

    var title: String {
        ["Book", application.tutor.name.firstWord].compact().spaced()
    }

    var subtitle: [MultiStyleText.Part] {
        "Review the ".color(.rythmicoGray90) +
        "proposed lesson plan".color(.rythmicoGray90).style(.bodyBold) +
        " and ".color(.rythmicoGray90) +
        "price per lesson".color(.rythmicoGray90).style(.bodyBold) +
        " before booking".color(.rythmicoGray90)
    }

    var confirmAction: Action? {
        guard
            let phoneNumber = phoneNumber,
            let selectedCard = selectedCard
        else {
            return nil
        }
        return {

        }
    }

    var canConfirm: Bool {
        confirmAction != nil
    }

    func addNewCard() {
        Current.keyboardDismisser.dismissKeyboard()
        addingNewCard = true
    }
}

#if DEBUG
struct LessonPlanBookingView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingView(
            lessonPlan: .davidGuitarPlanStub,
            application: .davidStub,
            checkout: .stub
        )
        .environment(\.locale, Current.locale)
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
//        .environment(\.legibilityWeight, .bold)
    }
}
#endif
