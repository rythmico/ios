import SwiftUI
import ComposableNavigator

struct LessonPlanTutorDetailScreen: Screen {
    var lessonPlan: LessonPlan
    var tutor: Tutor
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanTutorDetailScreen) in
                    LessonPlanTutorDetailView(lessonPlan: screen.lessonPlan, tutor: screen.tutor)
                },
                nesting: {
                    VideoCarouselPlayerScreen.Builder()
                    PhotoCarouselDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanTutorDetailView: View {
    typealias HeaderView = LessonPlanApplicationDetailHeaderView
    typealias PortfolioView = LessonPlanApplicationDetailAboutView

    @StateObject
    private var coordinator = Current.portfolioFetchingCoordinator()

    // TODO: consume 'tutor.instruments' to remove this property.
    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        VStack(spacing: .grid(7)) {
            HeaderView(lessonPlan: lessonPlan, tutor: tutor)
            PortfolioView(coordinator: coordinator, tutor: tutor, topPadding: 0)
        }
        .backgroundColor(.rythmicoBackground)
    }
}

#if DEBUG
struct LessonPlanTutorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanTutorDetailView(lessonPlan: .pendingCharlottePianoPlanStub, tutor: .charlotteStub)
    }
}
#endif
