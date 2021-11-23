import SwiftUIEncore
import ComposableNavigator

struct LessonPlansScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlansScreen) in
                    LessonPlansView()
                },
                nesting: {
                    LessonPlanDetailScreen.Builder()

                    LessonPlanPausingScreen.Builder()
                    LessonPlanResumingScreen.Builder()
                    LessonPlanCancellationScreen.Builder()

                    LessonPlanApplicationsScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlansView: View {
    @StateObject
    private var coordinator = Current.lessonPlanFetchingCoordinator()
    @ObservedObject
    private var repository = Current.lessonPlanRepository

    var body: some View {
        TitleContentView(title) { _ in
            LessonPlansCollectionView(isLoading: coordinator.state.isLoading, lessonPlans: repository.items)
        }
        .backgroundColor(.rythmico.background)
        .accentColor(.rythmico.picoteeBlue)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: coordinator.startToIdle)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private var title: String { "Lesson Plans" }
}

#if DEBUG
struct LessonPlansView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlansView()
    }
}
#endif
