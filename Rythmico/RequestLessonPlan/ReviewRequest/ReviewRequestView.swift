import SwiftUISugar

struct ReviewRequestView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    var coordinator: Coordinator
    var flow: RequestLessonPlanFlow
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String

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
                    VStack(spacing: .grid(4)) {
                        SectionHeaderContentView(
                            "Selected Instrument",
                            style: .box,
                            accessory: { editButton(action: resetInstrument) }
                        ) {
                            InstrumentView(instrument: instrument)
                        }

                        SectionHeaderContentView(
                            "Student Details",
                            style: .box,
                            accessory: { editButton(action: resetStudentDetails) }
                        ) {
                            HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
                                Image(decorative: Asset.Icon.Label.info.name)
                                    .renderingMode(.template)
                                    .foregroundColor(.rythmico.foreground)
                                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 2.5 }

                                VStack(alignment: .leading, spacing: .grid(5)) {
                                    Text(studentDetails).rythmicoTextStyle(.body)
                                    studentAbout?.rythmicoTextStyle(.body)
                                }.fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundColor(.rythmico.foreground)
                        }

                        SectionHeaderContentView(
                            "Address Details",
                            style: .box,
                            accessory: { editButton(action: resetAddressDetails) }
                        ) {
                            Text(address.condensedFormattedString)
                                .rythmicoTextStyle(.body)
                                .foregroundColor(.rythmico.foreground)
                        }

                        SectionHeaderContentView(
                            "Lesson Schedule",
                            style: .box,
                            accessory: { editButton(action: resetSchedule) }
                        ) {
                            LessonPlanRequestedScheduleView(schedule, tutor: nil)
                        }

                        SectionHeaderContentView(
                            "Private Note",
                            style: .box,
                            accessory: { editButton(action: resetPrivateNote) }
                        ) {
                            if let privateNote = privateNote.nilIfBlank {
                                Text(privateNote)
                                    .rythmicoTextStyle(.body)
                                    .foregroundColor(.rythmico.foreground)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Text("No private note.")
                                    .rythmicoTextStyle(.body)
                                    .foregroundColor(.rythmico.textPlaceholder)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .onTapGesture(perform: resetPrivateNote)
                            }
                        }
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding(.trailing, .grid(4))
                    .padding(.bottom, .grid(7))
                }
                .padding(.leading, .grid(4))

                FloatingView {
                    RythmicoButton("Confirm Details", style: .primary(), action: submitRequest)
                }
            }
        }
        .testable(self)
    }

    private func editButton(action: @escaping Action) -> some View {
        RythmicoButton(
            "EDIT",
            style: .tertiary(layout: .constrained(.xs)),
            action: action
        )
    }

    private func resetInstrument() { flow.instrument = nil }
    private func resetStudentDetails() { flow.student = nil }
    private func resetAddressDetails() { flow.address = nil }
    private func resetSchedule() { flow.schedule = nil }
    private func resetPrivateNote() { flow.privateNote = nil }

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
        return [dateOfBirthString, "(\(age) years old)"].compacted().spaced()
    }

    private var studentAbout: Text? {
        guard !student.about.isBlank else { return nil }
        return Text(separator: .newline) {
            Text(["About", student.name.firstWord].compacted().spaced() + .colon).rythmicoFontWeight(.bodyMedium)
            student.about
        }
    }
}

#if DEBUG
struct ReviewRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestView(
            coordinator: Current.lessonPlanRequestCoordinator(),
            flow: RequestLessonPlanFlow(),
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

