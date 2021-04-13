import SwiftUI
import FoundationSugar

struct ReviewRequestView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    private enum Const {
        static let headerPadding = EdgeInsets(bottom: .spacingUnit * 2)
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
        TitleSubtitleContentView(title: "Review Proposal") {
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
                                    Text(studentDetails).rythmicoFont(.body)
                                    studentAbout?.rythmicoFont(.body)
                                }.fixedSize(horizontal: false, vertical: true)
                            }
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
                                Text(privateNote)
                                    .rythmicoFont(.body)
                                    .foregroundColor(.rythmicoGray90)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, .spacingMedium)
                    .padding(.bottom, .spacingExtraLarge)
                }

                FloatingView {
                    RythmicoButton("Confirm Details", style: RythmicoButtonStyle.primary(), action: submitRequest)
                }
            }
        }
        .testable(self)
    }

    private func editButton(performing action: @escaping Action) -> some View {
        Button(action: action) {
            Text("Edit").rythmicoFont(.bodyBold).foregroundColor(.rythmicoGray90)
        }
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
        ].filter(\.isEmpty.not).joined(separator: .newline)
    }

    private static let dateOfBirthFormatter = Current.dateFormatter(format: .custom("dd-MM-yyyy"))
    private func studentAge(from dateOfBirth: Date) -> String {
        let dateOfBirthString = Self.dateOfBirthFormatter.string(from: dateOfBirth)
        let age = Current.date() - (dateOfBirth, .year)
        return [dateOfBirthString, "(\(age) years old)"].compact().spaced()
    }

    private var studentAbout: Text? {
        guard !student.about.isBlank else { return nil }
        return Text(separator: .newline) {
            Text(["About", student.name.firstWord].compact().spaced() + .colon).rythmicoFontWeight(.bodyBold)
            student.about
        }
    }
}

#if DEBUG
struct ReviewRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestView(
            coordinator: Current.lessonPlanRequestCoordinator(),
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

