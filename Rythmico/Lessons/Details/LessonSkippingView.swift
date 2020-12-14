import SwiftUI
import Sugar

struct LessonSkippingView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @StateObject
    private var coordinator = Current.coordinator(for: \.lessonSkippingService)!

    var lesson: Lesson
    var freeSkipUntil: Date

    @State private
    var showingConfirmationSheet = false

    init?(lesson: Lesson) {
        guard let freeSkipUntil = lesson.freeSkipUntil else {
            return nil
        }
        self.lesson = lesson
        self.freeSkipUntil = freeSkipUntil
    }

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successTitle: "Lesson Will Be Skipped",
            loadingTitle: "Skipping Lesson..."
        ) {
            NavigationView {
                VStack(spacing: 0) {
                    TitleSubtitleView(title: "Confirm Skip Lesson", subtitle: description + footnote)
                        .padding(.horizontal, .spacingMedium)
                        .fixedSize(horizontal: false, vertical: true)

                    InteractiveBackground()

                    FloatingView {
                        Button("Skip Lesson", action: onSkipButtonPressed).secondaryStyle()
                    }
                }
                .padding(.top, .spacingExtraSmall)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Group {
                        if true {
                            CloseButton(action: dismiss)
                        }
                    }
                )
            }
        }
        .sheetInteractiveDismissal(!coordinator.state.isLoading)
        .accentColor(.rythmicoGray90)
        .onSuccess(coordinator, perform: lessonSuccessfullySkipped)
        .alertOnFailure(coordinator)
        .actionSheet(isPresented: $showingConfirmationSheet) {
            ActionSheet(
                title: Text("Are you sure?"),
                message: Text("Skipping this lesson will incur the lesson fee."),
                buttons: [.destructive(Text("Skip Lesson"), action: submit), .cancel()]
            )
        }
    }

    private static let dayFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(time: .short))
    private static let timeRemainingFormatter = Current.dateComponentsFormatter(
        allowedUnits: [.day, .hour, .minute],
        style: .short,
        includesTimeRemainingPhrase: true
    )

    private var description: [MultiStyleText.Part] {
        if isFreeSkip {
            return [
                "You may skip this lesson before ",
                dayString(from: freeSkipUntil).style(.bodyBold),
                " at ",
                Self.timeFormatter.string(from: freeSkipUntil).style(.bodyBold),
                " free of charge",
                " — ",
                "\(remainingTimeString(from: Current.date(), to: freeSkipUntil)).".part,
            ]
        } else {
            return [
                "This lesson is ",
                "due very soon".style(.bodyBold),
                ", so by skipping it you will still be charged the ",
                "full price".style(.bodyBold),
                " of the lesson in your monthly invoice.",
                "\n\n",
                "This is to protect our tutors from last minute lesson skips which would negatively impact them in terms of revenue and scheduling.",
            ]
        }
    }

    private var footnote: [MultiStyleText.Part] {
        [
            "\n\n",
            "If you wish to ",
            "postpone this lesson".style(.bodyBold),
            " instead of skipping it, please ",
            "get in touch with your tutor".style(.bodyBold),
            " and arrange it with them.",
        ]
    }

    private var isFreeSkip: Bool {
        Current.date() < freeSkipUntil
    }

    private func dayString(from date: Date) -> String {
        switch true {
        case Current.calendar().isDateInToday(date): return "Today"
        case Current.calendar().isDateInTomorrow(date): return "Tomorrow"
        default: return Self.dayFormatter.string(from: date)
        }
    }

    private func remainingTimeString(from: Date, to: Date) -> String {
        let now = Current.date()
        guard let string = Self.timeRemainingFormatter.string(from: now, to: freeSkipUntil) else {
            preconditionFailure("timeRemainingFormatter returned nil for input from: \(now) to: \(freeSkipUntil)")
        }
        return string
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func submit() {
        coordinator.run(with: lesson)
    }

    private func onSkipButtonPressed() {
        if isFreeSkip {
            submit()
        } else {
            showingConfirmationSheet = true
        }
    }

    private func lessonSuccessfullySkipped(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            Current.state.lessonsContext = .none
        }
    }
}

#if DEBUG
struct LessonSkippingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonSkippingView(lesson: .scheduledStub)
    }
}
#endif
