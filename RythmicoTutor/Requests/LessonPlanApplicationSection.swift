import SwiftUIEncore
import TutorDTO

struct LessonPlanApplicationSection<HeaderAccessory: View>: View {
    private let applications: [LessonPlanApplication]
    private let status: LessonPlanApplication.Status
    private let headerAccessory: HeaderAccessory

    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    init(
        applications: [LessonPlanApplication],
        status: LessonPlanApplication.Status,
        @ViewBuilder headerAccessory: () -> HeaderAccessory
    ) {
        self.applications = applications.filter { $0.status == status }
        self.status = status
        self.headerAccessory = headerAccessory()
    }

    var body: some View {
        Section(
            header: HStack(spacing: .grid(2)) {
                if header.isEmpty { EmptyView() } else { Text(header) }
                headerAccessory
            },
            footer: Group {
                if footer.isEmpty { EmptyView() } else { Text(footer) }
            }
        ) {
            ForEach(applications, content: applicationCell)
        }
    }

    private var header: String {
        switch status {
        case .pending:
            return "PENDING"
//        case .cancelled,
//             .retracted,
//             .notSelected,
//             .selected:
        case .retracted:
            return ""
        }
    }

    @ViewBuilder
    private func applicationCell(_ application: LessonPlanApplication) -> some View {
        if canNavigate {
            Button(action: { goToDetail(application) }) {
                LessonPlanApplicationCell(application: application)
            }
        } else {
            LessonPlanApplicationCell(application: application)
        }
    }

    private var canNavigate: Bool {
        switch status {
//        case .pending, .selected:
        case .pending:
            return true
//        case .notSelected, .cancelled, .retracted:
        case .retracted:
            return false
        }
    }

    private func goToDetail(_ application: LessonPlanApplication) {
        navigator.go(to: LessonPlanApplicationDetailScreen(application: application), on: currentScreen)
    }

    private var footer: String {
        switch status {
        case .pending, .retracted:
            return ""
//        case .cancelled:
//            return "These requests were cancelled by the parent/guardian. Please go to the Requests tab to find more requests."
//        case .notSelected:
//            return "Unfortunately you weren’t selected for these requests. Please go to the Requests tab to find more requests."
//        case .selected:
//            return "You’ve been selected for these requests. These lesson plans will now appear on your Schedule tab."
        }
    }
}

extension LessonPlanApplicationSection where HeaderAccessory == EmptyView {
    init(applications: [LessonPlanApplication], status: LessonPlanApplication.Status) {
        self.init(applications: applications, status: status, headerAccessory: { EmptyView() })
    }
}
