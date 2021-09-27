import SwiftUIEncore
import PhoneNumberKit

struct LessonPlanBookingView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

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

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successContent: LessonPlanConfirmationView.init,
            loadingTitle: "Processing booking..."
        ) {
            VStack(spacing: 0) {
                TitleSubtitleContentView(title, subtitle) { padding in
                    ScrollView {
                        VStack(spacing: .grid(5)) {
                            SectionHeaderContentView("Plan Details", style: .box) {
                                LessonPlanRequestedScheduleView(lessonPlan.schedule, tutor: application.tutor)
                            }
                            .frame(maxWidth: .grid(.max))
                            .padding(.horizontal, .grid(4))

                            VStack(spacing: .grid(3)) {
                                LessonPlanBookingPolicyView.trustedTutors
                                LessonPlanBookingPolicyView.skipLessons(freeBeforePeriod: checkout.policies.skipFreeBeforePeriod)
                                LessonPlanBookingPolicyView.pauseLessonPlans
                                LessonPlanBookingPolicyView.cancelAnytime(freeBeforePeriod: checkout.policies.cancelFreeBeforePeriod)
                            }
                            .padding(padding)

                            HeadlineContentView("Contact Number") { padding in
                                PhoneNumberInputView(phoneNumber: $phoneNumber, phoneNumberInputError: $phoneNumberInputError)
                                    .padding(padding)
                            }
                            .frame(maxWidth: .grid(.max))

                            VStack(spacing: .grid(3)) {
                                HeadlineContentView("Payment Method", spacing: .grid(3)) { padding in
                                    if
                                        let availableCards = NonEmpty(rawValue: availableCards),
                                        let selectedCardBinding = Binding($selectedCard)
                                    {
                                        PaymentMethodChoiceList(cards: availableCards, selectedCard: selectedCardBinding)
                                            .padding(padding)
                                    }
                                }

                                HDividerContainer {
                                    RythmicoButton("Add payment method", style: .quaternary(), action: addNewCard)
                                }
                                .frame(maxWidth: .grid(.max))
                            }

                            LessonPlanPriceView(price: checkout.pricePerLesson, showTermsOfService: true)
                                .frame(maxWidth: .grid(.max))
                                .padding(.horizontal, .grid(4))
                        }
                        .padding(.bottom, padding.trailing)
                        .animation(.rythmicoSpring(duration: .durationShort), value: phoneNumberInputError != nil)
                    }
                }
                FloatingView {
                    RythmicoButton("Confirm Booking", style: .primary(), action: confirmAction)
                }
                .disabled(!canConfirm)
            }
            .onChange(of: availableCards, perform: availableCardsChanged)
        }
        .navigationBarTitle(title)
        .navigationBarItems(trailing: closeButton)
        .onSuccess(coordinator, perform: checkoutSucceeded)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private var closeButton: some View {
        if !coordinator.state.isSuccess() {
            CloseButton { navigator.dismiss(screen: currentScreen) }
        }
    }

    private func availableCardsChanged(_ cards: [Card]) {
        selectedCard = cards.last
    }

    var title: String {
        ["Book", application.tutor.name.firstWord].compacted().spaced()
    }

    @SpacedTextBuilder
    var subtitle: Text {
        "Review the"
        "proposed lesson plan".text.rythmicoFontWeight(.subheadlineMedium)
        "and"
        "price per lesson".text.rythmicoFontWeight(.subheadlineMedium)
        "before booking"
    }

    var confirmAction: Action? {
        unwrap(phoneNumber, selectedCard).mapToAction { phoneNumber, selectedCard in
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
        navigator.go(to: AddNewCardEntryScreen(availableCards: $availableCards), on: currentScreen)
    }

    func checkoutSucceeded(_ lessonPlan: LessonPlan) {
        Current.lessonPlanRepository.replaceById(lessonPlan)
        Current.analytics.track(.lessonPlanBooked(lessonPlan))
    }
}

#if DEBUG
struct LessonPlanBookingView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingView(
            lessonPlan: .pendingDavidGuitarPlanStub,
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
