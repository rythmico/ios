import SwiftUI

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
            .padding(.top, .spacingUnit * 2)
            .padding(.horizontal, .spacingMedium)
        }
        .frame(maxWidth: .spacingMax)
    }
}

struct LessonPlanApplicationsGridLink: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @ObservedObject
    private var navigation = Current.navigation

    var body: some View {
        NavigationLink(
            destination: LessonPlanApplicationDetailView(
                lessonPlan: lessonPlan,
                application: application
            ),
            tag: application,
            selection: $navigation.lessonsNavigation.reviewingApplication
        ) {
            LessonPlanApplicationCell(application)
        }
    }
}
