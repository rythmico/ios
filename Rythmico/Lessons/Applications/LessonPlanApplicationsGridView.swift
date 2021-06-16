import SwiftUI
import FoundationSugar

struct LessonPlanApplicationsGridView: View {
    var lessonPlan: LessonPlan
    var applications: [LessonPlan.Application]

    var columns = Array(
        repeating: GridItem(.flexible(), spacing: .spacingSmall),
        count: 2
    )

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: .spacingSmall) {
                ForEach(applications, id: \.self) {
                    LessonPlanApplicationsGridLink(lessonPlan: lessonPlan, application: $0)
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.top, .spacingUnit * 2)
            .padding(.horizontal, .spacingMedium)
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
