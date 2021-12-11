import ComposableNavigator
import PhoneNumberKit
import SwiftUIEncore
import TutorDTO

struct LessonPlanApplicationDetailScreen: Screen {
    let application: LessonPlanApplication
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanApplicationDetailScreen) in
                    LessonPlanApplicationDetailView(application: screen.application)
                }
            )
        }
    }
}

@dynamicMemberLookup
struct LessonPlanApplicationDetailView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    @State
    private var retractionPromptSheetPresented = false
    @StateObject
    private var retractionCoordinator = Current.lessonPlanApplicationRetractionCoordinator()

    struct ViewData: Hashable {
        let title: String
        let statusDate: String
        let submittedBy: String
        let startDate: String
        let time: String
        let duration: String
        let name: String
        let age: String
        let about: String?
        let requestPrivateNote: String
        let requestPrivateNoteOpacity: Double
        let address: AddressMapCell.Source

        init(_ application: LessonPlanApplication) {
            let request = application.request
            let partialStudent = request.student
            let studentName = partialStudent.firstName // TODO: upcoming - plan.student.name ?? [...]
            let submitterName = request.submitterName // TODO: upcoming - plan.submitterName ?? [...]
            let instrument = request.instrument
            let schedule = request.schedule
            let partialAddress = request.address

            self.title = "\(studentName) - \(instrument.assimilatedName) Request"
            self.statusDate = Self.statusDateFormatter.localizedString(for: application.statusDate, relativeTo: Current.date())
            self.submittedBy = submitterName
            self.name = studentName
            self.age = String(partialStudent.age)
            self.startDate = schedule.start.formatted(custom: "d MMMM", locale: Current.locale())
            self.time = schedule.time.formatted(style: .short, locale: Current.locale())
            self.duration = schedule.duration.formatted(locale: Current.locale())
            self.requestPrivateNote = request.privateNote.isEmpty ? "None" : request.privateNote
            self.requestPrivateNoteOpacity = request.privateNote.isEmpty ? 0.5 : 1
            self.about = partialStudent.about.nilIfBlank
            self.address = .partialAddress(partialAddress) // TODO: upcoming - fullAddress
        }

        private static let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short, precise: true)
    }

    let application: LessonPlanApplication
    let viewData: ViewData
    subscript<T>(dynamicMember keyPath: KeyPath<ViewData, T>) -> T { viewData[keyPath: keyPath] }

    public init(application: LessonPlanApplication) {
        self.application = application
        self.viewData = ViewData(application)
    }

    var retractAction: Action? {
        application.status == .pending
            ? { retractionCoordinator.run(with: .init(lessonPlanApplicationID: application.id)) }
            : nil
    }

    var body: some View {
        List {
            Section(header: Text("STATUS")) {
                HStack(spacing: .grid(2)) {
                    Dot(color: application.status.color)
                    HStack(spacing: .grid(5)) {
                        Text(application.status.summary)
                            .foregroundColor(.primary)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TickingText(self.statusDate)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
            Section(header: Text("REQUEST DETAILS")) {
                TitleCell(title: "Submitted by", detail: self.submittedBy)
                // TODO: upcoming
//                lessonPlanApplication.phoneNumber.map {
//                    PhoneNumberCell(phoneNumber: $0)
//                }
            }
            Section(header: Text("LESSON SCHEDULE DETAILS")) {
                TitleCell(title: "Start Date", detail: self.startDate)
                TitleCell(title: "Time", detail: self.time)
                TitleCell(title: "Duration", detail: self.duration)
            }
            Section(header: Text("STUDENT DETAILS")) {
                TitleCell(title: "Name", detail: self.name)
                TitleCell(title: "Age", detail: self.age)
                self.about.map { about in
                    VStack(alignment: .leading, spacing: .grid(1)) {
                        Text("About")
                            .foregroundColor(.primary)
                            .font(.body)
                        Text(about)
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                    .padding(.vertical, .grid(1))
                }
            }
            Section(header: Text("PRIVATE NOTE")) {
                Text(self.requestPrivateNote)
                    .foregroundColor(.secondary.opacity(self.requestPrivateNoteOpacity))
                    .font(.body)
                    .padding(.vertical, .grid(1))
            }
            Section(
                header: Text("ADDRESS DETAILS"),
                footer: Text("Exact location and address will be provided if you're selected.")
            ) {
                AddressMapCell(source: self.address)
            }
            retractAction.map { retractAction in
                GroupedButton(title: "Retract Application", action: promptForRetraction) {
                    if retractionCoordinator.state.isLoading {
                        ActivityIndicator()
                    }
                }
                .accentColor(.red)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(self.title), displayMode: .inline)
        .actionSheet(isPresented: $retractionPromptSheetPresented) {
            ActionSheet(
                title: Text("Are you sure you'd like to retract your application?"),
                buttons: [
                    .destructive(Text("Retract"), action: retractAction),
                    .cancel()
                ]
            )
        }
        .disabled(retractionCoordinator.state.isLoading)
        .alertOnFailure(retractionCoordinator)
        .onSuccess(retractionCoordinator, perform: didRetractLessonPlanApplication)
    }

    private func promptForRetraction() {
        retractionPromptSheetPresented = true
    }

    private func didRetractLessonPlanApplication(_ retractedApplication: LessonPlanApplication) {
        Current.lessonPlanApplicationRepository.replaceById(retractedApplication)
        navigator.goBack(to: .root)
    }
}

#if DEBUG
struct LessonPlanApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailView(application: .longStub)
        // TODO: upcoming
//        LessonPlanApplicationDetailView(lessonPlanApplication: .stub(.stub(.selected)))
    }
}
#endif
