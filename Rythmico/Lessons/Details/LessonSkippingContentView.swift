import SwiftUI

struct LessonSkippingContentView: View {
    var isFree: Bool
    var freeSkipUntil: Date
    var rearrangeUntil: Date

    var body: some View {
        VStack(spacing: .spacingMedium) {
            if isFree {
                MultiStyleText(parts: ["This will cancel your payment for this lesson."], foregroundColor: .rythmicoGray90)
                MultiStyleText(
                    parts: [
                        "Skip for ",
                        "FREE".color(.rythmicoPurple).style(.bodyBold),
                        " within ",
                        remainingTimeString(from: Current.date(), to: freeSkipUntil).style(.bodyBold),
                        ".",
                    ],
                    foregroundColor: .rythmicoGray90
                )
                InfoBanner(text:
                    """
                    If a lesson is skipped when there is less than 3 hours before it’s scheduled, then you will be charged fully.

                    We do this to protect Rythmico Tutors.
                    """
                )
                footnote
            } else {
                MultiStyleText(parts: ["You will still be charged the full amount for this lesson."], foregroundColor: .rythmicoGray90)
                InfoBanner(text:
                    """
                    Skipping a lesson for free is only available more than 3 hours before a lesson is scheduled to start.

                    We do this to protect Rythmico Tutors.
                    """
                )
                footnote
            }
        }
    }

    @ViewBuilder
    private var footnote: some View {
        if Current.date() < rearrangeUntil {
            MultiStyleText(
                parts: [
                    "If you wish to ",
                    "postpone".style(.bodyBold),
                    " this lesson instead, ",
                    "get in touch with your tutor".style(.bodyBold),
                    " and arrange it with them ",
                    "no later than 24 hours".style(.bodyBold),
                    " from the lesson start.",
                ],
                foregroundColor: .rythmicoGray90
            )
        }
    }

    private static let remainingTimeFormatter = Current.dateComponentsFormatter(allowedUnits: [.day, .hour, .minute], style: .short)
    private func remainingTimeString(from: Date, to: Date) -> String {
        let now = Current.date()
        guard let string = Self.remainingTimeFormatter.string(from: now, to: freeSkipUntil) else {
            preconditionFailure("timeRemainingFormatter returned nil for input from: \(now) to: \(freeSkipUntil)")
        }
        return string
    }
}

#if DEBUG
struct LessonSkippingContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LessonSkippingContentView(isFree: true, freeSkipUntil: Current.date() - (24, .hour), rearrangeUntil: Current.date() - (24, .hour))
            LessonSkippingContentView(isFree: false, freeSkipUntil: Current.date() - (3, .hour), rearrangeUntil: Current.date() - (3, .hour))
        }
        .padding(.spacingMedium)
    }
}
#endif
