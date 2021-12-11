import ComposableNavigator
import SwiftUIEncore
import TutorDTO

struct LessonPlanApplicationGroupScreen: Screen {
    let applications: [LessonPlanApplication]
    let status: LessonPlanApplication.Status
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanApplicationGroupScreen) in
                    LessonPlanApplicationGroupView(applications: screen.applications, status: screen.status)
                },
                nesting: {
                    LessonPlanApplicationDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanApplicationGroupView: View {
    let applications: [LessonPlanApplication]
    let status: LessonPlanApplication.Status

    var body: some View {
        List {
            LessonPlanApplicationSection(applications: applications, status: status)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
    }

    private var title: String {
        [status.title, "Requests"].spaced()
    }
}

#if DEBUG
struct LessonPlanApplicationGroupView_Previews: PreviewProvider {
    static var pendingStatus: LessonPlanApplication.Status { .pending }
    static var retractedStatus: LessonPlanApplication.Status { .retracted(try! Current.date() - (10, .second, .neutral)) }

    static var previews: some View {
        Group {
            LessonPlanApplicationGroupView(applications: [.stub(pendingStatus)], status: pendingStatus)
            LessonPlanApplicationGroupView(applications: [.stub(retractedStatus)], status: retractedStatus)
        }
        .previewLayout(.fixed(width: 370, height: 170))
    }
}
#endif
