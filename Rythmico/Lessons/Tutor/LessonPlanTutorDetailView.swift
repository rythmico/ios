import SwiftUI
import ComposableNavigator

struct LessonPlanTutorDetailScreen: Screen {
    let tutor: Tutor
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanTutorDetailScreen) in
                    LessonPlanTutorDetailView(tutor: screen.tutor)
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
    typealias HeaderView = TutorProfileHeaderView
    typealias ProfileView = TutorProfileDetailsView

    @StateObject
    private var coordinator = Current.portfolioFetchingCoordinator()

    let tutor: Tutor

    var body: some View {
        VStack(spacing: .grid(8)) {
            HeaderView(tutor: tutor)
            VStack(spacing: .grid(5)) {
                HDivider()
                ProfileView(coordinator: coordinator, tutor: tutor, topPadding: 0)
            }
        }
        .backgroundColor(.rythmico.background)
    }
}

#if DEBUG
struct LessonPlanTutorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanTutorDetailView(tutor: .charlotteStub)
    }
}
#endif
