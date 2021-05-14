import SwiftUI
import ComposableNavigator

struct LessonPlanApplicationsScreen: Screen {
    let lessonPlan: LessonPlan
    let presentationStyle: ScreenPresentationStyle = .push

    init?(lessonPlan: LessonPlan) {
        guard lessonPlan.status.isReviewing else { return nil }
        self.lessonPlan = lessonPlan
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanApplicationsScreen) in
                    LessonPlanApplicationsView(screen.lessonPlan)
                },
                nesting: {
                    LessonPlanApplicationDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanApplicationsView: View {
    private var lessonPlan: LessonPlan
    private var applications: [LessonPlan.Application]

    init?(_ lessonPlan: LessonPlan) {
        guard let applications = lessonPlan.status.reviewingValue else {
            return nil
        }
        self.lessonPlan = lessonPlan
        self.applications = applications
    }

    var priceInfo: String {
        "All \(instrument) tutors charge a standard rate of £\(lessonPlan.schedule.duration) per lesson"
    }

    var instrument: String {
        lessonPlan.instrument.assimilatedName.lowercased(with: Current.locale)
    }

    var body: some View {
        TitleContentView(title: "Tutors Available") {
            VStack(alignment: .leading, spacing: .spacingSmall) {
                InfoBanner(text: priceInfo)
                    .frame(maxWidth: .spacingMax)
                    .padding(.horizontal, .spacingMedium)

                LessonPlanApplicationsGridView(
                    lessonPlan: lessonPlan,
                    applications: applications
                )
            }
        }
        .backgroundColor(.rythmicoBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonPlanApplicationCell: View {
    private enum Const {
        static let avatarSize = .spacingUnit * 14
    }

    var application: LessonPlan.Application

    init(_ application: LessonPlan.Application) {
        self.application = application
    }

    var body: some View {
        VStack(spacing: .spacingSmall) {
            TutorAvatarView(application.tutor, mode: .thumbnail)
                .frame(width: Const.avatarSize, height: Const.avatarSize)
                .withSmallDBSCheck()
            Text(application.tutor.name)
                .rythmicoTextStyle(.bodyBold)
                .foregroundColor(.rythmicoForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.vertical, .spacingLarge)
        .padding(.horizontal, .spacingSmall)
        .frame(maxWidth: .infinity)
        .modifier(RoundedShadowContainer())
    }
}

#if DEBUG
struct LessonPlanApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LessonPlanApplicationsView(.reviewingJackGuitarPlanStub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraLarge)
    }
}
#endif
