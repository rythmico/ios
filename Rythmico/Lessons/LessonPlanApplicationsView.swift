import SwiftUI

struct LessonPlanApplicationsView: View {
    @Environment(\.presentationMode)
    private var presentationMode

    var lessonPlan: LessonPlan
    var applications: [LessonPlan.Application]

    init?(_ lessonPlan: LessonPlan) {
        guard let applications = lessonPlan.status.reviewingValue else {
            return nil
        }
        self.lessonPlan = lessonPlan
        self.applications = applications
    }

    var body: some View {
        Text("")
            .navigationBarBackButtonItem(BackButton(title: "Lessons", action: back))
    }

    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
