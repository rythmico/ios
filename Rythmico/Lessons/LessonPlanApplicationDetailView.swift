import SwiftUI

struct LessonPlanApplicationDetailView: View {
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
                        LessonPlanTutorAvatarView(application.tutor, thumbnail: false)
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
                    VStack(spacing: .spacingMedium) {
                        VStack(spacing: .spacingSmall) {
                            if let privateNote = privateNote {
                                Text(privateNoteHeader)
                                    .rythmicoFont(.subheadlineBold)
                                    .foregroundColor(.rythmicoForeground)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(privateNote)
                                    .rythmicoFont(.body)
                                    .foregroundColor(.rythmicoGray90)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("No private message from \(application.tutor.name).")
                                    .rythmicoFont(.body)
                                    .foregroundColor(.rythmicoGray30)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, .spacingMedium)

                        Divider().accentColor(.rythmicoGray20)

                        VStack(spacing: .spacingSmall) {
                            HStack(spacing: .spacingSmall) {
                                Text("Lesson Schedule")
                                    .rythmicoFont(.subheadlineBold)
                                    .foregroundColor(.rythmicoForeground)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                AcceptedStatusPill()
                            }

                            ScheduleDetailsView(lessonPlan.schedule)
                        }
                        .padding(.horizontal, .spacingMedium)
                    }
                    .padding(.top, .spacingMedium)
                }
            }

            FloatingView {
                Button(bookButtonTitle, action: {}).primaryStyle()
            }
        }
    }

    private var privateNoteHeader: String {
        application.tutor.name.firstWord.map { "Private Message from \($0)" } ?? "Private Message"
    }

    private var privateNote: String? {
        application.privateNote.nilIfEmpty.map { "\"\($0)\"" }
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
