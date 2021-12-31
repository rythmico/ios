import SwiftUIEncore
import ComposableNavigator

struct LessonPlanApplicationsScreen: Screen {
    let lessonPlan: LessonPlan
    let applications: LessonPlan.Applications
    let presentationStyle: ScreenPresentationStyle = .push

    init?(lessonPlan: LessonPlan) {
        guard let applications = lessonPlan.applications else {
            return nil
        }
        self.lessonPlan = lessonPlan
        self.applications = applications
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanApplicationsScreen) in
                    LessonPlanApplicationsView(lessonPlan: screen.lessonPlan, applications: screen.applications)
                },
                nesting: {
                    LessonPlanApplicationDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanApplicationsView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lessonPlan: LessonPlan
    let applications: LessonPlan.Applications

    var title: String { "Tutors Available" }

    var priceInfo: String {
        "All \(instrument) tutors charge a standard rate of £\(lessonPlan.schedule.duration) per lesson"
    }

    var instrument: String {
        lessonPlan.instrument.assimilatedName.lowercased(with: Current.locale())
    }

    var body: some View {
        TitleContentView(title) { padding in
            VStack(alignment: .leading, spacing: padding.leading) {
                InfoBanner(text: priceInfo)
                    .frame(maxWidth: .grid(.max))
                    .padding(padding)

                ScrollView {
                    SelectableLazyVGrid(
                        data: applications,
                        id: \.self,
                        action: go,
                        content: LessonPlanApplicationCell.init
                    )
                }
            }
        }
        .backgroundColor(.rythmico.background)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    func go(to application: LessonPlan.Application) {
        navigator.go(
            to: LessonPlanApplicationDetailScreen(lessonPlan: lessonPlan, application: application),
            on: currentScreen
        )
        Current.analytics.track(.tutorApplicationScreenView(lessonPlan: lessonPlan, application: application))
    }
}

struct LessonPlanApplicationCell: View {
    private enum Const {
        static let avatarSize: CGFloat = .grid(14)
    }

    let application: LessonPlan.Application

    var body: some View {
        VStack(spacing: .grid(4)) {
            TutorAvatarView(application.tutor, mode: .thumbnail)
                .frame(width: Const.avatarSize, height: Const.avatarSize)
                .withSmallDBSCheck()
            Text(application.tutor.name)
                .rythmicoTextStyle(.subheadlineBold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#if DEBUG
struct LessonPlanApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LessonPlanApplicationsView(lessonPlan: .reviewingJackGuitarPlanStub, applications: .stub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraLarge)
    }
}
#endif
