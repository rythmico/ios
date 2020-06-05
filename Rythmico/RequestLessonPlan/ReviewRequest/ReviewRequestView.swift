import SwiftUI
import Sugar

struct ReviewRequestView: View, TestableView {
    private enum Const {
        static let headerPadding = EdgeInsets(bottom: .spacingUnit * 2)
        static let lineSpacing: CGFloat = .spacingUnit * 2
    }

    private let coordinator: LessonPlanRequestCoordinatorBase
    private let context: RequestLessonPlanContext
    private let instrument: Instrument
    private let student: Student
    private let address: AddressDetails
    private let schedule: Schedule
    private let privateNote: String

    init(
        coordinator: LessonPlanRequestCoordinatorBase,
        context: RequestLessonPlanContext,
        instrument: Instrument,
        student: Student,
        address: AddressDetails,
        schedule: Schedule,
        privateNote: String
    ) {
        self.coordinator = coordinator
        self.context = context
        self.instrument = instrument
        self.student = student
        self.address = address
        self.schedule = schedule
        self.privateNote = privateNote
    }

    func submitRequest() {
        self.coordinator.requestLessonPlan(
            LessonPlanRequestBody(
                instrument: self.instrument,
                student: self.student,
                address: self.address,
                schedule: self.schedule,
                privateNote: self.privateNote
            )
        )
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Review Proposal", subtitle: []) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: .spacingUnit * 8) {
                        SectionHeaderContentView(
                            title: "Instrument",
                            padding: Const.headerPadding,
                            accessory: editButton(performing: editInstrument)
                        ) {
                            InstrumentView(
                                viewData: .init(name: instrument.name, icon: instrument.icon, action: nil)
                            )
                        }

                        SectionHeaderContentView(
                            title: "Student Details",
                            alignment: .leading,
                            padding: Const.headerPadding,
                            accessory: editButton(performing: editStudentDetails)
                        ) {
                            HStack(alignment: .firstTextBaseline, spacing: .spacingExtraSmall) {
                                Image(decorative: Asset.infoIcon.name)
                                    .renderingMode(.template)
                                    .foregroundColor(.rythmicoGray90)
                                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 2.5 }

                                VStack(alignment: .leading, spacing: .spacingMedium) {
                                    Text(studentDetails).lineSpacing(Const.lineSpacing)
                                    MultiStyleText(style: .body, parts: studentAbout)
                                }.fixedSize(horizontal: false, vertical: true)
                            }
                            .rythmicoFont(.body)
                            .foregroundColor(.rythmicoGray90)
                        }

                        SectionHeaderContentView(
                            title: "Address Details",
                            padding: Const.headerPadding,
                            accessory: editButton(performing: editAddressDetails)
                        ) {
                            AddressItemView(
                                title: address.condensedFormattedString,
                                isSelected: false
                            )
                        }

                        SectionHeaderContentView(
                            title: "Lesson Schedule",
                            alignment: .leading,
                            padding: Const.headerPadding,
                            accessory: editButton(performing: editSchedule)
                        ) {
                            VStack(alignment: .leading, spacing: .spacingSmall) {
                                HStack(spacing: .spacingExtraSmall) {
                                    Image(decorative: Asset.infoIcon.name)
                                        .renderingMode(.template)
                                        .foregroundColor(.rythmicoGray90)
                                    MultiStyleText(style: .body, parts: [
                                        .init("Start Date: ", color: .rythmicoGray90),
                                        .init(startDateText, weight: .bold, color: .rythmicoGray90)
                                    ])
                                }
                                HStack(spacing: .spacingExtraSmall) {
                                    Image(decorative: Asset.timeIcon.name)
                                        .renderingMode(.template)
                                        .foregroundColor(.rythmicoGray90)
                                    MultiStyleText(style: .body, parts: startTimeAndDurationText)
                                }
                                HStack(spacing: .spacingExtraSmall) {
                                    Image(decorative: Asset.timeIcon.name).hidden()
                                    MultiStyleText(style: .body, parts: frequencyText)
                                }
                            }
                        }

                        privateNote.nilIfEmpty.map { privateNote in
                            SectionHeaderContentView(
                                title: "Private Note",
                                alignment: .leading,
                                padding: Const.headerPadding,
                                accessory: editButton(performing: editPrivateNote)
                            ) {
                                Text(privateNote).rythmicoFont(.body)
                                    .foregroundColor(.rythmicoGray90)
                                    .lineSpacing(Const.lineSpacing)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, .spacingMedium)
                    .padding(.bottom, .spacingExtraLarge)
                }

                FloatingView {
                    Button("Confirm Details", action: submitRequest).primaryStyle()
                }
            }
        }
        .onAppear { self.didAppear?(self) }
    }

    private func editButton(performing action: @escaping Action) -> some View {
        Button("Edit", action: action).rythmicoFont(.callout).foregroundColor(.rythmicoGray90)
    }

    private func editInstrument() { context.instrument = nil }
    private func editStudentDetails() { context.student = nil }
    private func editAddressDetails() { context.address = nil }
    private func editSchedule() { context.schedule = nil }
    private func editPrivateNote() { context.privateNote = nil }

    private var studentDetails: String {
        [
            student.name,
            studentAge(from: student.dateOfBirth),
            student.gender.name
        ].filter(\.isEmpty.not).joined(separator: .newline)
    }

    private let dateOfBirthFormatter = DateFormatter().then { $0.dateFormat = "dd-MM-yyyy" }
    private func studentAge(from dateOfBirth: Date) -> String {
        let dateOfBirthString = dateOfBirthFormatter.string(from: dateOfBirth)
        let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year.map { "(\($0) years old)" }
        return [dateOfBirthString, age].compactMap { $0 }.joined(separator: .whitespace)
    }

    private var studentAbout: [MultiStyleText.Part] {
        guard !student.about.isEmpty else { return .empty }
        let aboutHeader = ["About", student.name.firstWord].compactMap { $0 }.joined(separator: .whitespace)
        return [
            .init(aboutHeader + ":\n", weight: .bold, color: .rythmicoGray90),
            .init(student.about, color: .rythmicoGray90)
        ]
    }

    private let startDateFormatter = DateFormatter().then { $0.dateFormat = "d MMMM" }
    private var startDateText: String { startDateFormatter.string(from: schedule.startDate) }

    private let startTimeFormatter = DateFormatter().then { $0.dateFormat = "ha" }
    private var startTimeText: String { startTimeFormatter.string(from: schedule.startDate) }
    private var startTimeAndDurationText: [MultiStyleText.Part] {
        startTimeText.bold.color(.rythmicoGray90) +
        " for ".color(.rythmicoGray90) +
        "\(schedule.duration.rawValue) minutes".bold.color(.rythmicoGray90)
    }

    private let frequencyDayFormatter = DateFormatter().then { $0.dateFormat = "EEEE" }
    private var frequencyDayText: String { frequencyDayFormatter.string(from: schedule.startDate) }
    private var frequencyText: [MultiStyleText.Part] {
        "Reocurring ".color(.rythmicoGray90) + "every \(frequencyDayText)".bold.color(.rythmicoGray90)
    }
}

struct ReviewRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestView(
            coordinator: LessonPlanRequestCoordinatorDummy(),
            context: .init(),
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
        )
        .previewDevices()
    }
}
