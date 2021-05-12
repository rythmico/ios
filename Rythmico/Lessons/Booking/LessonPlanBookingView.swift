import SwiftUI
import TextBuilder
import PhoneNumberKit
import NonEmpty
import FoundationSugar

struct LessonPlanBookingView: View {
    private var lessonPlan: LessonPlan
    private var application: LessonPlan.Application
    private var checkout: Checkout
    @StateObject
    private var coordinator = Current.lessonPlanCompleteCheckoutCoordinator()

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

    @State private var availableCards: [Card]
    @State private var selectedCard: Card?
    @State private var addingNewCard = false

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successContent: LessonPlanConfirmationView.init,
            loadingTitle: "Processing booking..."
        ) {
            VStack(spacing: 0) {
                TitleSubtitleContentView(title: title, subtitle: subtitle) {
                    ScrollView {
                        VStack(spacing: .spacingLarge) {
                            Group {
                                SectionHeaderContentView(title: "Lesson Schedule") {
                                    LessonPlanRequestedScheduleView(lessonPlan.schedule, tutor: application.tutor)
                                    HDivider()
                                    VStack(spacing: .spacingExtraSmall) {
                                        LessonPlanBookingPolicyView.skipLessons
                                        LessonPlanBookingPolicyView.cancelAnytime
                                        LessonPlanBookingPolicyView.trustedTutors
                                    }
                                }

                                SectionHeaderContentView(title: "Contact Number") {
                                    PhoneNumberInputView(phoneNumber: $phoneNumber, phoneNumberInputError: $phoneNumberInputError)
                                }
                            }
                            .frame(maxWidth: .spacingMax)
                            .padding(.horizontal, .spacingMedium)

                            VStack(spacing: .spacingSmall) {
                                SectionHeaderContentView(title: "Payment Method", padding: EdgeInsets(horizontal: .spacingMedium)) {
                                    if
                                        let availableCards = NonEmpty(rawValue: availableCards),
                                        let selectedCardBinding = Binding($selectedCard)
                                    {
                                        CardStackView(cards: availableCards, selectedCard: selectedCardBinding)
                                    }
                                }

                                HDividerContainer {
                                    RythmicoButton("Add new card", style: RythmicoLinkButtonStyle.quaternary(), action: addNewCard)
                                }
                                .frame(maxWidth: .spacingMax)

                                LessonPlanBookingPriceView(price: checkout.pricePerLesson)
                                    .frame(maxWidth: .spacingMax)
                                    .padding(.horizontal, .spacingSmall)
                            }
                        }
                        .padding(.bottom, .spacingMedium)
                        .animation(.rythmicoSpring(duration: .durationShort), value: phoneNumberInputError != nil)
                    }
                }
                FloatingView {
                    RythmicoButton("Confirm Booking", style: RythmicoButtonStyle.primary(), action: confirmAction)
                }
                .disabled(!canConfirm)
            }
            .onChange(of: availableCards, perform: availableCardsChanged)
            .sheet(isPresented: $addingNewCard) {
                AddNewCardEntryView(availableCards: $availableCards)
            }
        }
        .onSuccess(coordinator, perform: checkoutSucceeded)
        .alertOnFailure(coordinator)
    }

    private func availableCardsChanged(_ cards: [Card]) {
        selectedCard = cards.last
    }

    var title: String {
        ["Book", application.tutor.name.firstWord].compact().spaced()
    }

    @SpacedTextBuilder
    var subtitle: Text {
        "Review the"
        "proposed lesson plan".text.rythmicoFontWeight(.bodyBold)
        "and"
        "price per lesson".text.rythmicoFontWeight(.bodyBold)
        "before booking"
    }

    var confirmAction: Action? {
        guard
            let phoneNumber = phoneNumber,
            let selectedCard = selectedCard
        else {
            return nil
        }
        return {
            coordinator.run(
                with: .init(
                    lessonPlanId: lessonPlan.id,
                    applicationId: application.tutor.id,
                    body: .init(phoneNumber: phoneNumber, cardId: selectedCard.id)
                )
            )
        }
    }

    var canConfirm: Bool {
        confirmAction != nil
    }

    func addNewCard() {
        Current.keyboardDismisser.dismissKeyboard()
        addingNewCard = true
    }

    func checkoutSucceeded(_ lessonPlan: LessonPlan) {
        Current.lessonPlanRepository.replaceById(lessonPlan)
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
//        .environment(\.colorScheme, .dark)
//        .environment(\.locale, Current.locale)
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
//        .environment(\.legibilityWeight, .bold)
    }
}
#endif
