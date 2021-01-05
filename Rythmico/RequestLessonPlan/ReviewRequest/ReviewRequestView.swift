import SwiftUI
import Sugar

struct ReviewRequestView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    private enum Const {
        static let headerPadding = EdgeInsets(bottom: .spacingUnit * 2)
        static let lineSpacing: CGFloat = .spacingUnit * 2
    }

    private let coordinator: Coordinator
    private let context: RequestLessonPlanContext
    private let instrument: Instrument
    private let student: Student
    private let address: Address
    private let schedule: Schedule
    private let privateNote: String

    init(
        coordinator: Coordinator,
        context: RequestLessonPlanContext,
        instrument: Instrument,
        student: Student,
        address: Address,
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
        coordinator.run(
            with: .init(
                instrument: instrument,
                student: student,
                address: address,
                schedule: schedule,
                privateNote: privateNote
            )
        )
    }

    let inspection = SelfInspection()
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
                                viewData: .init(name: instrument.standaloneName, icon: instrument.icon, action: nil)
                            )
                        }

                        SectionHeaderContentView(
                            title: "Student Details",
                            alignment: .leading,
                            padding: Const.headerPadding,
                            accessory: editButton(performing: editStudentDetails)
                        ) {
                            HStack(alignment: .firstTextBaseline, spacing: .spacingExtraSmall) {
                                Image(decorative: Asset.iconInfo.name)
                                    .renderingMode(.template)
                                    .foregroundColor(.rythmicoGray90)
                                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 2.5 }

                                VStack(alignment: .leading, spacing: .spacingMedium) {
                                    Text(studentDetails).lineSpacing(Const.lineSpacing)
                                    MultiStyleText(parts: studentAbout)
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
                            ScheduleDetailsView(schedule, tutor: nil)
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
        .testable(self)
    }

    private func editButton(performing action: @escaping Action) -> some View {
        Button("Edit", action: action).rythmicoFont(.bodyBold).foregroundColor(.rythmicoGray90)
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

    private let dateOfBirthFormatter = Current.dateFormatter(format: .custom("dd-MM-yyyy"))
    private func studentAge(from dateOfBirth: Date) -> String {
        let dateOfBirthString = dateOfBirthFormatter.string(from: dateOfBirth)
        let age = Current.calendar().diff(from: dateOfBirth, to: Current.date(), in: .year)
        return [dateOfBirthString, "(\(age) years old)"].compact().spaced()
    }

    private var studentAbout: [MultiStyleText.Part] {
        guard !student.about.isEmpty else { return .empty }
        let aboutHeader = ["About", student.name.firstWord].compact().spaced()
        return [
            (aboutHeader + ":\n").style(.bodyBold).color(.rythmicoGray90),
            student.about.color(.rythmicoGray90)
        ]
    }
}

#if DEBUG
struct ReviewRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestView(
            coordinator: Current.coordinator(for: \.lessonPlanRequestService)!,
            context: RequestLessonPlanContext(),
            instrument: .guitar,
            student: .davidStub,
            address: .stub,
            schedule: .stub,
            privateNote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta odio dolor, eget sodales turpis mollis semper."
        )
        .previewDevices()
    }
}
#endif
