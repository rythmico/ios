import SwiftUI
import ComposableNavigator

struct LessonPlanApplicationDetailScreen: Screen {
    let lessonPlan: LessonPlan
    let application: LessonPlan.Application
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanApplicationDetailScreen) in
                    LessonPlanApplicationDetailView(
                        lessonPlan: screen.lessonPlan,
                        application: screen.application
                    )
                },
                nesting: {
                    VideoCarouselPlayerScreen.Builder()
                    PhotoCarouselDetailScreen.Builder()
                    LessonPlanBookingEntryScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanApplicationDetailView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    typealias HeaderView = LessonPlanApplicationDetailHeaderView
    typealias AboutView = LessonPlanApplicationDetailAboutView
    typealias MessageView = LessonPlanApplicationDetailMessageView

    enum Tab: String, CaseIterable {
        case about = "About"
        case message = "Message"
    }

    @State
    private var tab: Tab = .about
    @StateObject
    private var coordinator = Current.portfolioFetchingCoordinator()

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .grid(4)) {
                HeaderView(lessonPlan: lessonPlan, tutor: application.tutor)
                TabMenuView(tabs: Tab.allCases, selection: $tab)
            }

            switch tab {
            case .about:
                AboutView(coordinator: coordinator, tutor: application.tutor)
            case .message:
                MessageView(lessonPlan: lessonPlan, application: application)
            }

            FloatingView {
                VStack(spacing: .grid(2)) {
                    RythmicoButton(bookButtonTitle, style: .primary(), action: book)
                    frequencyText
                }
            }
        }
        .backgroundColor(.rythmico.background)
    }

    private var bookButtonTitle: String {
        application.tutor.name.firstWord.map { "Book \($0)" } ?? "Book"
    }

    private func book() {
        navigator.go(to: LessonPlanBookingEntryScreen(lessonPlan: lessonPlan, application: application), on: currentScreen)
        Current.analytics.track(.bookTutorScreenView(lessonPlan: lessonPlan, application: application))
    }

    private static let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDayText: String { Self.frequencyDayFormatter.string(from: lessonPlan.schedule.startDate) }
    private var frequencyText: some View {
        Text(separator: .whitespace) {
            "Lessons recurring"
            "every \(frequencyDayText)".text.rythmicoFontWeight(.calloutBold)
        }
        .rythmicoTextStyle(.callout)
        .foregroundColor(.rythmico.foreground)
        .multilineTextAlignment(.center)
    }
}

#if DEBUG
struct LessonPlanApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailView(lessonPlan: .reviewingJackGuitarPlanStub, application: .jesseStub)
    }
}
#endif
