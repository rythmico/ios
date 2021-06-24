import SwiftUI
import FoundationSugar

struct LessonPlanApplicationsGridView: View {
    var lessonPlan: LessonPlan
    var applications: [LessonPlan.Application]

    var columns = Array(
        repeating: GridItem(.flexible(), spacing: .grid(4)),
        count: 2
    )

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: .grid(4)) {
                ForEach(applications, id: \.self) {
                    LessonPlanApplicationsGridLink(lessonPlan: lessonPlan, application: $0)
                }
            }
            .frame(maxWidth: .grid(.max))
            .padding(.top, .grid(2))
            .padding(.horizontal, .grid(5))
        }
    }
}

struct LessonPlanApplicationsGridLink: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application
    var action: Action {
        {
            navigator.go(
                to: LessonPlanApplicationDetailScreen(lessonPlan: lessonPlan, application: application),
                on: currentScreen
            )
            Current.analytics.track(.tutorApplicationScreenView(lessonPlan: lessonPlan, application: application))
        }
    }

    var body: some View {
        Button(action: action) {
            LessonPlanApplicationCell(application)
        }
    }
}
