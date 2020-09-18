import SwiftUI

struct LessonPlanApplicationDetailView: View {
    typealias MessageView = LessonPlanApplicationDetailMessageView
    typealias AboutView = LessonPlanApplicationDetailAboutView

    enum Tab: String, CaseIterable {
        case message = "Message"
        case about = "About"
    }

    @Environment(\.presentationMode)
    private var presentationMode

    @StateObject
    private var coordinator: APIActivityCoordinator<GetPortfolioRequest>

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @State private var tab: Tab = .message

    init?(lessonPlan: LessonPlan, application: LessonPlan.Application) {
        guard let coordinator = Current.sharedCoordinator(for: \.portfolioFetchingService) else {
            return nil
        }
        self.lessonPlan = lessonPlan
        self.application = application
        self._coordinator = .init(wrappedValue: coordinator)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: .spacingExtraLarge) {
                    VStack(spacing: .spacingExtraSmall) {
                        LessonPlanTutorAvatarView(application.tutor, mode: .thumbnailToOriginal)
                            .frame(width: .spacingUnit * 24, height: .spacingUnit * 24)
                        VStack(spacing: .spacingUnit) {
                            Text(application.tutor.name)
                                .rythmicoFont(.largeTitle)
                                .foregroundColor(.rythmicoForeground)
                            Text(lessonPlan.instrument.name + " Tutor")
                                .rythmicoFont(.callout)
                                .foregroundColor(.rythmicoGray90)
                        }
                    }
                    .padding(.horizontal, .spacingMedium)

                    TabMenuView(tabs: Tab.allCases, selection: $tab)
                }

                ScrollView {
                    switch tab {
                    case .message:
                        MessageView(lessonPlan: lessonPlan, application: application)
                    case .about:
                        AboutView(coordinator: coordinator, tutor: application.tutor)
                    }
                }
            }

            FloatingView {
                Button(bookButtonTitle, action: {}).primaryStyle()
            }
        }
        .onDisappear(perform: coordinator.cancel)
    }

    private var bookButtonTitle: String {
        application.tutor.name.firstWord.map { "Book \($0)" } ?? "Book"
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
