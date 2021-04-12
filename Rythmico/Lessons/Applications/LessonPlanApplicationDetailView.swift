import SwiftUI

struct LessonPlanApplicationDetailView: View {
    typealias HeaderView = LessonPlanApplicationDetailHeaderView
    typealias MessageView = LessonPlanApplicationDetailMessageView
    typealias AboutView = LessonPlanApplicationDetailAboutView

    enum Tab: String, CaseIterable {
        case message = "Message"
        case about = "About"
    }

    @State
    private var tab: Tab = .message
    @StateObject
    private var coordinator = Current.portfolioFetchingCoordinator()

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingSmall) {
                HeaderView(lessonPlan: lessonPlan, application: application)
                TabMenuView(tabs: Tab.allCases, selection: $tab)
            }

            switch tab {
            case .message:
                MessageView(lessonPlan: lessonPlan, application: application)
            case .about:
                AboutView(coordinator: coordinator, tutor: application.tutor)
            }

            FloatingView {
                VStack(spacing: .spacingUnit * 2) {
                    Button(bookButtonTitle, action: book).primaryStyle()
                    frequencyText.lineSpacing(6).multilineTextAlignment(.center)
                }
            }
        }
    }

    private var bookButtonTitle: String {
        application.tutor.name.firstWord.map { "Book \($0)" } ?? "Book"
    }

    private func book() {
        Current.state.lessonsContext.isBookingLessonPlan = true
    }

    private static let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDayText: String { Self.frequencyDayFormatter.string(from: lessonPlan.schedule.startDate) }
    private var frequencyText: Text {
        Text(separator: .whitespace) {
            "Lessons recurring"
            "every \(frequencyDayText)".text.rythmicoFont(.calloutBold)
        }
        .foregroundColor(.rythmicoGray90)
        .rythmicoFont(.callout)
    }
}

#if DEBUG
struct LessonPlanApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailView(lessonPlan: .reviewingJackGuitarPlanStub, application: .jesseStub)
    }
}
#endif
