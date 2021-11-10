import StudentDTO
import SwiftUIEncore

struct LessonPlanRequestConfirmationView: View, TestableView {
    @Environment(\.navigator)
    private var navigator

    let lessonPlanRequest: LessonPlanRequest

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth: CGFloat = .grid(18)

    var title: String {
        ["\(lessonPlanRequest.instrument.assimilatedName) Lessons", "Request Submitted!"].joined(separator: "\n")
    }

    var subtitle: String {
        "Potential tutors have received your request and will submit applications for your consideration."
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: .grid(8)) {
                        VStack(spacing: .grid(6)) {
                            Image(uiImage: lessonPlanRequest.instrument.icon.resized(width: iconWidth))
                                .renderingMode(.template)
                                .foregroundColor(.rythmico.foreground)

                            VStack(spacing: .grid(4)) {
                                Text(title)
                                    .foregroundColor(.rythmico.foreground)
                                    .rythmicoTextStyle(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .foregroundColor(.rythmico.foreground)
                                        .rythmicoTextStyle(.body)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, .grid(5))
                    .padding(.vertical, .grid(6))
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }

            FloatingView {
                RythmicoButton("Continue", style: .primary(), action: doContinue)
            }
        }
        .testable(self)
    }

    func doContinue() {
        Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
        // Either, depending on which tab we're on.
        navigator.goBack(to: LessonPlansScreen())
        navigator.goBack(to: LessonsScreen())
    }
}

#if DEBUG
struct LessonPlanRequestConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestConfirmationView(lessonPlanRequest: .stub)
    }
}
#endif
