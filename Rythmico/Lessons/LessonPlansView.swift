import SwiftUISugar
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
                    LessonPlanApplicationsScreen.Builder()
                    LessonPlanResumingScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlansView: View {
    @ObservedObject
    private var coordinator = Current.lessonPlanFetchingCoordinator
    @ObservedObject
    private var repository = Current.lessonPlanRepository

    var body: some View {
        TitleContentView(title: title) {
            LessonPlansCollectionView(lessonPlans: repository.items)
        }
        .backgroundColor(.rythmico.background)
        .accentColor(.rythmico.picoteeBlue)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leadingItem)
        .onAppear(perform: coordinator.startToIdle)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private var title: String { "Lesson Plans" }

    @ViewBuilder
    private var leadingItem: some View {
        if coordinator.state.isLoading {
            ActivityIndicator(color: .rythmico.foreground)
        }
    }
}

#if DEBUG
struct LessonPlansView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlansView()
    }
}
#endif
