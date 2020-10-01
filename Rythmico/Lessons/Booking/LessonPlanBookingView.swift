import SwiftUI
import PhoneNumberKit

struct LessonPlanBookingView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @State var phoneNumber: PhoneNumber?

    var body: some View {
        TitleSubtitleContentView(title: title, subtitle: subtitle) {
            ScrollView {
                VStack(spacing: .spacingLarge) {
                    SectionHeaderView(title: "Lesson Schedule")
                    ScheduleDetailsView(lessonPlan.schedule, tutor: application.tutor)
                        .fixedSize(horizontal: false, vertical: true)

                    SectionHeaderView(title: "Contact Number")
                    VStack(spacing: .spacingSmall) {
                        MultiStyleText(parts: contactNumberInstructions)
                        PhoneNumberField($phoneNumber, defaultRegion: Current.locale.regionCode)
                            .padding(.horizontal, .spacingUnit * 2.5)
                            .modifier(RoundedThinOutlineContainer(padded: false))
                    }
                }
                .padding(.horizontal, .spacingMedium)
            }
        }
    }

    var title: String {
        ["Book", application.tutor.name.firstWord].compact().spaced()
    }

    var subtitle: [MultiStyleText.Part] {
        ["Review the proposed lesson plan and price per lesson before booking".part]
    }

    var contactNumberInstructions: [MultiStyleText.Part] {
        "Enter a contact number of the ".color(.rythmicoGray90) +
        "parent/guardian".style(.bodyBold).color(.rythmicoGray90) +
        " of the student.".color(.rythmicoGray90)
    }
}

struct LessonPlanBookingView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingView(lessonPlan: .davidGuitarPlanStub, application: .davidStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
