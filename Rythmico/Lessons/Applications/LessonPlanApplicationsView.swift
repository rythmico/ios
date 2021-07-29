import SwiftUISugar
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
    let lessonPlan: LessonPlan
    let applications: LessonPlan.Applications

    var title: String { "Tutors Available" }

    var priceInfo: String {
        "All \(instrument) tutors charge a standard rate of £\(lessonPlan.schedule.duration) per lesson"
    }

    var instrument: String {
        lessonPlan.instrument.assimilatedName.lowercased(with: Current.locale)
    }

    var body: some View {
        TitleContentView(title: title) {
            VStack(alignment: .leading, spacing: .grid(4)) {
                InfoBanner(text: priceInfo)
                    .frame(maxWidth: .grid(.max))
                    .padding(.horizontal, .grid(5))

                LessonPlanApplicationsGridView(
                    lessonPlan: lessonPlan,
                    applications: applications
                )
            }
        }
        .backgroundColor(.rythmico.background)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonPlanApplicationCell: View {
    private enum Const {
        static let avatarSize: CGFloat = .grid(14)
    }

    var application: LessonPlan.Application

    init(_ application: LessonPlan.Application) {
        self.application = application
    }

    var body: some View {
        Container(style: .outline()) {
            VStack(spacing: .grid(4)) {
                TutorAvatarView(application.tutor, mode: .thumbnail)
                    .frame(width: Const.avatarSize, height: Const.avatarSize)
                    .withSmallDBSCheck()
                Text(application.tutor.name)
                    .rythmicoTextStyle(.bodyBold)
                    .foregroundColor(.rythmico.foreground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.vertical, .grid(6))
            .padding(.horizontal, .grid(4))
        }
        .frame(maxWidth: .infinity)
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
