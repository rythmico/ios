import SwiftUI

struct LessonPlanApplicationsGridView: View {
    var lessonPlan: LessonPlan
    var applications: [LessonPlan.Application]

    @Binding
    var selectedApplication: LessonPlan.Application?

    var columns = Array(
        repeating: GridItem(.flexible(), spacing: .spacingSmall),
        count: 2
    )

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: .spacingSmall) {
                ForEach(applications, id: \.self) { application in
                    NavigationLink(
                        destination: LessonPlanApplicationDetailView(
                            lessonPlan: lessonPlan,
                            application: application
                        ),
                        tag: application,
                        selection: $selectedApplication,
                        label: { LessonPlanApplicationCell(application) }
                    )
                }
            }
            .padding(.top, .spacingUnit * 2)
            .padding(.horizontal, .spacingMedium)
        }
        .frame(maxWidth: .spacingMax)
    }
}
