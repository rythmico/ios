import SwiftUI

struct LessonPlanApplicationDetailView: View {
    typealias HeaderView = LessonPlanApplicationDetailHeaderView
    typealias MessageView = LessonPlanApplicationDetailMessageView
    typealias AboutView = LessonPlanApplicationDetailAboutView

    enum Tab: String, CaseIterable {
        case message = "Message"
        case about = "About"
    }

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var tab: Tab = .message
    @StateObject
    private var coordinator = Current.coordinator(for: \.portfolioFetchingService)!
    @State
    private var showingBookingView = false

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: .spacingExtraLarge) {
                    HeaderView(lessonPlan: lessonPlan, application: application, expanded: tab == .message)
                    TabMenuView(tabs: Tab.allCases, selection: $tab)
                }

                switch tab {
                case .message:
                    MessageView(lessonPlan: lessonPlan, application: application)
                case .about:
                    AboutView(coordinator: coordinator, tutor: application.tutor)
                }
            }

            NavigationLink(
                destination: LessonPlanBookingEntryView(lessonPlan: lessonPlan, application: application),
                isActive: $showingBookingView
            ) {
                FloatingView {
                    Button(bookButtonTitle, action: book).primaryStyle()
                }
            }
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: tab)
    }

    private var bookButtonTitle: String {
        application.tutor.name.firstWord.map { "Book \($0)" } ?? "Book"
    }

    private func book() {
        showingBookingView = true
    }

    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct LessonPlanApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailView(lessonPlan: .reviewingJackGuitarPlanStub, application: .jesseStub)
    }
}
#endif
