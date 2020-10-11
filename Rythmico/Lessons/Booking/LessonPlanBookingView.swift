import SwiftUI
import PhoneNumberKit

struct LessonPlanBookingView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @State var phoneNumber: PhoneNumber?
    @State var phoneNumberInputError: Error?

    var body: some View {
        TitleSubtitleContentView(title: title, subtitle: subtitle) {
            ScrollView {
                VStack(spacing: .spacingLarge) {
                    SectionHeaderContentView(title: "Lesson Schedule") {
                        ScheduleDetailsView(lessonPlan.schedule, tutor: application.tutor)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    SectionHeaderContentView(title: "Contact Number") {
                        VStack(spacing: .spacingSmall) {
                            MultiStyleText(parts: contactNumberInstructions)
                            VStack(spacing: .spacingExtraSmall) {
                                PhoneNumberField($phoneNumber, inputError: $phoneNumberInputError)
                                    .padding(.horizontal, .spacingUnit * 2.5)
                                    .modifier(RoundedThinOutlineContainer(padded: false))
                                if let error = phoneNumberInputError {
                                    Text(error.localizedDescription)
                                        .rythmicoFont(.callout)
                                        .foregroundColor(.rythmicoRed)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .transition(
                                            AnyTransition
                                                .opacity
                                                .combined(with: .offset(x: 0, y: -.spacingMedium))
                                        )
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    SectionHeaderContentView(title: "Price Per Lesson") {
                        VStack(spacing: .spacingExtraSmall) {
                            MultiStyleText(parts: price)
                            Text(priceExplanation)
                                .lineSpacing(3)
                                .rythmicoFont(.callout)
                                .foregroundColor(.rythmicoGray90)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, .spacingMedium)
                .animation(.rythmicoSpring(duration: .durationShort), value: phoneNumberInputError != nil)
            }
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

    var contactNumberInstructions: [MultiStyleText.Part] {
        "Enter a contact number of the ".color(.rythmicoGray90) +
        "parent/guardian".style(.bodyBold).color(.rythmicoGray90) +
        " of the student.".color(.rythmicoGray90)
    }

    var price: [MultiStyleText.Part] {
        "£60".style(.headline).color(.rythmicoGray90) +
        " per lesson".color(.rythmicoGray90)
    }

    var priceExplanation: String {
        "This is based on the standard £60 per hour rate for all guitar tutors for the specific date and time selected."
    }
}

#if DEBUG
struct LessonPlanBookingView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingView(lessonPlan: .davidGuitarPlanStub, application: .davidStub)
            .environment(\.locale, Current.locale)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
//            .environment(\.legibilityWeight, .bold)
    }
}
#endif
