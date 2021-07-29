import SwiftUISugar

struct LessonSkippingContentView: View {
    var isFree: Bool
    var policy: Lesson.Options.Skip.Policy

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(5)) {
            if isFree {
                Group {
                    Text("This will cancel your payment for this lesson.").rythmicoTextStyle(.body)
                    Text(separator: .whitespace) {
                        "Skip for"
                        "FREE".text.foregroundColor(.rythmico.purple).rythmicoFontWeight(.bodyBold)
                        "within"
                        remainingTimeString.text.rythmicoFontWeight(.bodyBold) + String.period.text
                    }
                    .rythmicoTextStyle(.body)
                }
                .foregroundColor(.rythmico.foreground)

                InfoBanner(text:
                    """
                    If a lesson is skipped less than \(cutoffString) before the start of the lesson, then you will be charged fully.

                    We do this to protect Rythmico Tutors.
                    """
                )
            } else {
                Text("You will still be charged the full amount for this lesson.")
                    .foregroundColor(.rythmico.foreground)
                    .rythmicoTextStyle(.body)

                InfoBanner(text:
                    """
                    As per our policy, lessons can only be skipped free of charge no less than \(cutoffString) before the lesson is scheduled to start.

                    We do this to protect Rythmico Tutors.
                    """
                )
            }
        }
    }

    private static let cutoffFormatter = Current.dateComponentsFormatter(allowedUnits: [.hour, .minute], style: .full)
    private var cutoffString: String { Self.cutoffFormatter.string(from: policy.freeBeforePeriod) !! preconditionFailure("nil for input '\(policy.freeBeforePeriod)'") }

    private static let remainingTimeFormatter = Current.dateComponentsFormatter(allowedUnits: [.day, .hour, .minute], style: .short)
    private var remainingTimeString: String {
        let now = Current.date()
        return Self.remainingTimeFormatter.string(from: now, to: policy.freeBeforeDate) !! preconditionFailure(
            "remainingTimeFormatter returned nil for input 'from' \(now) 'to' \(policy.freeBeforeDate)"
        )
    }
}

#if DEBUG
struct LessonSkippingContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LessonSkippingContentView(isFree: true, policy: .stub)
            LessonSkippingContentView(isFree: false, policy: .stub)
        }
        .padding(.grid(5))
    }
}
#endif
