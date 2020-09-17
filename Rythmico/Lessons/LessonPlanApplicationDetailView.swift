import SwiftUI

struct LessonPlanApplicationDetailView: View {
    typealias MessageView = LessonPlanApplicationDetailMessageView

    enum Tab: String, CaseIterable {
        case message = "Message"
        case about = "About"
    }

    @Environment(\.presentationMode)
    private var presentationMode

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @State private var tab: Tab = .message

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
                        Color.white
                    }
                }
            }

            FloatingView {
                Button(bookButtonTitle, action: {}).primaryStyle()
            }
        }
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
